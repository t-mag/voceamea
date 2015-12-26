//
//  EditCell_viewcontroller.m
//  iMyVoice_newVer
//
//  Created by Simona Tzalik on 11/6/15.
//  Copyright © 2015 Techno M.A.G. All rights reserved.
//

#import "EditCell_viewcontroller.h"
#import "Globals.h"
#import "GlobalsFunctions_class.h"
#import "NEOColorPickerViewController.h"
#import "CustomButton_class.h"
#import "ListofObjects_tableviewcontroller.h"
#import "Cell_class.h"

@interface EditCell_viewcontroller () <UIPickerViewDataSource,UIPickerViewDelegate,NEOColorPickerViewControllerDelegate>
@property GlobalsFunctions_class* globalFuncs;
@property UIToolbar *toolbar;
@property CGPoint pointOption;
@property NSArray* arrayNotificationObject;
@property int selectedFontSize;
//---------
@property UILabel* lblTitle;
@property Cell_class* cellNewProperties;
@property CustomButton_class* btnFontNameList;
@property CustomButton_class* btnFontColor;
@property CustomButton_class* btnBackColor;
@property CustomButton_class* btnFrameColor;
@property UIPickerView* pickFontSize;
@property NSArray* arrayFontSize;


@end

@implementation EditCell_viewcontroller
@synthesize lblHideCell,lblMessage,lblText,lblTextPlace,txtMsgInCell,txtTextInCell,swtHideCell,swtTextPlace,btnSelectImage,currentFontColor,currentBackColor,currentFrameColor,currentFont;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _globalFuncs = [[GlobalsFunctions_class alloc]init];
    _toolbar = [[UIToolbar alloc] init];
    _lblTitle = [[UILabel alloc]init];
    [_lblTitle setText:@"Testing"];
    _pickFontSize = [[UIPickerView alloc]init];
    [_pickFontSize setDelegate:self];
    [_pickFontSize setDataSource:self];
    _arrayFontSize = [[NSArray alloc]initWithObjects:@10,@12,@14,@16,@18,@20,@24,@28, nil];
    //----------
    _cellNewProperties = [[Cell_class alloc]init];
    _btnFontColor = [[CustomButton_class alloc]init];
    _btnBackColor = [[CustomButton_class alloc]init];
    _btnFrameColor = [[CustomButton_class alloc]init];
    _btnFontNameList = [[CustomButton_class alloc]init];
    //_btnFontSize = [[CustomButton_class alloc]init];
    
    //create notifications listener
    NSNotificationCenter* notificationcenter = [NSNotificationCenter defaultCenter];
    [notificationcenter addObserver:self selector:@selector(didFontNameSelect:)name:@"fontname" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    
    
    [_toolbar setFrame:CGRectMake(0, 0, self.view.frame.size.width, TOOLBARHIGH)];
    UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    
    UIBarButtonItem *flexibleSpaceButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *labelButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_lblTitle];
                                        
    
    UIBarButtonItem *doneButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
    
    _toolbar.items = [NSArray arrayWithObjects:cancelButtonItem,flexibleSpaceButtonItem,labelButtonItem, flexibleSpaceButtonItem, doneButtonItem, nil];
    
    [self.view addSubview:_toolbar];
    [self re_arangeObjects];
    
    
    
}


-(void)viewWillLayoutSubviews
{
    
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


#pragma mark Functions
#pragma mark -
- (IBAction)btnSelectImage:(UIButton *)sender {
}
- (IBAction)swtTextPlace:(UISwitch *)sender {
}
- (IBAction)swtHideCell:(UISwitch *)sender {
}





//-(void)orientationChanged:(NSNotification *)object{
//    UIDeviceOrientation deviceOrientation = [[object object] orientation];
//
//    //    if (deviceOrientation == UIInterfaceOrientationPortrait)
//    //    {
//    //    }
//
//    [self viewWillLayoutSubviews];
//
//
//}

#pragma mark -
#pragma mark FUNCTIONS

-(void)re_arangeObjects
{
    //rearange the toolbar size
    [_toolbar setFrame:CGRectMake(0, 0, self.view.frame.size.width, TOOLBARHIGH)];
    
    
    
    CGRect viewRect = [_globalFuncs getViewSize:self.view];
    
    
    
    float topBorder = TOOLBARHIGH + 10;
    
    NSLog(@"re_arangeObjects");
    float XX,YY,WW,HH;
    CGSize thisObj;
    int labelWidth = 100;
    int labelHeight = 30;
    int textWidth = 150;
    int textHeight = 30;
    
    int distY_lbl2txt = 5;
    int distX_fromLeft = 10;
    int distX_lbl2btn = 15;
    int distY_line2line = 15;
    int distX_col2col = 20;
    
    //rearange the toolbar size
    [_toolbar setFrame:CGRectMake(0, 0, self.view.frame.size.width, TOOLBARHIGH)];
    
    UIFont* descrFont = [UIFont fontWithName:@"System" size:14];
    
    // the image button is the one who dictates the X for the middle objects
    float centerX = (viewRect.size.width - btnSelectImage.frame.size.width)/2;
    
    float topY = TOOLBARHIGH + 10;
    
#pragma mark  ------------- TEXT IN CELL -----------------
    [lblText setText:@"Cell Text"];
    [lblText setFont:descrFont];
    [lblText setMinimumScaleFactor:.7f];
    
    thisObj = lblText.frame.size;
    XX=(viewRect.size.width - textWidth)/2;
    YY=topY;
    WW = labelWidth;
    HH = thisObj.height;
    [lblText setFrame:CGRectMake(XX, YY, WW, HH)];
    
    
    thisObj = txtTextInCell.frame.size;
    XX = (viewRect.size.width - textWidth)/2;
    YY = lblText.frame.origin.y+lblText.frame.size.height+distY_lbl2txt;
    WW = textWidth;
    HH = thisObj.height;
    [txtTextInCell setFrame:CGRectMake(XX,YY ,WW ,HH )];
    
#pragma mark ------------ IMAGE BUTTON ------------
    thisObj = btnSelectImage.frame.size;
    XX=centerX;
    YY=txtTextInCell.frame.origin.y + txtTextInCell.frame.size.height+distY_line2line;
    WW = thisObj.width;
    HH = thisObj.height;
    [btnSelectImage setFrame:CGRectMake(XX, YY, WW, HH)];
    //todo - on press open popover view
    
#pragma mark ------------- MESSAGE IN CELL --------------
    
    [lblMessage setText:@"Message Text"];
    
    thisObj = lblMessage.frame.size;
    XX=txtTextInCell.frame.origin.x + txtTextInCell.frame.size.width + distX_col2col;
    YY=topY;
    WW = labelWidth;
    HH = thisObj.height;
    [lblMessage setFrame:CGRectMake(XX, YY, WW, HH)];
    
    
    thisObj = txtMsgInCell.frame.size;
    XX=lblMessage.frame.origin.x;
    YY=lblMessage.frame.origin.y + lblMessage.frame.size.height + distY_lbl2txt;
    WW = textWidth;
    HH = thisObj.height;
    [txtMsgInCell setFrame:CGRectMake(XX,YY, WW,HH)];
    
#pragma mark -------------- RECORDING MESSAGE --------------
    // if user chooses to record the message then the txtMsgInCell will == @"Recorded Message"
    // and the buttons play and stop will be enabled.
    
    CGSize btnMSGsize = CGSizeMake(50, 50);
    
    //---------------REC button -----------------------
    UIButton* btnRecMSG = [[UIButton alloc]init];
    [btnRecMSG setImage:[UIImage imageNamed:@"record_icon"] forState:UIControlStateNormal];
    [btnRecMSG addTarget:self action:@selector(recMSG) forControlEvents:UIControlStateNormal];
    //todo - action RecMSG + add image for button
    
    thisObj = btnRecMSG.frame.size;
    XX=lblMessage.frame.origin.x;//    btnStopMSG.frame.origin.x + btnStopMSG.frame.size.width + 5;
    YY=txtMsgInCell.frame.origin.y + txtMsgInCell.frame.size.height + distY_line2line;
    WW = btnMSGsize.width;
    HH = btnMSGsize.height;
    [btnRecMSG setFrame:CGRectMake(XX,YY, WW,HH)];
    
    [self.view addSubview:btnRecMSG];
    
    //---------------PLAY button --------------------
    
    UIButton* btnPlayMSG = [[UIButton alloc]init];
    [btnPlayMSG setImage:[UIImage imageNamed:@"control_play_blue"] forState:UIControlStateNormal];
    [btnPlayMSG addTarget:self action:@selector(playMSG) forControlEvents:UIControlEventTouchUpInside];
    [btnPlayMSG sizeThatFits:CGSizeMake(5, 5)];
    
    //todo - action playMSG + add image for button
    
    thisObj = btnPlayMSG.frame.size;
    XX=btnRecMSG.frame.origin.x + btnRecMSG.frame.size.width + 5;
    YY=btnRecMSG.frame.origin.y;// + txtMsgInCell.frame.size.height+5;
    WW = btnMSGsize.width;
    HH = btnMSGsize.height;
    [btnPlayMSG setFrame:CGRectMake(XX,YY, WW,HH)];
    
    
    if (![btnPlayMSG isDescendantOfView:self.view]) {
        [self.view addSubview:btnPlayMSG];
        
    }
    
    
    
    //----------------STOP button ------------------
    UIButton* btnStopMSG = [[UIButton alloc]init];
    [btnStopMSG setImage:[UIImage imageNamed:@"control_stop_blue"] forState:UIControlStateNormal];
    [btnStopMSG addTarget:self action:@selector(stopMSG) forControlEvents:UIControlStateNormal];
    //todo - action StopMSG + add image for button
    
    thisObj = btnStopMSG.frame.size;
    XX=btnPlayMSG.frame.origin.x + btnPlayMSG.frame.size.width + 5;
    YY=btnPlayMSG.frame.origin.y;
    WW = btnMSGsize.width;
    HH = btnMSGsize.height;
    [btnStopMSG setFrame:CGRectMake(XX,YY, WW,HH)];
    
    [self.view addSubview:btnStopMSG];
    
    
    
    
    
    //------------- TEXT PLACE --------------------
    
    [lblTextPlace setText:@"Text on Top"];
    [lblTextPlace setMinimumScaleFactor:.7f];
    
    thisObj = lblTextPlace.frame.size;
    
    XX = txtTextInCell.frame.origin.x + txtTextInCell.frame.size.width + distX_col2col;;
    YY = btnRecMSG.frame.origin.y + btnRecMSG.frame.size.height + distY_line2line;
    WW = labelWidth;
    HH = thisObj.height;
    [lblTextPlace setFrame:CGRectMake(XX,YY, WW,HH)];
    
    
    [swtTextPlace setOn:FALSE];
    thisObj = swtTextPlace.frame.size;
    XX = lblTextPlace.frame.origin.x + lblTextPlace.frame.size.width + distX_lbl2btn;
    YY = lblTextPlace.frame.origin.y;
    WW = thisObj.width;
    HH = thisObj.height;
    [swtTextPlace setFrame:CGRectMake(XX,YY, WW,HH)];
    
    
    // ------------- HIDE CELL ---------------------
    
    thisObj = lblHideCell.frame.size;
    
    XX = lblTextPlace.frame.origin.x ;
    YY = lblTextPlace.frame.origin.y + lblTextPlace.frame.size.height + distY_line2line+10;
    WW = labelWidth;
    HH = thisObj.height;
    [lblHideCell setFrame:CGRectMake(XX,YY, WW,HH)];
    
    
    thisObj = swtHideCell.frame.size;
    XX = lblHideCell.frame.origin.x + lblHideCell.frame.size.width + distX_lbl2btn;
    YY = lblHideCell.frame.origin.y ;
    WW = thisObj.width;
    HH = thisObj.height;
    [swtHideCell setFrame:CGRectMake(XX,YY, WW,HH)];
    
    
    //-------------- Font Settings ----------------------
    UILabel* lblFontTitle = [[UILabel alloc]init];
    [lblFontTitle setText:@"Font Settings"];
    [lblFontTitle setMinimumScaleFactor:.7f];
    [lblFontTitle setFont:[UIFont boldSystemFontOfSize:20]];
    
    thisObj = lblFontTitle.frame.size;
    XX = distX_fromLeft;
    YY = topY;
    WW = labelWidth+30;
    HH = labelHeight;
    [lblFontTitle setFrame:CGRectMake(XX,YY, WW,HH)];
    [self.view addSubview:lblFontTitle];
    
    
#pragma mark -------------- FONT NAME --------------
    UILabel* lblFontName = [[UILabel alloc]init];
    [lblFontName setText:@"Font Name"];
    [lblFontName setMinimumScaleFactor:.7f];
    
    thisObj = lblFontName.frame.size;
    XX = distX_fromLeft;
    YY = lblFontTitle.frame.origin.y + lblFontTitle.frame.size.height + distY_line2line;
    WW = labelWidth;
    HH = labelHeight;
    [lblFontName setFrame:CGRectMake(XX,YY, WW,HH)];
    
    [self.view addSubview:lblFontName];
    
    //todo - deal with fontlist
    
    if (currentFont != nil)
        [_btnFontNameList setTitle:currentFont.fontName forState:UIControlStateNormal];
    else
        [_btnFontNameList setTitle:@"Default" forState:UIControlStateNormal];

    
    [_btnFontNameList setHidden:FALSE];
    [_btnFontNameList setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_btnFontNameList setBackgroundColor:[UIColor whiteColor]];
    [_btnFontNameList addTarget:self action:@selector(showFontsList:) forControlEvents:UIControlEventTouchUpInside];
    
    thisObj = _btnFontNameList.frame.size;
    XX = lblFontName.frame.origin.x + labelWidth+distX_lbl2btn;
    YY = lblFontName.frame.origin.y;
    WW = labelWidth;
    HH = labelHeight;
    [_btnFontNameList setFrame:CGRectMake(XX,YY, WW,HH)];
    
    _btnFontNameList.userData = [NSValue valueWithCGPoint:CGPointMake(_btnFontNameList.frame.origin.x+_btnFontNameList.frame.size.width, _btnFontNameList.frame.origin.y)];
    
    [self.view addSubview:_btnFontNameList];
    
    //-------------- FONT SIZE --------------
    UILabel* lblFontSize = [[UILabel alloc]init];
    [lblFontSize setText:@"Font Size"];
    [lblFontSize setMinimumScaleFactor:.7f];
    
    thisObj = lblFontSize.frame.size;
    XX = distX_fromLeft;
    YY = lblFontName.frame.origin.y + lblFontName.frame.size.height + distY_line2line;
    WW = labelWidth;
    HH = labelHeight;
    [lblFontSize setFrame:CGRectMake(XX,YY, WW,HH)];
    
    [self.view addSubview:lblFontSize];
    
    //todo - deal with pickerview
    
    
    
    
    
//    [_btnFontSize setTitle:@"Font Size >" forState:UIControlStateNormal];
    [_pickFontSize setHidden:FALSE];
   // [_pickFontSize addTarget:self action:@selector(showFontSizePickerView) forControlEvents:UIControlEventTouchUpInside];
    //[_pickFontSize setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_pickFontSize setBackgroundColor:[UIColor lightGrayColor]];
    
    thisObj = _pickFontSize.frame.size;
    XX = lblFontSize.frame.origin.x + lblFontSize.frame.size.width+distX_lbl2btn;
    YY = lblFontSize.frame.origin.y;
    WW = labelWidth;
    HH = labelHeight;
    [_pickFontSize setFrame:CGRectMake(XX,YY, WW,HH)];
    
    
    
    [self.view addSubview:_pickFontSize];
    
    //--------------- FONT TYPE --------------
    
    UILabel* lblFontType = [[UILabel alloc]init];
    [lblFontType setText:@"Font Type"];
    [lblFontType setMinimumScaleFactor:.7f];
    
    thisObj = lblFontType.frame.size;
    XX = distX_fromLeft;
    YY = lblFontSize.frame.origin.y + lblFontSize.frame.size.height + distY_line2line;
    WW = labelWidth;
    HH = labelHeight;
    [lblFontType setFrame:CGRectMake(XX,YY, WW,HH)];
    [self.view addSubview:lblFontType];
    
    //todo - action for segmButton
    NSArray* arrayItems4SegmButton = [[NSArray alloc]initWithObjects:@"Regular",@"Bold",@"Italic", nil];
    UISegmentedControl* segmButton = [[UISegmentedControl alloc]initWithItems:arrayItems4SegmButton];
    [segmButton setSelectedSegmentIndex:0];
    
    
    thisObj = segmButton.frame.size;
    XX = lblFontType.frame.origin.x + lblFontType.frame.size.width + distX_lbl2btn;
    YY = lblFontType.frame.origin.y;
    WW = thisObj.width;
    HH = thisObj.height;
    [segmButton setFrame:CGRectMake(XX,YY, WW,HH)];
    [self.view addSubview:segmButton];
    
    //---------------- FONT COLOR ---------------
    
    UILabel* lblFontColor = [[UILabel alloc]init];
    [lblFontColor setText:@"Font Color"];
    [lblFontColor setMinimumScaleFactor:.7f];
    
    thisObj = lblFontColor.frame.size;
    XX = distX_fromLeft;
    YY = lblFontType.frame.origin.y + lblFontType.frame.size.height + distY_line2line;
    WW = labelWidth;
    HH = labelHeight;
    
    [lblFontColor setFrame:CGRectMake(XX,YY,WW,HH)];
    [self.view addSubview:lblFontColor];
    
    // todo - module "showFontColor" for fontcolor
    
    //UIButton* btnFontColor = [[UIButton alloc]init];
    // [btnFontColor setTitle:@"Font Color >" forState:UIControlStateNormal];
    [_btnFontColor setHidden:FALSE];
    _btnFontColor.tag= 0;
    
    
    [_btnFontColor addTarget:self action:@selector(showColor:) forControlEvents:UIControlEventTouchUpInside];
    // [btnFontColor setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    if (currentFontColor != nil)
        [_btnFontColor setBackgroundColor:currentFontColor];
    else
        [_btnFontColor setBackgroundColor:CELLDEFAULTFONTCOLOR];
    
    
    thisObj = _btnFontColor.frame.size;
    XX = lblFontColor.frame.origin.x + lblFontColor.frame.size.width + distX_lbl2btn;
    YY = lblFontColor.frame.origin.y;
    WW = labelWidth;
    HH = labelHeight;
    
    
    [_btnFontColor setFrame:CGRectMake(XX,YY,WW,HH)];
    _btnFontColor.userData = [NSValue valueWithCGPoint:CGPointMake(_btnFontColor.frame.origin.x+_btnFontColor.frame.size.width, _btnFontColor.frame.origin.y)];
    [self.view addSubview:_btnFontColor];
    
    //------------- LINK -----------------------
    UILabel* lblLinksTitle = [[UILabel alloc]init];
    [lblLinksTitle setText:@"Links"];
    [lblLinksTitle setMinimumScaleFactor:.7f];
    
    thisObj = lblLinksTitle.frame.size;
    XX = distX_fromLeft;//    txtTextInCell.frame.origin.x + txtTextInCell.frame.size.width + distX_col2col;
    YY = lblFontColor.frame.origin.y + lblFontColor.frame.size.height + distY_line2line+200;//lblHideCell.frame.origin.y + lblHideCell.frame.size.height + distY_line2line;
    WW = labelWidth;
    HH = labelHeight;
    [lblLinksTitle setFrame:CGRectMake(XX,YY, WW,HH)];
    
    [self.view addSubview:lblLinksTitle];
    
    
    
    //------------- Link to another/new board -----------------
    UILabel* lblLink2Board = [[UILabel alloc]init];
    [lblLink2Board setText:@"to Board ..."];
    [lblLink2Board setMinimumScaleFactor:.7f];
    
    thisObj = lblLink2Board.frame.size;
    XX = lblLinksTitle.frame.origin.x;
    YY = lblLinksTitle.frame.origin.y + txtMsgInCell.frame.size.height + 10;
    WW = labelWidth;
    HH = txtMsgInCell.frame.size.height;
    [lblLink2Board setFrame:CGRectMake(XX,YY, WW,HH)];
    
    [self.view addSubview:lblLink2Board];
    
    
    UISwitch* swtLink2Board = [[UISwitch alloc]init];
    [swtLink2Board setOn:FALSE];
    
    thisObj = swtLink2Board.frame.size;
    XX = lblLink2Board.frame.origin.x + lblLink2Board.frame.size.width + distX_lbl2btn;
    YY = lblLink2Board.frame.origin.y;
    WW = thisObj.width;
    HH = thisObj.height;
    [swtLink2Board setFrame:CGRectMake(XX,YY, WW,HH)];
    
    [self.view addSubview:swtLink2Board];
    
    
    
    
    //------------- Link to song --------------------
    UILabel* lblLink2Song = [[UILabel alloc]init];
    [lblLink2Song setText:@"to Music ..."];
    [lblLink2Song setMinimumScaleFactor:.7f];
    
    thisObj = lblLink2Song.frame.size;
    XX = swtLink2Board.frame.origin.x + swtLink2Board.frame.size.width + distX_col2col;
    YY = swtLink2Board.frame.origin.y;
    WW = lblLink2Board.frame.size.width;
    HH = lblLink2Board.frame.size.height;
    [lblLink2Song setFrame:CGRectMake(XX,YY, WW,HH)];
    
    [self.view addSubview:lblLink2Song];
    
    
    UISwitch* swtLink2Song = [[UISwitch alloc]init];
    [swtLink2Song setOn:FALSE];
    
    thisObj = swtLink2Song.frame.size;
    XX = lblLink2Song.frame.origin.x + lblLink2Song.frame.size.width + distX_lbl2btn;
    YY = lblLink2Song.frame.origin.y;
    WW = thisObj.width;
    HH = thisObj.height;
    [swtLink2Song setFrame:CGRectMake(XX,YY, WW,HH)];
    
    [self.view addSubview:swtLink2Song];
    
    
    
    
    //------------- Link to video --------------------
    UILabel* lblLink2Video = [[UILabel alloc]init];
    [lblLink2Video setText:@"to Video ..."];
    [lblLink2Video setMinimumScaleFactor:.7f];
    
    thisObj = lblLink2Video.frame.size;
    XX = swtLink2Song.frame.origin.x + swtLink2Song.frame.size.width + distX_col2col;
    YY = swtLink2Song.frame.origin.y;
    WW = labelWidth;
    HH = lblLink2Song.frame.size.height;
    [lblLink2Video setFrame:CGRectMake(XX,YY, WW,HH)];
    
    [self.view addSubview:lblLink2Video];
    
    
    UISwitch* swtLink2Video = [[UISwitch alloc]init];
    [swtLink2Video setOn:FALSE];
    
    thisObj = swtLink2Video.frame.size;
    XX = lblLink2Video.frame.origin.x + lblLink2Song.frame.size.width + distX_lbl2btn;
    YY = lblLink2Video.frame.origin.y;
    WW = thisObj.width;
    HH = thisObj.height;
    [swtLink2Video setFrame:CGRectMake(XX,YY, WW,HH)];
    
    [self.view addSubview:swtLink2Video];
    
    
    
    //------------- Link to web --------------------
    UILabel* lblLink2Web = [[UILabel alloc]init];
    [lblLink2Web setText:@"to Website ..."];
    [lblLink2Web setMinimumScaleFactor:.7f];
    
    thisObj = lblLink2Web.frame.size;
    XX = swtLink2Video.frame.origin.x + swtLink2Video.frame.size.width + distX_col2col;
    YY = swtLink2Video.frame.origin.y;// + lblLink2Song.frame.size.height + distY_line2line;
    WW = labelWidth;
    HH = lblLink2Video.frame.size.height;
    [lblLink2Web setFrame:CGRectMake(XX,YY, WW,HH)];
    
    [self.view addSubview:lblLink2Web];
    
    
    
    
    UISwitch* swtLink2Web = [[UISwitch alloc]init];
    [swtLink2Web setOn:FALSE];
    
    thisObj = swtLink2Web.frame.size;
    XX = lblLink2Web.frame.origin.x + lblLink2Song.frame.size.width + distX_lbl2btn;
    YY = lblLink2Web.frame.origin.y;
    WW = thisObj.width;
    HH = thisObj.height;
    [swtLink2Web setFrame:CGRectMake(XX,YY, WW,HH)];
    
    [self.view addSubview:swtLink2Web];
    
    //---------------- BACKGROUND COLOR ---------------
    
    UILabel* lblBackColor = [[UILabel alloc]init];
    [lblBackColor setText:@"Background Color"];
    [lblBackColor setMinimumScaleFactor:.7f];
    
    thisObj = lblBackColor.frame.size;
    XX = distX_fromLeft;    //lblHideCell.frame.origin.x;
    YY = lblFontColor.frame.origin.y + lblFontColor.frame.size.height + 50;                   //lblHideCell.frame.origin.y + lblHideCell.frame.size.height + distY_line2line;
    WW = labelWidth;
    HH = labelHeight;
    
    [lblBackColor setFrame:CGRectMake(XX,YY,WW,HH)];
    [self.view addSubview:lblBackColor];
    
    _btnBackColor.tag = 1;
    //[_btnBackColor setTitle:@"Background Color >" forState:UIControlStateNormal];
    [_btnBackColor setHidden:FALSE];
    [_btnBackColor addTarget:self action:@selector(showColor:) forControlEvents:UIControlEventTouchUpInside];
    [_btnBackColor setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_btnBackColor setBackgroundColor:[UIColor lightGrayColor]];
    if (currentBackColor != nil)
        [_btnBackColor setBackgroundColor:currentBackColor];
    else
        [_btnBackColor setBackgroundColor:CELLDEFAULTBACKGROUNDCOLOR];
    
    
    
    
    thisObj = _btnBackColor.frame.size;
    XX = lblBackColor.frame.origin.x + lblBackColor.frame.size.width + distX_lbl2btn;
    YY = lblBackColor.frame.origin.y;
    WW = labelWidth;
    HH = labelHeight;
    
    [_btnBackColor setFrame:CGRectMake(XX,YY,WW,HH)];
     _btnBackColor.userData = [NSValue valueWithCGPoint:CGPointMake(_btnBackColor.frame.origin.x+_btnBackColor.frame.size.width, _btnBackColor.frame.origin.y)];
    [self.view addSubview:_btnBackColor];
    
    //---------------- BORDER COLOR ---------------
    
    UILabel* lblBorderColor = [[UILabel alloc]init];
    [lblBorderColor setText:@"Border Color"];
    [lblBorderColor setMinimumScaleFactor:.7f];
    
    thisObj = lblBorderColor.frame.size;
    XX = lblBackColor.frame.origin.x;
    YY = lblBackColor.frame.origin.y + lblBackColor.frame.size.height + distY_line2line;
    WW = labelWidth;
    HH = labelHeight;
    
    [lblBorderColor setFrame:CGRectMake(XX,YY,WW,HH)];
    [self.view addSubview:lblBorderColor];
    
    // todo - module "showFontColor" for fontcolor
    
    _btnFrameColor.tag = 2;
   // [_btnFrameColor setTitle:@"Border Color >" forState:UIControlStateNormal];
    [_btnFrameColor setHidden:FALSE];
    [_btnFrameColor addTarget:self action:@selector(showColor:) forControlEvents:UIControlEventTouchUpInside];
   // [_btnFrameColor setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
   // [_btnFrameColor setBackgroundColor:[UIColor lightGrayColor]];
    if (currentBackColor != nil)
        [_btnFrameColor setBackgroundColor:currentFrameColor];
    else
        [_btnFrameColor setBackgroundColor:CELLDEFAULTFRAMECOLOR];
    
    thisObj = _btnFrameColor.frame.size;
    XX = lblBorderColor.frame.origin.x + lblBorderColor.frame.size.width + distX_lbl2btn;
    YY = lblBorderColor.frame.origin.y;
    WW = labelWidth;
    HH = labelHeight;
    
    [_btnFrameColor setFrame:CGRectMake(XX,YY,WW,HH)];
    _btnFrameColor.userData = [NSValue valueWithCGPoint:CGPointMake(_btnFrameColor.frame.origin.x+_btnFrameColor.frame.size.width, _btnFrameColor.frame.origin.y)];

    [self.view addSubview:_btnFrameColor];
    
    //---------------- BORDER WIDTH ---------------
    
    UILabel* lblBorderWidth = [[UILabel alloc]init];
    [lblBorderWidth setText:@"Border Width"];
    [lblBorderWidth setMinimumScaleFactor:.7f];
    
    thisObj = lblBorderWidth.frame.size;
    XX = lblBorderColor.frame.origin.x;
    YY = lblBorderColor.frame.origin.y + lblBorderColor.frame.size.height + distY_line2line;
    WW = labelWidth;
    HH = labelHeight;
    
    [lblBorderWidth setFrame:CGRectMake(XX,YY,WW,HH)];
    [self.view addSubview:lblBorderWidth];
    
    //todo - deal with pickerview
    
    
    
    UIButton* btnBorderWidth = [[UIButton alloc]init];
    [btnBorderWidth setTitle:@"Border Width >" forState:UIControlStateNormal];
    [btnBorderWidth setHidden:FALSE];
    [btnBorderWidth addTarget:self action:@selector(showBorderColor) forControlEvents:UIControlEventTouchUpInside];
    [btnBorderWidth setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnBorderWidth setBackgroundColor:[UIColor lightGrayColor]];
    
    
    thisObj = btnBorderWidth.frame.size;
    XX = lblBorderWidth.frame.origin.x + lblBorderWidth.frame.size.width + distX_lbl2btn;
    YY = lblBorderWidth.frame.origin.y;
    WW = labelWidth;
    HH = labelHeight;
    
    [btnBorderWidth setFrame:CGRectMake(XX,YY,WW,HH)];
    
    [self.view addSubview:btnBorderWidth];
    
    
    
}

-(void)showFontsList:(CustomButton_class*)sender
{
    // the popover windows will show from pint
     CGPoint pint = [sender.userData CGPointValue];
    
    ListofObjects_tableviewcontroller *controller = [[ListofObjects_tableviewcontroller alloc] init];
    controller.showImages = FALSE;
    controller.showBoards = FALSE;
    controller.showAddSymbol = FALSE;
    controller.showFontsList =TRUE;

    
    //UINavigationController* navVC = [[UINavigationController alloc] initWithRootViewController:controller];
    
    
    UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:controller];
    popover.delegate = (id)self;
    popover.popoverContentSize = CGSizeMake (325, 425); //your custom size.
    
    
    [popover  presentPopoverFromRect:CGRectMake(pint.x, pint.y, 10, 10) inView:self.view permittedArrowDirections: UIPopoverArrowDirectionAny animated:YES];
    
}

-(void)didFontNameSelect:(NSNotification*)notification
{
    NSString* selectedFontName = (NSString*)notification.object;
    [_btnFontNameList setTitle:selectedFontName forState:UIControlStateNormal];
    
    _btnFontNameList.titleLabel.font = [UIFont fontWithName:selectedFontName size:_btnFontNameList.titleLabel.font.pointSize];
    
  //  _cellNewProperties.cellFont = [UIFont fontWithName:selectedFontName size:
                                 //  _pickFontSize
    
   
    
}

-(void)showColor:(CustomButton_class*)sender
{
    // the popover windows will show from pint
    int iTarget = (int)sender.tag;
    CGPoint pint = [sender.userData CGPointValue];
    
    NEOColorPickerViewController *controller = [[NEOColorPickerViewController alloc] init];//WithNibName:nil bundle:nil];
    controller.delegate = self;
    
    switch (iTarget) { // 0 - Font , 1 - Background , 2 - Border
        case 0:
            controller.selectedColor = currentFontColor;
            controller.title = @"Choose a color for your text";
            break;
            
        case 1:
            controller.selectedColor = currentBackColor;
            controller.title = @"Choose a color for your cell background";
            break;
            
        case 2:
            controller.selectedColor = currentFrameColor;
            controller.title = @"Choose a color for your cell frame";
            break;
            
        default:
            break;
    }
    
    
    UINavigationController* navVC = [[UINavigationController alloc] initWithRootViewController:controller];
    
    
    UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:navVC];
    popover.delegate = (id)self;
    popover.popoverContentSize = CGSizeMake (325, 425); //your custom size.
    
    
    [popover  presentPopoverFromRect:CGRectMake(pint.x, pint.y, 10, 10) inView:self.view permittedArrowDirections: UIPopoverArrowDirectionAny animated:YES];
    
}

#pragma mark -
#pragma mark PICKER VIEW - delegate
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return _arrayFontSize.count;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 1;
}


// returns width of column and height of row for each component.
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return 100;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 30;
}

// these methods return either a plain NSString, a NSAttributedString, or a view (e.g UILabel) to display the row for the component.
// for the view versions, we cache any hidden and thus unused views and pass them back for reuse.
// If you return back a different object, the old one will be released. the view will be centered in the row rect
//- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component __TVOS_PROHIBITED;
//- (nullable NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component NS_AVAILABLE_IOS(6_0) __TVOS_PROHIBITED; // attributed title is favored if both methods are implemented
//- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view
//{
//                                       
//}
//
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _selectedFontSize = [_arrayFontSize objectAtIndex:row];
}

#pragma mark -
#pragma mark NEOColorPickerViewController

- (void)colorPickerViewController:(NEOColorPickerBaseViewController *)controller didSelectColor:(UIColor *)color {
    // self.view.backgroundColor = color;
    
    if (color != nil) {
        
        _arrayNotificationObject = [[NSArray alloc]initWithObjects:@"fontcolor",color, nil];
        
        [_btnFontColor setBackgroundColor:color];
        
        _cellNewProperties.cellFontColor = color;
        
//        NSNotificationCenter* notification = [NSNotificationCenter defaultCenter];
//        [notification postNotificationName:@"updatecell" object:_arrayNotificationObject];
        if ([controller.title isEqualToString:@"Choose a color for Border"]) {
            // _cellSelectedbyUser.cellBorderColor=color;
            
        }
        
        if ([controller.title isEqualToString:@"Choose a color for Background"]) {
            // _cellSelectedbyUser.cellBackgroundColor=color;
        }
        
        // [_colEditBoard reloadData];
        
    }
    
    
    
    
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)colorPickerViewControllerDidCancel:(NEOColorPickerBaseViewController *)controller {
    [controller dismissViewControllerAnimated:YES completion:nil];
}


@end
