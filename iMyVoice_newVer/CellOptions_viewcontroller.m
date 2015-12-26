//
//  CellOptions_viewcontroller.m
//  iMyVoice_newVer
//
//  Created by Simona Tzalik on 25/4/15.
//  Copyright (c) 2015 Techno M.A.G. All rights reserved.
//

#import "CellOptions_viewcontroller.h"
#import "EditBoard_viewcontroller.h"
//#import "PopupMenu_viewcontroller.h"
#import "Globals.h"
#import "GlobalsFunctions_class.h"
#import "IQAudioRecorderController.h"
#import "AppDelegate.h"
#import "Images_class.h"
//#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "NEOColorPickerViewController.h"
#import "VoiceRecorder.h"
#import "ImageList_TableViewCell.h"
#import "XMLManager_class.h"



@interface CellOptions_viewcontroller () <UIImagePickerControllerDelegate,UIWebViewDelegate,IQAudioRecorderControllerDelegate,NEOColorPickerViewControllerDelegate,UITableViewDataSource,UITableViewDelegate,UISearchDisplayDelegate,UIAlertViewDelegate>

@property UIImagePickerController* picker;
@property UIPopoverController* popover;
@property BOOL isReturnFromCamera;
//@property PopupMenu_viewcontroller* popupmenuVC;
@property PBWebViewController* webbrowserVC;
@property (nonatomic, strong) UIColor *currentColor;
@property AppDelegate* appDelegate;
@property NSArray* arraySearchResults;
@property GlobalsFunctions_class* globalFuncs;

@property CGRect viewSize;

//// RECORDING....
//
//@property AVAudioRecorder *_audioRecorder;
//@property SCSiriWaveformView *musicFlowView;
//@property NSString *_recordingFilePath;
//@property BOOL _isRecording;
//@property CADisplayLink *meterUpdateDisplayLink;

@end

@implementation CellOptions_viewcontroller
@synthesize imgCamera,btnCamera,btnOK,webBrowser,strPurpose;
//@synthesize delegate = _delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _picker = [[UIImagePickerController alloc]init];
    _picker.delegate=self;
    
    _globalFuncs = [[GlobalsFunctions_class alloc]init];

    _isReturnFromCamera=NO;
    
    //[_tblImageList setDataSource:self];
   // [_tblImageList setDelegate:self];
    _appDelegate = DELEGATE;
    
    //_arrayListOfImages = [[NSMutableArray alloc]init];
    _arraySearchResults = [[NSMutableArray alloc]init];
    
    _webbrowserVC = [[PBWebViewController alloc]init];
   
    //Notifications
    NSNotificationCenter* notificationcenter = [NSNotificationCenter defaultCenter];
    [notificationcenter addObserver:self selector:@selector(getImagesList) name:@"imagelist" object:nil];
    
}


- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    // convert strPurpose values to numbers for use of switch
    int iPurpose=99;
    if ([strPurpose isEqualToString:@"LIST"])
        iPurpose = 4;
    if ([strPurpose isEqualToString:@"CAMERA"])
        iPurpose = 3;
    if ([strPurpose isEqualToString:@"WEB"])
        iPurpose = 0;
    if ([strPurpose isEqualToString:@"SOUND"])
        iPurpose = 1;
    if ([strPurpose isEqualToString:@"COLOR_BCK"])
        iPurpose = 2;

    
    
    switch (iPurpose) {
        case 0: //web
        {
            self.view.superview.bounds = CGRectMake(0, 0, 300 , 200);
            [self setObjectsOnScreen];
            break;
        }
        case 1: //record sound
        {
            self.view.superview.bounds= CGRectMake(0, 0, 300 , 200);
            _viewSize = self.view.bounds;
            [self setObjectsOnScreen];
            
            break;
        }
        case 2: //background color
        {
            self.view.superview.bounds= CGRectMake(0, 0, 300 , 200);
            _viewSize = self.view.bounds;
            [self setObjectsOnScreen];
            
            break;
        }
        case 3: //camera
        {
            NSLog(@"viewWillLayoutSubviews-CAMERA");
            
//            self.view.superview.bounds= CGRectMake(0, 0, self.view.frame.size.width-170, self.view.frame.size.height-100);
//            _viewSize = self.view.bounds;
//             [self setObjectsOnScreen];
            
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
                UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:_picker];
                [popover presentPopoverFromRect:self.view.bounds inView:_picker.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
               // [popover presentPopoverFromRect:self.selectedImageView.bounds inView:self.selectedImageView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
               // _popover = popover;
            } else {
                [self presentModalViewController:_picker animated:YES];
            }
            
            
            break;
        }
        case 4: //list
        {
            NSLog(@"viewWillLayoutSubviews-LIST");
            
//            self.view.superview.bounds= CGRectMake(0, 0, 200 , 300);
//            _viewSize = self.view.bounds;
//            [self setObjectsOnScreen];
            break;
        }
            
    
        default:
        {
            self.view.superview.bounds = CGRectMake(0, 0, self.view.frame.size.width-170, self.view.frame.size.height-100);
            [self setObjectsOnScreen];
            break;
        }
    }
    
    
}


-(void)viewDidAppear:(BOOL)animated
{
 
    //[self setPreferredContentSize:CGSizeMake(400, 250)];
   // [_tblImageList reloadData];

    if (_isReturnFromCamera) {
        _isReturnFromCamera=NO;
    }
    else{
        // check for what the viewcontroller should show
        if ([strPurpose isEqualToString:@"LIST"]) {
            //list of images
           // [self showList];
                   }
        if ([strPurpose isEqualToString:@"CAMERA"]) {
            //camera
            NSLog(@"viewDidAppear-CAMERA");
            [self showCamera];
        }
        if ([strPurpose isEqualToString:@"PHOTOES"]) {
            //photoes
            [self showPhotoes];
        }
        if ([strPurpose isEqualToString:@"WEB"]) {
            //web
            [self showBrowser];
        }
        if ([strPurpose isEqualToString:@"SOUND"]) {
            //record sound
           // [self showRecorder];
        }
        if ([strPurpose isEqualToString:@"COLOR_BCK"]) {
            //record sound
           // [self showColors];
        }

        if ([strPurpose isEqualToString:@"COLOR_FRAME"]) {
            //record sound
           // [self showColors];
        }

    }

}


    

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setObjectsOnScreen
{
    float WW = self.view.frame.size.width;
    float HH = self.view.frame.size.height;
    
    // check for what the viewcontroller should show
    
    //LIST
    //===========
    if ([strPurpose isEqualToString:@"LIST"]) {
        //list of images
        //camera
        NSLog(@"setObjectsOnScreen-LIST");
       // _searchBar.frame= CGRectMake( 20, 20, 200,50);
       // _tblImageList.frame=CGRectMake(20,70, 200, 300);
    }
    
    //CAMERA
    //===========
    if ([strPurpose isEqualToString:@"CAMERA"] || [strPurpose isEqualToString:@"PHOTOES"]) {
        //camera
        NSLog(@"setObjectsOnScreen-CAMERA/PHOTOES");
        imgCamera.frame=CGRectMake(20, 20, WW-40, HH-100);
        btnCamera.frame=CGRectMake(imgCamera.frame.origin.x, imgCamera.frame.origin.y+imgCamera.frame.size.height+20, btnCamera.frame.size.width, btnCamera.frame.size.height);
        btnOK.frame=CGRectMake(imgCamera.frame.origin.x+imgCamera.frame.size.width-btnOK.frame.size.width, imgCamera.frame.origin.y+imgCamera.frame.size.height+20, btnOK.frame.size.width, btnOK.frame.size.height);
    }

    //WEB
    //===========
    if ([strPurpose isEqualToString:@"WEB"]) {
        
        //  webBrowser.scalesPageToFit=YES;
        _webbrowserVC = [[PBWebViewController alloc] init];
        _webbrowserVC.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
        [self showBrowser];
        
        // webBrowser.autoresizingMask = UIViewAutoresizingNone;
        // webBrowser.autoresizesSubviews = NO;
        //        btnCamera.frame=CGRectMake(imgCamera.frame.origin.x, imgCamera.frame.origin.y+imgCamera.frame.size.height+50, btnCamera.frame.size.width, btnCamera.frame.size.height);
        //        btnOK.frame=CGRectMake(imgCamera.frame.origin.x+imgCamera.frame.size.width-btnOK.frame.size.width, imgCamera.frame.origin.y+imgCamera.frame.size.height+50, btnOK.frame.size.width, btnOK.frame.size.height);
    }

    //SOUND
    //===========
    if ([strPurpose isEqualToString:@"SOUND"]) {
        
        //        _musicFlowView = [[SCSiriWaveformView alloc] initWithFrame:self.view.bounds];
        //        _musicFlowView.translatesAutoresizingMaskIntoConstraints = NO;
        //        [self.view addSubview:_musicFlowView];
        //       // self.view = view;
        
        UIButton* btnRec = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnRec addTarget:self action:@selector(btnRec_isClicked) forControlEvents:UIControlEventTouchUpInside];
        // [btnRec setTitle:@"Show View" forState:UIControlStateNormal];
        
        UIButton* btnPlay = [[UIButton alloc]init];
        [btnRec addTarget:self action:@selector(btnPlay_isClicked) forControlEvents:UIControlEventTouchUpInside];
        UIButton* btnStop = [[UIButton alloc]init];
        [btnRec addTarget:self action:@selector(btnStop_isClicked) forControlEvents:UIControlEventTouchUpInside];
        UIButton* btnSave = [[UIButton alloc]init];
        [btnRec addTarget:self action:@selector(btnSave_isClicked) forControlEvents:UIControlEventTouchUpInside];
        
        [btnRec setImage:[UIImage imageNamed:@"record_icon.png"] forState:UIControlStateNormal];
        [btnSave setImage:[UIImage imageNamed:@"save_as.png"] forState:UIControlStateNormal];
        [btnPlay setImage:[UIImage imageNamed:@"resultset_next.png"] forState:UIControlStateNormal];
        [btnStop setImage:[UIImage imageNamed:@"stop.ico"] forState:UIControlStateNormal];
        
        btnRec.frame=CGRectMake(10, HH-(HH/3)-30, 100, 100);
        btnPlay.frame=CGRectMake(60, HH-(HH/3)-30, 100, 100);
        btnStop.frame=CGRectMake(110, HH-(HH/3)-30, 100, 100);
        btnSave.frame=CGRectMake(160, HH-(HH/3)-30, 100, 100);
        
        [self.view addSubview:btnPlay];
        [self.view addSubview:btnRec];
        [self.view addSubview:btnStop];
        [self.view addSubview:btnSave];
        
        
    }
    
//      if ([strPurpose isEqualToString:@"COLORS_BCK"]) {
//          
//          
//          
//      }
    
    
    
}

- (void)webViewDidFinishLoad:(UIWebView *)theWebView
{
    CGSize contentSize = theWebView.scrollView.contentSize;
    CGSize viewSize = self.view.bounds.size;
    
    float rw = viewSize.width / contentSize.width;
    
    theWebView.scrollView.minimumZoomScale = rw;
    theWebView.scrollView.maximumZoomScale = rw;
    theWebView.scrollView.zoomScale = rw;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark -
#pragma mark Handling Symbols

-(void)showList
{
   // _arrayListOfImages = [self getRecords4Table];
   // [_tblImageList reloadData];
}

-(void)showCamera
{
    NSLog(@"showCamera-CAMERA");
    UIImagePickerControllerSourceType type = UIImagePickerControllerSourceTypeCamera;
    
    _picker.modalPresentationStyle = UIModalPresentationCurrentContext;
    _picker.allowsEditing = YES;
    _picker.sourceType = type;
    [self presentViewController:_picker animated:YES completion:nil];
    
}

-(void)showPhotoes
{
    UIImagePickerControllerSourceType type = UIImagePickerControllerSourceTypePhotoLibrary;
    
    _picker.modalPresentationStyle = UIModalPresentationCurrentContext;
    _picker.allowsEditing = YES;
    _picker.sourceType = type;
    [self presentViewController:_picker animated:YES completion:nil];

}

-(void)showBrowser
{
    
    
   // if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
  
   // }
    
    
    PBSafariActivity *activity = [[PBSafariActivity alloc] init];
   
    _webbrowserVC.URL = [NSURL URLWithString:@"http://www.google.com"];
    _webbrowserVC.applicationActivities = @[activity];
    _webbrowserVC.excludedActivityTypes = @[UIActivityTypeMail, UIActivityTypeMessage, UIActivityTypePostToWeibo];
    [_webbrowserVC load];
    
    [self presentViewController:_webbrowserVC animated:YES completion:nil];
    

//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
//        [self.navigationController pushViewController:self.webViewController animated:YES];
//    } else {
   // _webbrowserVC.clearsSelectionOnViewWillAppear = NO;
    
    
//    }
    //[webBrowser setDelegate:self];
    //NSURL* defaultURL = [NSURL URLWithString:@"http://www.google.com"];
    //NSURLRequest* requestURL = [NSURLRequest requestWithURL:defaultURL];
    //[webBrowser loadRequest:requestURL];
    
}

//-(void)showRecorder
//{
//}


- (IBAction)btnReturnImage:(UIButton *)sender {
// button caption is OK
   
    
    [_picker.mediaTypes objectAtIndex:0];
    
    // save the image to photo gallery
    UIImageWriteToSavedPhotosAlbum(imgCamera.image, nil, nil, nil);
    
    UIAlertView* msgbox = [[UIAlertView alloc]initWithTitle:@"Save Photo" message:@"Please insert the name of the photo" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
    
    msgbox.alertViewStyle = UIAlertViewStylePlainTextInput;
    [msgbox show];
    
   
}



- (IBAction)btnShowCamera:(UIButton *)sender {
    [self showCamera];

}

#pragma -
#pragma mark UIAlertViewDelegate

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        
        //resize photo to something smaler because camera makes HEAVY images
        UIImage* smallPhoto = [_globalFuncs resizeImage:imgCamera.image];
        NSData * imageData = UIImagePNGRepresentation(smallPhoto);
        
        NSError* error;
        NSFileManager* filemanager = [NSFileManager defaultManager];
        NSString* dirLibrary = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
        NSString* dirMainSymbols = [dirLibrary stringByAppendingPathComponent:SYMBOLS_MAIN_FOLDER];
        
        NSString* dirUser = [dirMainSymbols stringByAppendingPathComponent:SYMBOLS_FOLDER_FROM_USER];
        
        [filemanager createDirectoryAtPath:dirUser withIntermediateDirectories:YES attributes:nil error:&error];
        
        NSString* imageFilename = [NSString stringWithFormat:@"%@.png",[alertView textFieldAtIndex:0].text];
        NSString* imgFilename = [dirUser stringByAppendingPathComponent:imageFilename];
        
        [imageData writeToFile:imgFilename atomically:NO];

        
        Images_class* imgX = [[Images_class alloc]init];
        BOOL isImageOK = [imgX updateImageClasswithShowName:[alertView textFieldAtIndex:0].text
                        andwithDescription:@""
                        andwithFileName:[[alertView textFieldAtIndex:0].text stringByAppendingPathExtension:@"png"]
                        andwithPath:dirUser
                        andwithCategory:@""
                        andwithUpdatedDate:[NSDate date]
                        andwithUpdatedDateby:@"admin"
                        andwithPrompt:nil
                        andwithType:nil
                        andwithIndex:nil];
        
        if (isImageOK) {
            
            //add to array of images the new image
            [_appDelegate.arrayOfImages addObject:imgX];
            
            //Recreate the xml file with the new image in it
            XMLmanager_class* xml = [[XMLmanager_class alloc]init];
            [xml createImagesLocalXMLfile:@"Images_List" andwith:_appDelegate.arrayOfImages];
            
            // send notification - user choosed an image
            NSNotificationCenter* notificationCenter = [NSNotificationCenter defaultCenter];
            [notificationCenter postNotificationName:@"imageFromCamera" object:imgX];
        }
        else
            NSLog(@"Error creating Images_class after CAMERA");
    }
}




#pragma mark -
#pragma mark ListImages TableView Delegate

//-(void)getImagesList:(NSNotification*)notification
//{
//    //_arrayListOfImages = notification.object;
//    
//}

//#pragma mark SearchController
//-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
//{
//    //receiving the letters user typed and updating the _arraySearchResults
//    NSPredicate* resultPredicate = [NSPredicate predicateWithFormat:@"imgShowName contains[c] %@",searchText];
//    _arraySearchResults = [_appDelegate.arrayOfImages filteredArrayUsingPredicate:resultPredicate];
//    
//}
//
//-(BOOL)searchDisplayController:(UISearchDisplayController*)controller shouldReloadTableForSearchString:(NSString *)searchString
//{
//    //user began searching - he is typing
//    //collecting the current letters and passing to "filterContentForSearchText"
//    NSString* scope = [controller.searchBar.scopeButtonTitles objectAtIndex:controller.searchBar.selectedScopeButtonIndex];
//    [self filterContentForSearchText:searchString scope:scope];
//    return YES;
//}


#pragma mark --------------
#pragma mark UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [imgCamera setImage:image];
    
    _isReturnFromCamera=YES;
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

//#pragma mark -
//#pragma mark Colors Funcs
//
//- (void)colorPickerViewController:(NEOColorPickerBaseViewController *)controller didSelectColor:(UIColor *)color {
//    self.view.backgroundColor = color;
//    [controller dismissViewControllerAnimated:YES completion:nil];
//}
//
//- (void)colorPickerViewControllerDidCancel:(NEOColorPickerBaseViewController *)controller {
//    [controller dismissViewControllerAnimated:YES completion:nil];
//}
//

          
@end
