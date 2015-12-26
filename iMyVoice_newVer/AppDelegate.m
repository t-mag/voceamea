

//
//  AppDelegate.m
//  iMyVoice_newVer
//
//  Created by Simona Tzalik on 16/4/15.
//  Copyright (c) 2015 Techno M.A.G. All rights reserved.
//

#import "AppDelegate.h"
#import "EditBoard_viewcontroller.h"
#import "Globals.h"
#import "GlobalsFunctions_class.h"
#import "Images_class.h"
#import "BoardsList_class.h"
#import "XMLmanager_class.h"

@interface AppDelegate () <NSXMLParserDelegate>

@property GlobalsFunctions_class* globalFuncs;
@end

@implementation AppDelegate
@synthesize arrayOfImages,arrayOfBoards,dictPurchasedPackages,arrayOfLoadedBoard,iTotalUserImages,HomepageBoard,flgEditBoardNavBack,arrayOfNavigationStackBoards;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"])
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunchedOnce"];
        
        
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    [self initVariables];
    [self loadFromUserDefaults];
    [self loadImages4List];
    [self loadBoards4List];
    //sort arrayOfBoards by date descending
    
    NSSortDescriptor *sort=[NSSortDescriptor sortDescriptorWithKey:@"brdDate" ascending:NO];
    [arrayOfBoards sortUsingDescriptors:[NSArray arrayWithObject:sort]];
    //
    
   // [self loadLastUsedMainBoard];
    
    // 05-2015 - Assuming that is the WIDGIT package that the user has bought
    [dictPurchasedPackages setObject:@"WIDGIT" forKey:@1];
   // [dictPurchasedPackages setObject:@2 forKey:@"SYMBOLSTIX"];
    //[dictPurchasedPackages setObject:@3 forKey:@"PCS"];


    
    return YES;
}

-(void)initVariables
{
    arrayOfImages = [[NSMutableArray alloc]init];
    arrayOfBoards = [[NSMutableArray alloc]init];
    arrayOfLoadedBoard = [[NSMutableArray alloc]init];
    arrayOfNavigationStackBoards = [[NSMutableArray alloc]init];
    dictPurchasedPackages = [[NSMutableDictionary alloc]init];
    [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"mybool"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    flgEditBoardNavBack = NO;
   
}

-(void)loadFromUserDefaults
{
    // Get the stored data before the view loads
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"homepageboard"] != nil) {
        self.HomepageBoard = [defaults objectForKey:@"homepageboard"];
    }
   // nTotalUserImages = [NSNumber numberWithInteger:[[defaults objectForKey:@"userimageslastindex"] integerValue]];
    
    
//    NSString *firstName = [defaults objectForKey:@"firstName"];
//    NSString *lastName = [defaults objectForKey:@"lastname"];
//    
//    int age = [defaults integerForKey:@"age"];
//    NSString *ageString = [NSString stringWithFormat:@"%i",age];
//    
//    NSData *imageData = [defaults dataForKey:@"image"];
//    UIImage *contactImage = [UIImage imageWithData:imageData];
//    
//    // Update the UI elements with the saved data
//    firstNameTextField.text = firstName;
//    lastNameTextField.text = lastName;
//    ageTextField.text = ageString;
//    contactImageView.image = contactImage;
    
}


-(void)loadBoards4List
{
 
    // load all the boards that are local into the arrayOfBoards
    // the boards are loaded into class BoardsList according to the info in xml file
    // the boards' XML file exists at /Library/boards/
    // it's filename is - boards_list.xml
    
    NSError* error;
    NSString* fileXML;
    NSData* data;
    _globalFuncs = [[GlobalsFunctions_class alloc]init];
    
    NSString* dirBoards=[_globalFuncs getFullDirectoryPathfor:BOARDS_MAIN_FOLDER];
    
    fileXML = [dirBoards stringByAppendingPathComponent:@"boards_list.xml"];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:fileXML];
    if (fileExists) {
        
        NSXMLParser* parser;
        data = [[NSData alloc]initWithContentsOfFile:fileXML];
        parser = [[NSXMLParser alloc]initWithData:data];
        parser.delegate=self;
        
        [parser parse];
        
    }
    else
    {
        // for some reason the file boards_list.xml has been deleted. Recreate it according to the files existing in this dir
        NSLog(@"File boards_list.xml can't be found");
        
        NSArray* boardsFolderContents = [[NSFileManager defaultManager]contentsOfDirectoryAtPath:dirBoards error:&error];
        
        if ([boardsFolderContents count]>0) {
            
            XMLmanager_class* xmlManager = [[XMLmanager_class alloc]init];
            [xmlManager createBoardsList_fromBoardsFolder:boardsFolderContents];
            
            [self loadBoards4List];
        }
    
    }

}
-(void)loadImages4List
{
    // load all the images that are local into the arrayOfImages
    // the images are loaded into class Images according to the info in xml file
    // the images' XML file exists at /Library/symbols/
    
    // for all symbols from server - filename is - images_list.xml
    // for images from camera - filename is - imagesUser_list.xml
    
    //NSError* error;
    NSString* fileXML;
    NSData* data;
    _globalFuncs = [[GlobalsFunctions_class alloc]init];
    
    NSString* dirMainSymbols=[_globalFuncs getFullDirectoryPathfor:SYMBOLS_MAIN_FOLDER];
    
    // retrieve the info for all symbols from server
    fileXML = [dirMainSymbols stringByAppendingPathComponent:@"images_list.xml"];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:fileXML];
    if (fileExists) {

        NSXMLParser* parser;
        data = [[NSData alloc]initWithContentsOfFile:fileXML];
        parser = [[NSXMLParser alloc]initWithData:data];
        parser.delegate=self;
        
        [parser parse];

    }
    else
        NSLog(@"File for IMAGES local parse can't be found");
    
    
    // retrieve the info for images from camera
    fileXML = [dirMainSymbols stringByAppendingPathComponent:@"imagesUser_list.xml"];
    fileExists = [[NSFileManager defaultManager] fileExistsAtPath:fileXML];
    if (fileExists) {
        
        NSXMLParser* parser;
        data = [[NSData alloc]initWithContentsOfFile:fileXML];
        parser = [[NSXMLParser alloc]initWithData:data];
        parser.delegate=self;
        
        [parser parse];
        
    }
    else
        NSLog(@"File for USER IMAGES local parse can't be found");

    
}

// Read XML File
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    
    if ([elementName isEqualToString:@"image"]) {
        
        
        //add data to Images_class
        Images_class* imgX=[[Images_class alloc]init];
      
        imgX.imgIndex = [attributeDict objectForKey:@"index"];
        
        // checking if the current image has IU prefix - image from user folder
        // if so, store its current number
        // the number indicates the index of the images from user
        // this number is used as index that increaseas when the user decides to add an image from camera or photos library
        NSRange range= [imgX.imgIndex rangeOfString:PREFIX_USER_IMAGES];
        if (range.length != 0) {
            NSString* str = [_globalFuncs removeFilePrefix:imgX.imgIndex prefixIs:PREFIX_USER_IMAGES];
            iTotalUserImages = [str integerValue];
        }
        

        imgX.imgCategory = [attributeDict objectForKey:@"category"];
        imgX.imgCreatedBy = [attributeDict objectForKey:@"createdby"];
        imgX.imgCreatedDate = [attributeDict objectForKey:@"createddate"];
        imgX.imgDescription = [attributeDict objectForKey:@"description"];
        imgX.imgLastUpdatedBy=[attributeDict objectForKey:@"lastupdatedby"];
        imgX.imgLastUpdatedDate=[attributeDict objectForKey:@"lastupdateddate"];
        imgX.imgPath = [attributeDict objectForKey:@"path"];
        imgX.imgFileName = [attributeDict objectForKey:@"filename"];
        imgX.imgShowName = [attributeDict objectForKey:@"showname"];
        imgX.imgPrompt =[attributeDict objectForKey:@"prompt"];
        imgX.imgType =[attributeDict objectForKey:@"type"];
        
        [arrayOfImages addObject:imgX];
    }
    
    
    if ([elementName isEqualToString:@"board"]) {
        
        
        //add data as BoardsList_class into arrayOfBoards
        BoardsList_class* brdX=[[BoardsList_class alloc]init];
        
       // + (UIImage *)imageWithData:(NSData *)data;
//        
//       NSString *byteArray = [attributeDict objectForKey:@"icon"];
//        
//        NSData *data = [NSData dataWithBytes:(__bridge const void *)(byteArray) length:NSDataBase64Encoding64CharacterLineLength];
        
        brdX.brdIcon = [attributeDict objectForKey:@"icon"];
        brdX.brdFileName = [attributeDict objectForKey:@"filename"];
        brdX.brdDate = [attributeDict objectForKey:@"date"];
        brdX.brdID = [[attributeDict objectForKey:@"id"] intValue];
        
        [arrayOfBoards addObject:brdX];
    }

    
    
//        // update to main UI
//        NSNumber* totFiles = [NSNumber numberWithInteger:arrayOfImagesRecords.count];
//        NSNotificationCenter* notificationcenter = [NSNotificationCenter defaultCenter];
//        [notificationcenter postNotificationName:@"updateprogress" object:totFiles] ;
//        
        
        

}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    //check notifications
//    EditBoard_viewcontroller* editboardVC = [[EditBoard_viewcontroller alloc]init];
//    
//    UIImage* imgFromNotification = [[UIImage alloc]init];
//    NSNotificationCenter* notificationCenter = [NSNotificationCenter defaultCenter];
//    [notificationCenter addObserver:self selector:nil name:@"imageFromCamera" object:imgFromNotification];
    
  
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
