//
//  ViewController.m
//  iMyVoice_newVer
//
//  Created by Simona Tzalik on 16/4/15.
//  Copyright (c) 2015 Techno M.A.G. All rights reserved.
//

#import "MainScreen_viewcontroller.h"
#import "NewBoardOptions_viewcontroller.h"
#import "RunBoard_viewcontroller.h"
#import "DeviceFuncs.h"
#import "XMLmanager_class.h"
#import "AppDelegate.h"
#import "EditBoard_viewcontroller.h"

@interface MainScreen_viewcontroller ()


@property (weak, nonatomic) IBOutlet UIImageView *imgTitle;
@property (weak, nonatomic) IBOutlet UIImageView *imgBtn_LetsTalk;
@property (weak, nonatomic) IBOutlet UIImageView *imgBtn_EditBoards;
@property (weak, nonatomic) IBOutlet UILabel *lbl_LetsTalk;
@property (weak, nonatomic) IBOutlet UILabel *lbl_EditBoards;
@property XMLmanager_class* retrieveData;
@property AppDelegate* appDelegate;


@property DeviceFuncs* myDevice;
@end

@implementation MainScreen_viewcontroller
@synthesize lblUpdateServerProgress;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _myDevice = [[DeviceFuncs alloc]init];
    _appDelegate = DELEGATE;
    
    
    
   }
-(void)viewDidAppear:(BOOL)animated
{
    //place objects on screen
    [self arrangeObjectsOnScreen];
    
    NSNotificationCenter* notificationcenter = [NSNotificationCenter defaultCenter];
    [notificationcenter addObserver:self selector:@selector(updateprogress:) name:@"updateprogress" object:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
   
    if ([segue.identifier isEqual:@"segEditBoard"])
    {
        
        NewBoardOptions_viewcontroller* newBoardVC = segue.destinationViewController;
        newBoardVC.modalTransitionStyle =  UIModalTransitionStyleFlipHorizontal;
    }
    
    if ([segue.identifier isEqual:@"segLetsTalk"])
    {
        
        _appDelegate.flgRunBoardMode = YES;
       // RunBoard_viewcontroller* runBoardVC = segue.destinationViewController;
        EditBoard_viewcontroller* editBoardVC = segue.destinationViewController;
        editBoardVC.modalTransitionStyle =  UIModalTransitionStyleFlipHorizontal;
    }
    
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.

}

#pragma mark Misc Funcs

-(void)arrangeObjectsOnScreen
{
    int WW = [_myDevice DeviceSize].width;
    int HH = [_myDevice DeviceSize].height;
    
    // set Title
    float X = (WW-_imgTitle.frame.size.width)/2;
    float Y = (HH-_imgTitle.frame.size.height)/5;
    _imgTitle.frame = CGRectMake( X, Y, _imgTitle.frame.size.width, _imgTitle.frame.size.height);
    
    // set LetsTalk icon
    X=(WW-_imgBtn_LetsTalk.frame.size.width-300-_imgBtn_EditBoards.frame.size.width)/2;
    Y=_imgTitle.frame.origin.y+_imgTitle.frame.size.height+100;
    _imgBtn_LetsTalk.frame = CGRectMake(X, Y, _imgBtn_LetsTalk.frame.size.width, _imgBtn_LetsTalk.frame.size.height);
    
    //set LetsTalk label
    _lbl_LetsTalk.frame = CGRectMake(_imgBtn_LetsTalk.frame.origin.x+50, _imgBtn_LetsTalk.frame.origin.y+_imgBtn_LetsTalk.frame.size.height, _lbl_LetsTalk.frame.size.width, _lbl_LetsTalk.frame.size.height);

    // set EditBoards icon
    X=_imgBtn_LetsTalk.frame.origin.x+_imgBtn_LetsTalk.frame.size.width+300;
    Y=_imgBtn_LetsTalk.frame.origin.y;
    _imgBtn_EditBoards.frame = CGRectMake(X, Y, _imgBtn_LetsTalk.frame.size.width, _imgBtn_LetsTalk.frame.size.height);

    //set EditBoards label
    _lbl_EditBoards.frame = CGRectMake(_imgBtn_EditBoards.frame.origin.x+50, _imgBtn_EditBoards.frame.origin.y+_imgBtn_EditBoards.frame.size.height, _lbl_EditBoards.frame.size.width, _lbl_EditBoards.frame.size.height);

    
}

-(void)updateprogress:(NSNotification*) notification
{
    //Accessing UI Thread
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        
        //Do any updates to your label here
        NSNumber* num = notification.object;
        [lblUpdateServerProgress setText:[NSString stringWithFormat:@"%ld files",(long)num.integerValue]];
        
        
    }];
    
}



- (IBAction)btnLoadImagesFromServer:(id)sender {
      
    
  [self performSelectorInBackground:@selector(downloadData) withObject:nil];

}

-(void)downloadData
{
    // presuming that the current package is WIDGIT
    //retrieving the package name from dictPurchasedPackages that is updated ones the user made the purchase
    NSString* packageName = [_appDelegate.dictPurchasedPackages objectForKey:@1];
    
    _retrieveData = [[XMLmanager_class alloc] loadImagesFromServerbyPath:@"http://4inapp.s3.amazonaws.com/symbolstix-adult-NUMERO.xml" andwithPackageName:packageName];
    
   
    //[_activityIndicator setHidden:TRUE];
    //[_tblRecordsFromXML reloadData];
   // NSNotificationCenter* notificationcenter = [NSNotificationCenter defaultCenter];
   // [notificationcenter postNotificationName:@"imagelist" object:_retrieveData];
}

@end
