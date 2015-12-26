//
//  EditCell_MSG_viewcontroller.m
//  iMyVoice_newVer
//
//  Created by Simona Tzalik on 11/16/15.
//  Copyright © 2015 Techno M.A.G. All rights reserved.
//

#import "EditCell_MSG_viewcontroller.h"
#import "GlobalsFunctions_class.h"
#import "Globals.h"
#import "VoiceRecorder.h"
#import "CustomButton_class.h"
#import "SplitView_manual_viewcontroller.h"


@interface EditCell_MSG_viewcontroller ()

@property GlobalsFunctions_class* globalFuncs;
@property SplitView_manual_viewcontroller* splitView;
//-------------
@property CustomButton_class* btnMessageInCell;


@end

@implementation EditCell_MSG_viewcontroller

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _globalFuncs = [[GlobalsFunctions_class alloc]init];
    
    _btnMessageInCell = [[CustomButton_class alloc]init];
   
      _splitView = (id)self.parentViewController.parentViewController;    
    
    
    // notifications
    
    NSNotificationCenter* notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(notificationUserDidRecordMessage:) name:@"messagerecorded" object:nil];

    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:NO];
    [self setTitle:@"Messages"];
    
}

-(void)viewWillLayoutSubviews
{
    [self re_arangeObjects];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)re_arangeObjects
{
    
    
    CGRect viewRect = [_globalFuncs getViewSize:self.view];
    
    
    
    // float topBorder = TOOLBARHIGH + 10;
    
    NSLog(@"BASIC - re_arangeObjects");
    float XX,YY,WW,HH;
    CGSize thisObj;
    int fullWidth = self.view.frame.size.width - 10;
    int labelWidth = 200;
    int labelHeight = 30;
    int textWidth = 200;
    int textHeight = 30;
    
    int distY_lbl2txt = 5;
    int distX_fromLeft = 10;
    int distX_lbl2btn = 15;
    int distY_line2line = 15;
    int distX_col2col = 20;
    
    
    UIFont* userFont = [UIFont fontWithName:@"System" size:14];
    UIFont* descrFont = [UIFont fontWithName:@"System" size:12];
    
    
    float topY = self.navigationController.navigationBar.frame.size.height+10;
    
    
#pragma mark ------------- MESSAGE IN CELL --------------
    
    UILabel* lblMessageInCell = [[UILabel alloc]init];
    [lblMessageInCell setText:@"Message Text"];
    [lblMessageInCell setFont:descrFont];
   
   // thisObj = lblMessageInCell.frame.size;
    XX = distX_fromLeft;
    YY = topY;
    WW = labelWidth-70;
    HH = labelHeight;
    [lblMessageInCell setFrame:CGRectMake(XX, YY, WW, HH)];
    [self.view addSubview:lblMessageInCell];
    
    
    [_btnMessageInCell setTitle:@"" forState:UIControlStateNormal];
    [_btnMessageInCell setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  //  thisObj = _btnMessageInCell.frame.size;
   
    WW = fullWidth - lblMessageInCell.frame.size.width - distX_lbl2btn;
    HH = textHeight;
    XX = lblMessageInCell.frame.origin.x + lblMessageInCell.frame.size.width;
    YY = lblMessageInCell.frame.origin.y;
    
    [_btnMessageInCell setFrame:CGRectMake(XX,YY, WW,HH)];
    [self.view addSubview:_btnMessageInCell];
    
    //----------- DRAW a Line SEPARATOR --------------
    
    UILabel* lblSeparator = [[UILabel alloc]init];
    [lblSeparator setBackgroundColor:[UIColor blackColor] ];
    
    WW = fullWidth - 30;
    HH = 3;
    XX = (self.view.frame.size.width - WW)/2;
    YY = lblMessageInCell.frame.origin.y+lblMessageInCell.frame.size.height+20;

    [lblSeparator setFrame:CGRectMake(XX,YY,WW,HH)];
    
    [self.view addSubview:lblSeparator];
    
    
#pragma mark -------------- RECORDING MESSAGE --------------
    // if user chooses to record the message then the txtMsgInCell will == @"Recorded Message"
    // and the buttons play and stop will be enabled.
    
    CGSize btnMSGsize = CGSizeMake(50, 50);
    
   
    NSLog(@"show voice recorder dialogbox");
   // [self.popover dismissPopoverAnimated:TRUE];
    
    
    VoiceRecorder *controller = [[VoiceRecorder alloc] init];
    controller.rectVoiceRecorderFrame = CGRectMake(distX_fromLeft, lblSeparator.frame.origin.y+lblSeparator.frame.size.height + distY_lbl2txt+10, fullWidth-10, self.view.frame.size.height/4);
    [controller.view setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]];
    
    [self addChildViewController:controller];
    [self.view addSubview:controller.view];          // 2
    [controller didMoveToParentViewController:self];

    
    
//    UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:controller];
//    [popover setDelegate:self];
//    popover.popoverContentSize = controller.view.frame.size ; //CGSizeMake (325, 425); //your custom size.
//    
//    [popover presentPopoverFromRect:CGRectMake(_pointOfRef4ShowPopup.x, _pointOfRef4ShowPopup.y, 10, 10) inView:self.view permittedArrowDirections: UIPopoverArrowDirectionAny animated:YES];
  //  UIView* viewPlace4VoiceRecorder = [[UIView alloc]init];

    //----------- DRAW a Line SEPARATOR --------------
    
    UILabel* lblSeparator1 = [[UILabel alloc]init];
    [lblSeparator1 setBackgroundColor:[UIColor blackColor] ];
    
    WW = fullWidth - 30;
    HH = 3;
    XX = (self.view.frame.size.width - WW)/2;
    YY = controller.view.frame.origin.y+controller.view.frame.size.height+20;
    
    [lblSeparator1 setFrame:CGRectMake(XX,YY,WW,HH)];
    
    [self.view addSubview:lblSeparator1];

    
 //todo - create list of prev recordings - call it RecHistory
    
 
    
}

#pragma mark FUNCTIONS
-(void)notificationUserDidRecordMessage:(NSNotification*) notification
{
    NSLog(@"user did recorded message");
    
    NSString* recMessage = (NSString*)notification.object;
    
    _splitView.tempCellProperties.cellSoundFilename = [[NSFileManager defaultManager] displayNameAtPath:recMessage];
    _splitView.tempCellProperties.cellSoundPath = VOICES_FOLDER_FROM_RECORDINGS;
    _splitView.tempCellProperties.cellMessage = [[[NSFileManager defaultManager] displayNameAtPath:recMessage] stringByDeletingPathExtension];
    [_btnMessageInCell setTitle: _splitView.tempCellProperties.cellSoundFilename  forState:UIControlStateNormal];
    
}




#pragma mark -

#pragma mark DELEGATES

- (void)closePopoverCtrlr:(UIPopoverController*)popoverCtrlr
{
    
}


@end
