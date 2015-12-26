//
//  EditCell_LINKS_viewcontroller.m
//  iMyVoice_newVer
//
//  Created by Simona Tzalik on 11/15/15.
//  Copyright © 2015 Techno M.A.G. All rights reserved.
//

#import "EditCell_LINKS_viewcontroller.h"
#import "AppDelegate.h"
#import "Globals.h"
#import "GlobalsFunctions_class.h"
#import "CustomButton_class.h"
#import "ListofObjects_tableviewcontroller.h"
#import "SplitView_manual_viewcontroller.h"
#import "Board_class.h"
#import "EditBoard_viewcontroller.h"
#import "XMLmanager_class.h"


@interface EditCell_LINKS_viewcontroller ()
@property GlobalsFunctions_class* globalFuncs;
@property AppDelegate* appDelegate;
@property SplitView_manual_viewcontroller* splitView;
//-------------
@property CustomButton_class* btnLink2Board;
@property CustomButton_class* btnLink2Video;
@property CustomButton_class* btnLink2Music;
@property CustomButton_class* btnLink2Web;
@property UIButton* btnLink2Edit;

@end

@implementation EditCell_LINKS_viewcontroller

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _globalFuncs = [[GlobalsFunctions_class alloc]init];
    _appDelegate = DELEGATE;
    _splitView = (id)self.parentViewController.parentViewController;
    //-----
    // _cellNewProperties = [[Cell_class alloc]init];
    _btnLink2Board = [[CustomButton_class alloc]init];
    _btnLink2Video = [[CustomButton_class alloc]init];
    _btnLink2Music = [[CustomButton_class alloc]init];
    _btnLink2Web = [[CustomButton_class alloc]init];
    _btnLink2Edit = [[UIButton alloc]init];
    [_btnLink2Edit setEnabled:TRUE];
    
    
    //notifications
    NSNotificationCenter* notificationCenter= [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(notificationUserDidSelectBoard4Link:) name:@"boardfromlist4link" object:nil];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [self setTitle:@"Links"];
    
}

-(void)viewWillLayoutSubviews
{
    [self re_arangeObjects];
    [self updateFields];
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
   // CGRect viewRect = [_globalFuncs getViewSize:self.view];
    
    
    
    // float topBorder = TOOLBARHIGH + 10;
    
    NSLog(@"LINKS - re_arangeObjects");
    float XX,YY,WW,HH;
    CGSize thisObj;
    int fullWidth = self.view.frame.size.width - 20;
    int labelWidth = 100;
    int labelHeight = 30;
    int textWidth = 200;
    int textHeight = 30;
    
    int distY_lbl2txt = 5;
    int distX_fromLeft = 10;
    int distX_lbl2btn = 15;
    int distY_line2line = 15;
    int distX_col2col = 20;
    
    
    UIFont* descrFont = [UIFont fontWithName:@"System" size:14];
    
    // the image button is the one who dictates the X for the middle objects
    // float centerX = (viewRect.size.width - btnSelectImage.frame.size.width)/2;
    
    float topY = self.navigationController.navigationBar.frame.size.height+10;
    
    //------------- Link to another/new board -----------------
    UILabel* lblLink2Board = [[UILabel alloc]init];
    [lblLink2Board setText:@"to Board"];
    [lblLink2Board setFont:descrFont];
    
    thisObj = lblLink2Board.frame.size;
    XX = distX_fromLeft;
    YY = topY;
    WW = labelWidth;
    HH = labelHeight;
    [lblLink2Board setFrame:CGRectMake(XX,YY, WW,HH)];
    
    [self.view addSubview:lblLink2Board];
    
    [_btnLink2Board setHidden:FALSE];
    [_btnLink2Board setTitle:@"None" forState:UIControlStateNormal];
    [_btnLink2Board setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_btnLink2Board setBackgroundColor:[UIColor whiteColor]];
    [_btnLink2Board addTarget:self action:@selector(showBoardsList) forControlEvents:UIControlEventTouchUpInside];
    
    thisObj = _btnLink2Board.frame.size;
    XX = fullWidth - textWidth;
    //lblLink2Board.frame.origin.x + lblLink2Board.frame.size.width + distX_lbl2btn;
    YY = lblLink2Board.frame.origin.y;
    WW = textWidth-40;
    HH = textHeight;
    [_btnLink2Board setFrame:CGRectMake(XX,YY, WW,HH)];
    
    [self.view addSubview:_btnLink2Board];
    
    [_btnLink2Edit setTitle:@"Edit" forState:UIControlStateNormal];
    [_btnLink2Edit setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_btnLink2Edit setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [_btnLink2Edit.titleLabel setFont:[UIFont boldSystemFontOfSize:30]];
    [_btnLink2Edit setHidden:NO];
    [_btnLink2Edit addTarget:self action:@selector(userDidPress4Edit) forControlEvents:UIControlEventTouchUpInside];
    
    thisObj = _btnLink2Edit.frame.size;
    XX = _btnLink2Board.frame.origin.x + _btnLink2Board.frame.size.width+15;
    YY = _btnLink2Board.frame.origin.y;
    WW = 30;
    HH = textHeight;
    [_btnLink2Edit setFrame:CGRectMake(XX,YY, WW,HH)];
    [self.view addSubview:_btnLink2Edit];

    
    //------------- Link to video --------------------
    
    UILabel* lblLink2Video = [[UILabel alloc]init];
    [lblLink2Video setText:@"to Video"];
    [lblLink2Video setFont:descrFont];
    
    thisObj = lblLink2Video.frame.size;
    XX = distX_fromLeft;
    YY = lblLink2Board.frame.origin.y + lblLink2Board.frame.size.height + distY_line2line;
    WW = labelWidth;
    HH = labelHeight;
    [lblLink2Video setFrame:CGRectMake(XX,YY, WW,HH)];
    
    [self.view addSubview:lblLink2Video];
    
    
    [_btnLink2Video setHidden:FALSE];
    [_btnLink2Video setTitle:@"None" forState:UIControlStateNormal];
    [_btnLink2Video setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_btnLink2Video setBackgroundColor:[UIColor whiteColor]];
    [_btnLink2Video addTarget:self action:@selector(showVideosLibrary) forControlEvents:UIControlEventTouchUpInside];
    
    thisObj = _btnLink2Video.frame.size;
    XX =fullWidth - textWidth;
    //lblLink2Video.frame.origin.x + lblLink2Video.frame.size.width + distX_lbl2btn;
    YY = lblLink2Video.frame.origin.y;
    WW = textWidth;
    HH = textHeight;
    [_btnLink2Video setFrame:CGRectMake(XX,YY, WW,HH)];
    
    [self.view addSubview:_btnLink2Video];
    
    
    
    
    //------------- Link to music --------------------
    UILabel* lblLink2Music = [[UILabel alloc]init];
    [lblLink2Music setText:@"to Music"];
    [lblLink2Music setFont:descrFont];
    
    thisObj = lblLink2Music.frame.size;
    XX = distX_fromLeft;
    YY = lblLink2Video.frame.origin.y + lblLink2Video.frame.size.height + distY_line2line;
    WW = labelWidth;
    HH = labelHeight;
    [lblLink2Music setFrame:CGRectMake(XX,YY, WW,HH)];
    
    [self.view addSubview:lblLink2Music];
    
    [_btnLink2Music setHidden:FALSE];
    [_btnLink2Music setTitle:@"None" forState:UIControlStateNormal];
    [_btnLink2Music setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_btnLink2Music setBackgroundColor:[UIColor whiteColor]];
    [_btnLink2Music addTarget:self action:@selector(showMusicLibrary) forControlEvents:UIControlEventTouchUpInside];
    
    thisObj = _btnLink2Music.frame.size;
    XX =fullWidth - textWidth;
    YY = lblLink2Music.frame.origin.y;
    WW = textWidth;
    HH = textHeight;
    [_btnLink2Music setFrame:CGRectMake(XX,YY, WW,HH)];
    
    [self.view addSubview:_btnLink2Music];
    
    
    
    //------------- Link to web --------------------
    UILabel* lblLink2Web = [[UILabel alloc]init];
    [lblLink2Web setText:@"to Website"];
    [lblLink2Web setFont:descrFont];
    
    thisObj = lblLink2Web.frame.size;
    XX = distX_fromLeft;
    YY = lblLink2Music.frame.origin.y + lblLink2Music.frame.size.height + distY_line2line;
    WW = labelWidth;
    HH = labelHeight;
    [lblLink2Web setFrame:CGRectMake(XX,YY, WW,HH)];
    
    [self.view addSubview:lblLink2Web];
    
    [_btnLink2Web setHidden:FALSE];
    [_btnLink2Web setTitle:@"None" forState:UIControlStateNormal];
    [_btnLink2Web setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_btnLink2Web setBackgroundColor:[UIColor whiteColor]];
    [_btnLink2Web addTarget:self action:@selector(showWebBrowser) forControlEvents:UIControlEventTouchUpInside];
    
    thisObj = _btnLink2Web.frame.size;
    XX =fullWidth - textWidth;
    YY = lblLink2Web.frame.origin.y;
    WW = textWidth;
    HH = textHeight;
    [_btnLink2Web setFrame:CGRectMake(XX,YY, WW,HH)];
    
    [self.view addSubview:_btnLink2Web];
}

-(void)updateFields
{
    
    //find the linked board name by its ID
    BoardsList_class* brdLink = [[BoardsList_class alloc]init];
    NSString* sBrdName = @"None";
    if (_splitView.cellEditProperties.cellBoardLink != 0) {
        for (BoardsList_class* brdX in _appDelegate.arrayOfBoards) {
            if (brdX.brdID == _splitView.cellEditProperties.cellBoardLink) {
                XMLmanager_class* xmlManager = [[XMLmanager_class alloc]init];
                [xmlManager loadBoardData:brdX];
                sBrdName = [(Board_class*)[_appDelegate.arrayOfLoadedBoard objectAtIndex:0] brdName];
                brdLink = brdX;
                break;
            }
        }

    }
    
        
    [_btnLink2Board setTitle:sBrdName forState:UIControlStateNormal];
    if (brdLink.brdFileName != nil) {
        _btnLink2Board.userData = brdLink;
        [_btnLink2Edit setEnabled:YES];
    }
    else{
        _btnLink2Board.userData = nil;
        [_btnLink2Edit setEnabled:NO];
    }
    
   // [_btnLink2Music setTitle:brdLink.brd forState:UIControlStateNormal];
  //  [_btnLink2Video setValue:_splitView.cellEditProperties.cellBorderWidth];
  //  [_btnLink2Web setText:[NSString stringWithFormat:@"Border width - %d",(int)_sldBorderWidth.value]];
}


-(void)showBoardsList
{
    NSLog(@"show List of Boards+SearchBar");
    
    
    ListofObjects_tableviewcontroller *controller = [[ListofObjects_tableviewcontroller alloc] init];
    controller.showImages = FALSE;
    controller.showBoards = TRUE;
    controller.showAddSymbol = TRUE;
    controller.showFontsList =false;
    controller.view.tag = 99; // indicates that the call for showList comes from cell Properties
    
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark NOTIFICATIONS

-(void)notificationUserDidSelectBoard:(NSNotification*)notificationParam
{
    NSLog(@"user selected board from list");
    // [self.popover dismissPopoverAnimated:TRUE];
    
    Board_class* boardFromList = (Board_class*)notificationParam.object;
    if (boardFromList != nil) {
        
        //update image in cell
        [_btnLink2Board setTitle:boardFromList.brdName forState:UIControlStateNormal];
        _splitView.tempCellProperties.cellBoardLink = boardFromList.brdID;
        
    }
    else{
        NSLog(@"notificationUserDidSelectImageFromList - can't find image path");
        //imgFromUserChoice=[UIImage imageNamed:@"myvoice.jpg"];
    }
    
    
    
    
}

-(void)userDidPress4Edit
{
//    
    //save all the changes made to this cell
    [self saveCellEditProperties];

   // EditBoard_viewcontroller* editBoardVC = [[EditBoard_viewcontroller alloc]init];
                                             //WithBoard:_btnLink2Board.userData];
    
    NSNotificationCenter* notificationcenter = [NSNotificationCenter defaultCenter];
    [notificationcenter postNotificationName:@"userDidSelectLink4Edit" object:_btnLink2Board.userData];
    
    [notificationcenter postNotificationName:@"dismisspopover" object:nil];
    
}

//notification for choosing new board from cellProperties
-(void)notificationUserDidSelectBoard4Link: (NSNotification*) notification
{
    NSLog(@"show loaded board");
    
   
    BoardsList_class* brd4Link = [[BoardsList_class alloc]init];
    brd4Link = (BoardsList_class*)notification.object;
    
    [_btnLink2Board setTitle:brd4Link.brdFileName forState:UIControlStateNormal];
    _btnLink2Board.userData = brd4Link;
    [_btnLink2Edit setEnabled:TRUE];
    _splitView.tempCellProperties.cellBoardLink = brd4Link.brdID;
    
    
}


-(void)saveCellEditProperties
{
    
    if (_splitView.cellEditProperties.cellBackgroundColor != _splitView.tempCellProperties.cellBackgroundColor) {
         _splitView.cellEditProperties.cellBackgroundColor = _splitView.tempCellProperties.cellBackgroundColor;
    }
    if (_splitView.cellEditProperties.cellBoardLink != _splitView.tempCellProperties.cellBoardLink) {
        _splitView.cellEditProperties.cellBoardLink = _splitView.tempCellProperties.cellBoardLink;
    }

    if (_splitView.cellEditProperties.cellBorderColor != _splitView.tempCellProperties.cellBorderColor) {
        _splitView.cellEditProperties.cellBorderColor = _splitView.tempCellProperties.cellBorderColor;
    }

    if (_splitView.cellEditProperties.cellBorderWidth != _splitView.tempCellProperties.cellBorderWidth) {
        _splitView.cellEditProperties.cellBorderWidth = _splitView.tempCellProperties.cellBorderWidth;
    }

    if (_splitView.cellEditProperties.cellFont  != _splitView.tempCellProperties.cellFont) {
        _splitView.cellEditProperties.cellFont = _splitView.tempCellProperties.cellFont;
    }

    if (_splitView.cellEditProperties.cellFontColor != _splitView.tempCellProperties.cellFontColor) {
        _splitView.cellEditProperties.cellFontColor = _splitView.tempCellProperties.cellFontColor;
    }

    if (_splitView.cellEditProperties.cellFontSize != _splitView.tempCellProperties.cellFontSize) {
        _splitView.cellEditProperties.cellFontSize = _splitView.tempCellProperties.cellFontSize;
    }

    if (_splitView.cellEditProperties.cellFontType != _splitView.tempCellProperties.cellFontType) {
        _splitView.cellEditProperties.cellFontType = _splitView.tempCellProperties.cellFontType;
    }

    if (_splitView.cellEditProperties.cellImageID != _splitView.tempCellProperties.cellImageID) {
        _splitView.cellEditProperties.cellImageID = _splitView.tempCellProperties.cellImageID;
    }

    if (_splitView.cellEditProperties.cellMessage != _splitView.tempCellProperties.cellMessage) {
        _splitView.cellEditProperties.cellMessage = _splitView.tempCellProperties.cellMessage;
    }

    if (_splitView.cellEditProperties.cellMP3Path != _splitView.tempCellProperties.cellMP3Path) {
        _splitView.cellEditProperties.cellMP3Path = _splitView.tempCellProperties.cellMP3Path;
    }

    if (_splitView.cellEditProperties.cellSoundFilename != _splitView.tempCellProperties.cellSoundFilename) {
        _splitView.cellEditProperties.cellSoundFilename = _splitView.tempCellProperties.cellSoundFilename;
    }

    if (_splitView.cellEditProperties.cellSoundPath != _splitView.tempCellProperties.cellSoundPath) {
        _splitView.cellEditProperties.cellSoundPath = _splitView.tempCellProperties.cellSoundPath;
    }
    
    if (_splitView.cellEditProperties.cellText != _splitView.tempCellProperties.cellText) {
        _splitView.cellEditProperties.cellText = _splitView.tempCellProperties.cellText;
    }
    
    if (_splitView.cellEditProperties.cellVIDEOPath != _splitView.tempCellProperties.cellVIDEOPath) {
        _splitView.cellEditProperties.cellVIDEOPath = _splitView.tempCellProperties.cellVIDEOPath;
    }

    if (_splitView.cellEditProperties.cellWEBPath != _splitView.tempCellProperties.cellWEBPath) {
        _splitView.cellEditProperties.cellWEBPath = _splitView.tempCellProperties.cellWEBPath;
    }
    
    
    
}



@end
