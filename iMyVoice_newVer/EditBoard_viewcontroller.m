//
//  EditBoard_viewcontroller.m
//  iMyVoice_newVer
//
//  Created by Simona Tzalik on 16/4/15.
//  Copyright (c) 2015 Techno M.A.G. All rights reserved.
//


//#define NUMOFCELLSINROW 12
//#define NUMOFCELLSINCOL 12
//

#import <AVFoundation/AVBase.h>
#import "Globals.h"
#import "GlobalsFunctions_class.h"
#import "EasyAlertView.h"
#import "EditBoard_viewcontroller.h"
#import "EditCell_viewcontroller.h"
#import "RFQuiltLayout.h"
#import "EditBoardCell_collectionviewcell.h"
#import "Cell_class.h"
#import "Board_class.h"
#import "NewBoardOptions_viewcontroller.h"
#import "Images_class.h"
#import "NSMutableArray+funcs4Array.h"
//#import "PopupMenu_viewcontroller.h"
#import "CellOptions_viewcontroller.h"
#import "AppDelegate.h"
//#import "Popupmenu_viewcontroller.h"
#import "TwoDimenArray.h"
#import "NEOColorPickerViewController.h"
#import "NavTable_tableviewcontroller.h"
#import "SplitView_manual_viewcontroller.h"

#import "VoiceRecorder.h"
#import "Text2Speech.h"
#import "ImageList_tableviewcontroller.h"
#import "ImageSoundListViewController.h"
#import "ListofObjects_tableviewcontroller.h"
#import "BoardPopupmenu_tableviewcontroller.h"
#import "XMLManager_class.h"


@interface EditBoard_viewcontroller () <RFQuiltLayoutDelegate,UICollectionViewDataSource,UICollectionViewDelegate,EditBoardCellDelegate,UIAlertViewDelegate,NEOColorPickerViewControllerDelegate,AVSpeechSynthesizerDelegate,UIPopoverControllerDelegate,BoardPopupmenuDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate>



@property (weak, nonatomic) IBOutlet UICollectionView *colEditBoard;
//@property PopupMenu_viewcontroller *popupmenuVC;
@property AppDelegate* appDelegate;

@property UIImagePickerController* imagePicker;
@property AVAudioPlayer *audioPlayer;
@property NSMutableArray* arrayMerged;
@property NSMutableArray* arraySplit;
@property NSMutableArray* arrayOfSelCells;
//@property TwoDimenArray* matrixOfCells;
@property NSMutableArray* matrixOfCells;
@property NSMutableArray* Cells_Line1;
@property NSMutableArray* arrayOfCells;
@property NSMutableArray* array4UNDO;
@property NSMutableArray* matrix4UNDO;
@property BOOL isObjectsInCellArranged;
@property BOOL isCellSelectionbyUser;
@property BOOL isBasicMergingforNew_or_LoadBoard;
@property BOOL setMenuUndo;
//@property UITextField* txtNavBar_BoardName;
@property UILabel* lblNavbarTitle;
@property UIImageView* imgNavbarBoardMenu;
//@property int currNumOfCellsInRow; //used for setting the TAG after merging/splitting
//@property int currNumOfCellsInCol;  //used for setting the TAG after merging/splitting
@property Cell_class* cellSelectedbyUser;
@property EditBoardCell_collectionviewcell* currCellSelectedbyUser;
@property GlobalsFunctions_class* globalFuncs;
@property BoardPopupmenu_tableviewcontroller* menuBoard;
//@property NSUserDefaults* appDefaults;


@property CGPoint pointOfRef4ShowPopup;
@property UIColor* currentColor;


@end

@implementation EditBoard_viewcontroller
@synthesize Rows,Cols,BoardName,imgFromUserChoice,navBoardButton,boardSelectedbyUser,myTag,board4Load;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"viewDidLoad");
    
    _lblNavbarTitle = [[UILabel alloc]init];
    [_lblNavbarTitle setText:@"Testing"];
    _imgNavbarBoardMenu = [[UIImageView alloc]init];

    _audioPlayer = [[AVAudioPlayer alloc]init];
    _globalFuncs = [[GlobalsFunctions_class alloc]init];
    _arrayOfCells = [[NSMutableArray alloc]init];
    //_matrixOfCells = [[TwoDimenArray alloc]init]; //WithRows:12 Cols:12 Values:_arrayOfCells];
    _matrixOfCells = [[NSMutableArray alloc]initWithCapacity:NUMOFCELLSINROW];
    
    _arrayOfSelCells = [[NSMutableArray alloc]init];
    _cellSelectedbyUser = [[Cell_class alloc]init];
    _appDelegate = DELEGATE;
    
    if (boardSelectedbyUser == nil) boardSelectedbyUser= [[Board_class alloc]init];
    
    _setMenuUndo=false;
    
    [self createNavBar];
    
    
    
    _isCellSelectionbyUser=YES;
    
    
    //set listner for Notification
    NSNotificationCenter* notificationCenter = [NSNotificationCenter defaultCenter];
    
    
    
    //general notifications
    [notificationCenter addObserver:self selector:@selector(notificationDismissPopover:) name:@"dismisspopover" object:nil];
    
    //notifications for - showing popover views according to choosen item from menu
    [notificationCenter addObserver:self selector:@selector(notificationDoShowCamera:) name:@"doShowCamera" object:nil];
    [notificationCenter addObserver:self selector:@selector(notificationDoShowPhotosLibrary:) name:@"doShowPhotosLibrary" object:nil];
    
    [notificationCenter addObserver:self selector:@selector(notificationRemoveImageFromCell:) name:@"removeImageFromCell" object:nil];
    
    [notificationCenter addObserver:self selector:@selector(notificationDoShowListOfImages:) name:@"doShowListOfImages" object:nil];
    [notificationCenter addObserver:self selector:@selector(notificationDoShowColors4Background:) name:@"doShowColors4Background" object:nil];
    [notificationCenter addObserver:self selector:@selector(notificationDoShowColors4Frame:) name:@"doShowColors4Frame" object:nil];
    [notificationCenter addObserver:self selector:@selector(notificationDoShowVoiceRecorder:) name:@"doShowVoiceRecorder" object:nil];
    
    [notificationCenter addObserver:self selector:@selector(notificationDoShowListOfBoards:) name:@"doShowListOfExistingBoards" object:nil];
    
    [notificationCenter addObserver:self selector:@selector(notificationUserDidSelectLink4Edit:) name:@"userDidSelectLink4Edit" object:nil];
    
    [notificationCenter addObserver:self selector:@selector(notificationSaveBoard) name:@"saveboard" object:nil];
    //notifications for - reacting to the choice the user made
//    [notificationCenter addObserver:self selector:@selector(notificationUserDidSelectImageFromList:) name:@"imagefromlist" object:nil];
    [notificationCenter addObserver:self selector:@selector(notificationUpdateCell:) name:@"updatecellproperties" object:nil];
    
   // [notificationCenter addObserver:self selector:@selector(notificationUserDidRecordMessage:) name:@"messagerecorded" object:nil];
    
    [notificationCenter addObserver:self selector:@selector(notificationCreateBoardFromLink:) name:@"createNewBoardFromLink" object:nil];
    
    //notifications for - update cell with the choice the user made
    [notificationCenter addObserver:self selector:@selector(notificationUpdateCell:) name:@"updatecell" object:nil];
    
      
    
    //notifications for - merge/split cells
    
    //    @try{
    //        [notificationCenter removeObserver:self  forKeyPath:@"actiononcells"];
    //    }@catch(id anException){
    //        //do nothing, obviously it wasn't attached because an exception was thrown
    //        NSLog(@"Observer don't exists - %@",anException);
    //    }
    // [notificationCenter addObserver:self selector:@selector(notificationActiononCells:) name:@"actiononcells" object:nil];
    
    //---------------------------------------------------------------------
    
    
    //CGFloat btnHeight = btnAddNewMessage.frame.size.height;
    
    
    CGSize screenSize = [_globalFuncs calcWorkScreenSize];
    [_colEditBoard setFrame:CGRectMake(1, 1, screenSize.width, screenSize.height)];
    
    RFQuiltLayout* layout = (id)[_colEditBoard collectionViewLayout];
    [layout setDelegate:self];
    [layout setDirection: UICollectionViewScrollDirectionVertical];
    layout.blockPixels=[_globalFuncs calcCellSizewith_CollectionViewSize:_colEditBoard.frame.size];
    layout.prelayoutEverything=TRUE;
    
    
    
//    [self initBoard2];
    [_colEditBoard reloadData];
    
    
    
    UIMenuItem *menuItem = [[UIMenuItem alloc] initWithTitle:@"Merge Cells" action:@selector(MergeAction:)];
    UIMenuItem *menuItem1 = [[UIMenuItem alloc] initWithTitle:@"Split Cells" action:@selector(SplitAction:)];
    
    
    NSArray* arrayOfMenuItems = [[NSArray alloc]initWithObjects:menuItem,menuItem1, nil];
    [[UIMenuController sharedMenuController] setMenuItems:arrayOfMenuItems];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [self loadBoard];
    // [self.navigationController setTitle:@"TESTING"];
   
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillDisappear:(BOOL)animated
{
    // check if dissmis is because user pressed BACK
    if (self.isMovingFromParentViewController || self.isBeingDismissed){
            if (_appDelegate.flgEditBoardNavBack == NO) {
                // Do your stuff here
                // remove from array the last loaded board
                int iLastIndx = (int)[_appDelegate.arrayOfNavigationStackBoards count] -1;
                [_appDelegate.arrayOfNavigationStackBoards removeObjectAtIndex:iLastIndx];
                //check if the board on screen is the only one (the first) in the array
                if ([_appDelegate.arrayOfNavigationStackBoards count] > 0) {
                    board4Load = [_appDelegate.arrayOfNavigationStackBoards objectAtIndex:iLastIndx-1];
                    [self loadBoard];
                }
               
                _appDelegate.flgEditBoardNavBack = YES;
                
            }
        else
            _appDelegate.flgEditBoardNavBack=NO;
        }
}

-(void)createNavBar
{
    //set button on navigation bar - right side - EDIT MODE
//    [_imgNavbarBoardMenu setImage:[UIImage imageNamed:@"table_48x48.gif"]];
//    
//    UIBarButtonItem *boardmenuButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_imgNavbarBoardMenu];
//    [boardmenuButtonItem setAction:@selector(didPressBoardButton)];
//    
//    UIBarButtonItem *flexibleSpaceButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    
//    UIBarButtonItem *labelButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_lblNavbarTitle];
//
    
   
   // [self.navigationItem setLeftBarButtonItem:labelButtonItem];
    
   // self.navigationController.navigationBar.items =[NSArray arrayWithObjects:flexibleSpaceButtonItem,labelButtonItem, flexibleSpaceButtonItem, boardmenuButtonItem, nil];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 32, 32);
    [button setImage:[UIImage imageNamed:@"table_48x48.gif"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(didPressBoardButton) forControlEvents:UIControlEventTouchUpInside];
    
    navBoardButton=[[UIBarButtonItem alloc] init];
    [navBoardButton setCustomView:button];
    self.navigationItem.rightBarButtonItem=navBoardButton;
   

   
    
//
//    int WW = self.navigationController.navigationBar.frame.size.width;
//    _txtNavBar_BoardName=[[UITextField alloc]init];
//    [_txtNavBar_BoardName setBorderStyle:UITextBorderStyleRoundedRect];
//    _txtNavBar_BoardName.placeholder = @"Enter board name";
//    [_txtNavBar_BoardName setFrame:CGRectMake((WW-_txtNavBar_BoardName.frame.size.width)/2, 0, _txtNavBar_BoardName.frame.size.width, 30)];
//    [self.navigationController.navigationBar addSubview:_txtNavBar_BoardName];
//    [_txtNavBar_BoardName setDelegate:self];
    
   
    
//    [_toolbar setFrame:CGRectMake(0, 0, self.view.frame.size.width, TOOLBARHIGH)];
//    UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
//    
//    UIBarButtonItem *flexibleSpaceButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    
//    UIBarButtonItem *labelButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_lblTitle];
//    
//    
//    UIBarButtonItem *doneButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
//    
//    _toolbar.items = [NSArray arrayWithObjects:cancelButtonItem,flexibleSpaceButtonItem,labelButtonItem, flexibleSpaceButtonItem, doneButtonItem, nil];
    
}

#pragma mark -
#pragma  mark NOTIFICATIONS

-(void)notificationDismissPopover:(NSNotification*) notification
{
    NSLog(@"dismiss popover view");
    
    NSObject* obj = notification.object;
    NSLog(@"notification.object = %@",obj.description);
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


-(void)notificationUpdateCell:(NSNotification*) notification
{
    NSLog(@"update cell");
    
    // new-  -11/11/15
    Cell_class* updateCell = (Cell_class*)notification.object;
    _cellSelectedbyUser.cellBackgroundColor = updateCell.cellBackgroundColor;
    _cellSelectedbyUser.cellBoardLink = updateCell.cellBoardLink;
    _cellSelectedbyUser.cellBorderColor = updateCell.cellBorderColor;
    _cellSelectedbyUser.cellBorderWidth = updateCell.cellBorderWidth;
    _cellSelectedbyUser.cellFont = updateCell.cellFont;
    _cellSelectedbyUser.cellFontColor = updateCell.cellFontColor;
    _cellSelectedbyUser.cellFontSize = updateCell.cellFontSize;
    _cellSelectedbyUser.cellFontType = updateCell.cellFontType;
    _cellSelectedbyUser.cellImageID = updateCell.cellImageID;
    _cellSelectedbyUser.cellMessage = updateCell.cellMessage;
    _cellSelectedbyUser.cellMP3Path = updateCell.cellMP3Path;
    _cellSelectedbyUser.cellSoundFilename = updateCell.cellSoundFilename;
    _cellSelectedbyUser.cellSoundPath = updateCell.cellSoundPath;
    _cellSelectedbyUser.cellText = updateCell.cellText;
    _cellSelectedbyUser.cellHidden = updateCell.cellHidden;
    _cellSelectedbyUser.cellTextOnTop = updateCell.cellTextOnTop;
    _cellSelectedbyUser.cellVIDEOPath = updateCell.cellVIDEOPath;
    _cellSelectedbyUser.cellWEBPath = updateCell.cellWEBPath;
    
    
    NSLog(@"");
    
    [_colEditBoard reloadData];
    
     NSNotificationCenter* notificationcenter = [NSNotificationCenter defaultCenter];
    [notificationcenter postNotificationName:@"dismisspopover" object:nil];
}

-(void)notificationSaveBoard
{
    [self saveboard:NO];
}



-(void)notificationUserDidSelectImageFromList:(NSNotification*) notification
{
    NSLog(@"image received");
    [self.popover dismissPopoverAnimated:TRUE];
    
    Images_class* imgX = (Images_class*)notification.object;
    if (imgX != nil) {
        
        _cellSelectedbyUser.cellImageID = imgX.imgIndex;
        _cellSelectedbyUser.cellText = imgX.imgShowName;
        
        
    }
    else{
        NSLog(@"notificationUserDidSelectImageFromList - can't find image path");
        imgFromUserChoice=[UIImage imageNamed:@"myvoice.jpg"];
    }
    
    
    [_colEditBoard reloadData];
    
    NSNotificationCenter* notificationcenter = [NSNotificationCenter defaultCenter];
    [notificationcenter postNotificationName:@"dismisspopover" object:@"notificationUserDidSelectImageFromList"];
    
    
}

-(void)notificationUserDidSelectImageFromCamera:(NSNotification*) notification
{
    NSLog(@"image received");
    [self.popover dismissPopoverAnimated:TRUE];
    
    //    NSNotificationCenter* notificationcenter = [NSNotificationCenter defaultCenter];
    //    [notificationcenter postNotificationName:@"dismisspopover" object:@"notificationUserDidSelectImageFromCamera"];
    //
    
    Images_class* imgX = (Images_class*)notification.object;
    
    
    if (imgX != nil) {
        
        _cellSelectedbyUser.cellImageID = imgX.imgIndex;
        _cellSelectedbyUser.cellText=imgX.imgShowName;
    }
    else{
        NSLog(@"notificationUserDidSelectImageFromList - can't find image ");
        imgFromUserChoice=[UIImage imageNamed:@"myvoice.jpg"];
    }
    
    [_colEditBoard reloadData];
    
    
}

-(void)notificationUserDidSelectLink4Edit:(NSNotification*) notification
{
    
    NSLog(@"notificationUserDidSelectLink4Edit");
    BoardsList_class* board4Loading = (BoardsList_class*)notification.object;
    EditBoard_viewcontroller* editboardVC = [self.storyboard instantiateViewControllerWithIdentifier:@"editboard"];
    editboardVC.board4Load = board4Loading;
    [self saveboard:NO];
    NSLog(@"user choosed board using cellProperties - %@",board4Loading.brdFileName);
    
    [self.navigationController pushViewController:editboardVC animated:YES];

    
}


-(void)notificationRemoveImageFromCell:(NSNotification*) notification
{
    NSLog(@"notificationRemoveImageFromCell");
    [self.popover dismissPopoverAnimated:TRUE];
    
    _cellSelectedbyUser.cellImageID=nil;
    
    [_colEditBoard reloadData];
    
}



-(void)notificationUserDidRecordMessage:(NSNotification*) notification
{
    NSLog(@"message received");
   // [self.popover dismissPopoverAnimated:TRUE];
    
    
    NSString* recMessage = (NSString*)notification.object;
    _cellSelectedbyUser.cellSoundFilename=[recMessage stringByAbbreviatingWithTildeInPath];
    _cellSelectedbyUser.cellBtnPlayIsEnabled=true;
    NSLog(@"cellSelectedbyuser=%d",_cellSelectedbyUser.cellIndex);
    [_colEditBoard reloadData];
    
    
    
}

//-(void)notificationActiononCells:(NSNotification*)notification
//{
//    NSLog(@"notificationActiononCells");
//
////    NSLog(@"Action On Cells");
////    [self.popover dismissPopoverAnimated:TRUE];
//
//    NSNotificationCenter* notificationcenter = [NSNotificationCenter defaultCenter];
//    [notificationcenter postNotificationName:@"dismisspopover" object:@"notificationActiononCells"];
//
//
//    NSString* actionOnCell = (NSString*)notification.object;
//    if ([actionOnCell isEqual:@"Merge Cells"])
//    {
//
//        if (_arrayOfSelCells.count > 2) {
//            [_globalFuncs msgboxInfo:@"Merging only 2 first cells" dismissafter:2];
//        }
//
//        if(_arrayOfSelCells.count>=2)
//        {
//
//                [self sortCells4Merge];
//                Cell_class* cellA = [_arrayOfSelCells objectAtIndex:0];
//                Cell_class* cellB = [_arrayOfSelCells objectAtIndex:1];
//                [self mergeCells_custom:cellA andwith:cellB];
//                //[_arrayOfSelCells removeAllObjects];
//            }
//    }
//    if ([actionOnCell isEqual:@"Split Cells"]) {
//        if (_arrayOfSelCells.count == 1) {
//
//            [self split_cellswithCells:nil];
//        }
//    }
//
//
//    if ([actionOnCell isEqualToString:@"MERGE NEW TRY"]) {
//         [self mergeCells_newtry];
//    }
//
//    [_arrayOfSelCells removeAllObjects];
//}

-(void)notificationDoShowCamera:(NSNotification*) notification
{
    
    NSLog(@"show camera");
    
    NSNotificationCenter* notificationcenter = [NSNotificationCenter defaultCenter];
    [notificationcenter postNotificationName:@"dismisspopover" object:nil];

    
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    [controller setDelegate:(id)self];
    
    UIImagePickerControllerSourceType type = UIImagePickerControllerSourceTypeCamera;
    controller.sourceType = type;
    controller.showsCameraControls = YES;
    
    controller.modalPresentationStyle = UIModalPresentationCustom;
   
    controller.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    controller.view.superview.frame = CGRectMake(0, 0, 540, 620); //it's important to do this after presentModalViewController
   // controller.view.superview.center = V1.view.center;
   
    [self.navigationController dismissViewControllerAnimated:TRUE completion:nil];
    [self presentViewController:controller animated:YES completion:nil];
    
    
    
    
    //    UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:controller];
    //    [popover setDelegate:self];
    //    popover.popoverContentSize = controller.view.frame.size ; //CGSizeMake (325, 425); //your custom size.
    //
    //    [popover presentPopoverFromRect:CGRectMake(_pointOfRef4ShowPopup.x, _pointOfRef4ShowPopup.y, 10, 10) inView:self.view permittedArrowDirections: UIPopoverArrowDirectionAny animated:YES];
    
    
    
    
    //    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    //    controller.delegate = self;
    //    controller.
    //    controller.title = @"Choose a color for Background";
    //
    //
    //    UIImagePickerControllerSourceType type = UIImagePickerControllerSourceTypeCamera;
    //
    //    _picker.modalPresentationStyle = UIModalPresentationCurrentContext;
    //    _picker.allowsEditing = YES;
    //    _picker.sourceType = type;
    //    [self presentViewController:_picker animated:YES completion:nil];
    
    
    
    
    //    UINavigationController* navVC = [[UINavigationController alloc] initWithRootViewController:controller];
    //
    //
    //    UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:navVC];
    //    popover.delegate = self;
    //    popover.popoverContentSize = CGSizeMake (325, 425); //your custom size.
    //
    //    [popover presentPopoverFromRect:CGRectMake(_pointOfRef4ShowPopup.x, _pointOfRef4ShowPopup.y, 10, 10) inView:self.view permittedArrowDirections: UIPopoverArrowDirectionAny animated:YES];
    //
}



-(void)notificationDoShowPhotosLibrary:(NSNotification*) notification
{
    
    NSLog(@"show photos library");
    NSNotificationCenter* notificationcenter = [NSNotificationCenter defaultCenter];
    [notificationcenter postNotificationName:@"dismisspopover" object:nil];
    
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    [controller setDelegate:(id)self];
    
    UIImagePickerControllerSourceType type = UIImagePickerControllerSourceTypePhotoLibrary;
    controller.sourceType = type;
    controller.allowsEditing = YES;
    
    controller.modalPresentationStyle = UIModalPresentationCustom;
    controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    controller.view.superview.frame = CGRectMake(0, 0, 400, 350); //it's important to do this after presentModalViewController
    // controller.view.superview.center = V1.view.center;
    
    [self.navigationController dismissViewControllerAnimated:TRUE completion:nil];
    [self presentViewController:controller animated:YES completion:nil];
}


-(void)notificationDoShowColors4Background:(NSNotification*) notification
{
    
    NSLog(@"show colors dialogbox");
    NSNotificationCenter* notificationcenter = [NSNotificationCenter defaultCenter];
    [notificationcenter postNotificationName:@"dismisspopover" object:nil];
    
    
    NEOColorPickerViewController *controller = [[NEOColorPickerViewController alloc] init];//WithNibName:nil bundle:nil];
    controller.delegate = self;
    controller.selectedColor = self.currentColor;
    controller.title = @"Choose a color for Background";
  
    UINavigationController* navVC = [[UINavigationController alloc] initWithRootViewController:controller];
    
    
    UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:navVC];
    popover.delegate = self;
    popover.popoverContentSize = CGSizeMake (325, 425); //your custom size.
    
   
  [popover  presentPopoverFromRect:CGRectMake(_pointOfRef4ShowPopup.x, _pointOfRef4ShowPopup.y, 10, 10) inView:self.view permittedArrowDirections: UIPopoverArrowDirectionAny animated:YES];
    
}

-(void)notificationDoShowColors4Frame:(NSNotification*) notification
{
    
    NSLog(@"show colors dialogbox");
    NSNotificationCenter* notificationcenter = [NSNotificationCenter defaultCenter];
    [notificationcenter postNotificationName:@"dismisspopover" object:nil];
    
    
    NEOColorPickerViewController *controller = [[NEOColorPickerViewController alloc] init];
    controller.delegate = self;
    controller.selectedColor = self.currentColor;
    controller.title = @"Choose a color for Border";
    
    
    UINavigationController* navVC = [[UINavigationController alloc] initWithRootViewController:controller];
    
    
    UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:navVC];
    popover.delegate = self;
    popover.popoverContentSize = CGSizeMake (325, 425); //your custom size.
    
    [popover presentPopoverFromRect:CGRectMake(_pointOfRef4ShowPopup.x, _pointOfRef4ShowPopup.y, 10, 10) inView:self.view permittedArrowDirections: UIPopoverArrowDirectionAny animated:YES];
    
}

-(void)notificationDoShowVoiceRecorder: (NSNotification*) notification
{
    NSLog(@"show voice recorder dialogbox");
    [self.popover dismissPopoverAnimated:TRUE];
    
    VoiceRecorder *controller = [[VoiceRecorder alloc] init];
    UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:controller];
    [popover setDelegate:self];
    popover.popoverContentSize = controller.view.frame.size ; //CGSizeMake (325, 425); //your custom size.
    
    [popover presentPopoverFromRect:CGRectMake(_pointOfRef4ShowPopup.x, _pointOfRef4ShowPopup.y, 10, 10) inView:self.view permittedArrowDirections: UIPopoverArrowDirectionAny animated:YES];
}

-(void)notificationDoShowListOfImages:(NSNotification*) notification
{
    NSLog(@"show List of Images+SearchBar");
    [self.popover dismissPopoverAnimated:TRUE];
    
    
    ListofObjects_tableviewcontroller *controller = [[ListofObjects_tableviewcontroller alloc] init];
    controller.showImages = TRUE;
    controller.showBoards = FALSE;
    controller.showAddSymbol = FALSE;
    
//    [_popupmenuVC.navigationController pushViewController:controller animated:YES];
    
    
    
    
//    UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:controller];
//    popover.delegate = self;
//    // popover.popoverContentSize = CGSizeMake(IMAGELIST_VIEW_SIZE_W, IMAGELIST_VIEW_SIZE_H);  //controller.view.frame.size ; //CGSizeMake (325, 425); //your custom size.
//    
//    [popover presentPopoverFromRect:CGRectMake(_pointOfRef4ShowPopup.x, _pointOfRef4ShowPopup.y, 10, 10) inView:self.view permittedArrowDirections: UIPopoverArrowDirectionAny animated:YES];
}

-(void)notificationDoShowListOfBoards:(NSNotification*) notification
{
    NSLog(@"show List of Boards+SearchBar");
    //[self.popover dismissPopoverAnimated:TRUE];
    
    
    ListofObjects_tableviewcontroller *controller = [[ListofObjects_tableviewcontroller alloc] init];
    controller.showImages = FALSE;
    controller.showBoards = TRUE;
    controller.showAddSymbol = TRUE;
    
       
 //   [_popupmenuVC.navigationController pushViewController:controller animated:YES];
}

-(void)notificationCreateBoardFromLink:(NSNotification*) notification
{
    
    NewBoardOptions_viewcontroller* newBoardVC = [[NewBoardOptions_viewcontroller alloc]init];
    newBoardVC.flgShowModal = TRUE;
    
//    [_popupmenuVC.navigationController pushViewController:newBoardVC animated:YES];
    
//    UINavigationController* navControl = [[UINavigationController alloc]initWithRootViewController:newBoardVC];
////    UIBarButtonItem* btnDone = [[UIBarButtonItem alloc]init];
////    [btnDone setTitle:@"DOne"];
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.frame = CGRectMake(0, 0, 32, 32);
//   // [button setImage:[UIImage imageNamed:@"settings_b.png"] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(openView) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIBarButtonItem *barButton=[[UIBarButtonItem alloc] init];
//    [barButton setCustomView:button];
//    navControl.navigationItem.rightBarButtonItem=barButton;
//// show the NewBoardOptions as modal
////    newBoardVC.modalPresentationStyle = UIModalPresentationFormSheet;
////    newBoardVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
////    [self presentViewController:newBoardVC animated:YES completion:nil];
//    
//    
//    navControl.modalPresentationStyle = UIModalPresentationFormSheet;
//    navControl.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
//    [self presentViewController:navControl animated:YES completion:nil];
    
    
//    float WW = self.view.layer.bounds.size.width;
//    float HH = self.view.layer.bounds.size.height;
//    
//    WW=WW-(WW*(2.0f/100.0f));
//    HH=HH-(HH*(5.0f/100.0f));
//
//    newBoardVC.view.superview.frame = CGRectMake(0, 0, WW, HH); //it's important to do this after presentModalViewController
//    newBoardVC.view.superview.center = newBoardVC.view.center;
   
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
#pragma mark CollectionView

#pragma mark UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _arrayOfCells.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // NSLog(@"collDataSource - load cells with classCell");
    
    EditBoardCell_collectionviewcell* currCell;
    currCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"customcell" forIndexPath:indexPath];
    currCell.delegate=self;
    Cell_class* currCell_class = [_arrayOfCells objectAtIndex:indexPath.row];
    


    // update grid's cell with image
    // clean existing image from prev collection.reload
     currCell.imgSymbolCell.image = nil;
    
    // search for the image in arrayOfImages and retrieve its info
   Images_class* currImage = [[Images_class alloc]init];
    BOOL flgFileExists = NO;
    if ([currCell_class.cellImageID integerValue] > -1 && currCell_class.cellImageID != nil) {
        for (int i=0;i<_appDelegate.arrayOfImages.count; i++) {
            Images_class* imgX = [_appDelegate.arrayOfImages objectAtIndex:i];
            
            if ([imgX.imgIndex isEqualToString:currCell_class.cellImageID]) {
                NSLog(@"EditBoard_viewcontroller - found the image %d in array",currCell_class.cellIndex);
                flgFileExists=YES;
                currImage = imgX;
                i =[[NSNumber numberWithLong:[_appDelegate.arrayOfImages count]] intValue];
            }
        }
        
        
        // if file exists - update it
        if (flgFileExists) {
            NSString* imgFullFilename = [_globalFuncs getFullDirectoryPathfor:currImage.imgPath];
            imgFullFilename = [imgFullFilename stringByAppendingPathComponent:currImage.imgFileName];
            
            UIImage* imgX = [UIImage imageWithContentsOfFile:imgFullFilename];
            currCell.imgSymbolCell.image = imgX;
        }
        else // file not exisitng  OR user choosed to remove it
        {
            // currCell.imgSymbolCell.image = nil;
            
        }
    }
    //--------------------------------------------------------
    
    
    currCell.contentView.layer.cornerRadius=20;
    
    //update cell BorderWidth and BorderColor
    [currCell.contentView.layer setBorderWidth:currCell_class.cellBorderWidth];
    [currCell.contentView.layer setBorderColor:[currCell_class.cellBorderColor CGColor]];
    //--------------------------------------------------------

    //update cell BackgroundColor
    [currCell.contentView setBackgroundColor:currCell_class.cellBackgroundColor];
    //--------------------------------------------------------
    
    //update cell - HIDDEN or NOT
    if (currCell_class.cellHidden) {
       [currCell.contentView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"pattern.jpeg"]]];
    }
    //--------------------------------------------------------
    
//    // if the cell is in its basic size (1,1) then disable the buttons
//    // so the user can touch and select
//    if (currCell_class.size.width == 1 && currCell_class.size.height == 1) {
//       // [currCell.btnPlayMSG setEnabled:false];
//        [currCell.btnEditCell setEnabled:false];
//    }
//    else
//    {
//        [currCell.btnPlayMSG setEnabled:currCell_class.cellBtnPlayIsEnabled];
//        //[currCell.btnEditCell setEnabled:true];
//    }
    
    
    
    [self rearange_objectsInCell:currCell];
    
    //update TEXTONTOP
    if (currCell_class.cellTextOnTop == FALSE) {
        currCell.lblTextTop.hidden = YES;
        currCell.lblTextBottom.hidden = NO;
    }
    else
    {
        currCell.lblTextTop.hidden = NO;
        currCell.lblTextBottom.hidden = YES;
    }
    //--------------------------------------------------------
    
    
    //update cell FONT

    NSString* currFont = CELLDEFAULTFONT.fontName; //   currCell_class.cellFont.fontName;
    [currCell.lblTextTop setFont:[UIFont fontWithName:currFont size:currCell_class.cellFontSize]];
    UIFontDescriptor* fontD ;
    switch (currCell_class.cellFontType) {
        case 0:
            fontD = [UIFontDescriptor fontDescriptorWithName:CELLDEFAULTFONT.fontName size:currCell_class.cellFontSize];
            break;
        case 1:
            fontD =  [CELLDEFAULTFONT.fontDescriptor fontDescriptorWithSymbolicTraits: UIFontDescriptorTraitBold];
            break;
        case 2:
            fontD = [CELLDEFAULTFONT.fontDescriptor fontDescriptorWithSymbolicTraits: UIFontDescriptorTraitItalic];
            break;
        default:
            currCell_class.cellFont = [UIFont fontWithName:CELLDEFAULTFONT.fontName size:currCell_class.cellFontSize];
            break;
    }
    
    [currCell.lblTextTop setFont:[UIFont fontWithDescriptor:fontD size:currCell_class.cellFontSize]];
    [currCell.lblTextBottom setFont:[UIFont fontWithDescriptor:fontD size:currCell_class.cellFontSize]];
    
    
    if (currCell_class.cellFontColor != nil) {
        [currCell.lblTextTop setTextColor:currCell_class.cellFontColor];
        [currCell.lblTextBottom setTextColor:currCell_class.cellFontColor];
    }
    else{
        [currCell.lblTextTop setTextColor:[UIColor blackColor]];
        [currCell.lblTextBottom setTextColor:[UIColor blackColor]];
    }
     //--------------------------------------------------------   [
    
    // update grid's cell with text
    NSString* str = currCell_class.cellText;
    [currCell.lblTextTop setText:str];
    [currCell.lblTextBottom setText:str];
    
    //--------------------------------------------------------
      return currCell;
}


//-(void)userDidTapOnCell:(UITapGestureRecognizer *)recognizer
//{
//
//
////
////    EditBoard_viewcontroller* didTapCell = [[EditBoard_viewcontroller alloc]init];
////    didTapCell= recognizer.self;
////
////
////    //if code entered this function, it means the user tapped 1 times (once)
////  //  NSIndexPath *indexPath = [_colEditBoard indexPathForCell:didTapCell.col];
////    _cellSelectedbyUser = _arrayOfCells[indexPath.row];
////
////
////    UIAlertView* inpBox = [[UIAlertView alloc]initWithTitle:TEXT_ALERT_TITLE message:@"Enter new text" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
////    inpBox.alertViewStyle = UIAlertViewStylePlainTextInput;
////    [inpBox show];
//
//
//}

//-(void)userDidPressLongOnCell
//{
//    //if code entered this function, it means the user tapped 2 times (twice)
//
//    // popupmenuPopoverController is declared as UIPopOverController
//    if ([self.popover isPopoverVisible]) {
//        [self.popover dismissPopoverAnimated:YES];
//    }
//    else
//    {
//
//        NSError* error;
////        NSIndexPath *indexPath = [_colEditBoard indexPathForCell:cell];
////        _cellSelectedbyUser = _arrayOfCells[indexPath.row];
//
//        //todo - create a list of choices if the cell contains also link to MP3 or VIDEO or WEB
//        if (_cellSelectedbyUser.cellSoundFilename == nil) {
//            return;
//        }
//        NSURL* url = [[NSURL alloc]initFileURLWithPath:[_cellSelectedbyUser.cellSoundFilename stringByExpandingTildeInPath]];
//        // the _audioplayer HAS to be declared global and allocated in viewDidLoad
//        //otherwise the AVAudioPlayer releases the object before playing => no sound heared
//        [_audioPlayer initWithContentsOfURL:url error:&error];
//
//        [_audioPlayer prepareToPlay];
//        [_audioPlayer setNumberOfLoops:0];
//        [_audioPlayer setVolume:0.5];
//        [_audioPlayer play];
//
//
//
//    }
//
//
//
//}
//



#pragma mark UICollectionViewDelegate

//#pragma functions for showing menu action
//- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
//    return YES;  // YES for the Cut, copy, paste actions
//}
//
//- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
//    return YES;
//}
//
//- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
//    NSLog(@"performAction");
//}
//
//// UIMenuController required methods (Might not be needed on iOS 7)
//- (BOOL)canBecomeFirstResponder {
//    // NOTE: This menu item will not show if this is not YES!
//    return YES;
//}
//
//// NOTE: on iOS 7.0 the message will go to the Cell, not the ViewController. We need a delegate protocol
////  to send the message back. On iOS 6.0 these methods work without the delegate.
//
//- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
//    NSLog(@"canPerformAction");
//    // The selector(s) should match your UIMenuItem selector
//    if (action == @selector(customAction:)) {
//        return YES;
//    }
//    return NO;
//}
//
//// Custom Action(s) for iOS 6.0
//- (void)customAction:(id)sender {
//    NSLog(@"custom action! %@", sender);
//}
//
//// iOS 7.0 custom delegate method for the Cell to pass back a method for what custom button in the UIMenuController was pressed
//- (void)customAction:(id)sender forCell:(EditBoardCell_collectionviewcell *)cell {
//    NSLog(@"custom action on iOS 7.0");
//}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    EditBoardCell_collectionviewcell* currCell = (EditBoardCell_collectionviewcell*)[collectionView cellForItemAtIndexPath:indexPath];
    currCell.delegate=self;
    Cell_class* theCell = _arrayOfCells[indexPath.row];
  
    // change - 25-09-2015
    //theCell.coordinates =  CGPointMake(currCell.frame.origin.x, currCell.frame.origin.y);
    //---------------------
    theCell.size = CGSizeMake(currCell.frame.size.width, currCell.frame.size.height);
    
    //    if (_isCellSelectionbyUser) {
    //        if (theCell.selected)
    //        {
    //            theCell.selected=NO;
    //            currCell.contentView.backgroundColor = [UIColor whiteColor];
    //           [_arrayOfSelCells removeObject:theCell];
    //
    //        }
    //        else
    //        {
    //            theCell.selected=YES;
    //            currCell.contentView.backgroundColor = [UIColor blueColor];
    //
    //            [_arrayOfSelCells addObject:theCell];
    //        }
    //        _cellSelectedbyUser = theCell;
    //    }
    //    else{
    
    currCell.imgSymbolCell.image=imgFromUserChoice.images[0];
    [_colEditBoard reloadData];
    
    //    }
    
    //  NSLog(@"didSelectItemAtIndexPath x=%f, y=%f",theCell.coordinates.x,theCell.coordinates.y);
    
}

#pragma mark -
#pragma mark CellClicked Delegate

-(void)didClickEditCell:(EditBoardCell_collectionviewcell *)cell{
    
    int Q = 1;
    if (Q==1) {
        NSIndexPath *indexPath = [_colEditBoard indexPathForCell:cell];
        _cellSelectedbyUser = _arrayOfCells[indexPath.row];

        [self showSplitView];
        return;
    }
    
    // popupmenuPopoverController is declared as UIPopOverController
//    if ([self.popover isPopoverVisible]) {
//        [self.popover dismissPopoverAnimated:YES];
//    }
//    else
//    {
    
    NSIndexPath *indexPath = [_colEditBoard indexPathForCell:cell];
    _cellSelectedbyUser = _arrayOfCells[indexPath.row];
    _currCellSelectedbyUser = (EditBoardCell_collectionviewcell*)[_colEditBoard cellForItemAtIndexPath:indexPath];
    
    CGPoint newpoint = [_currCellSelectedbyUser convertPoint:_currCellSelectedbyUser.btnEditCell.center toView:self.view];
    
 //   _popupmenuVC = [self.storyboard instantiateViewControllerWithIdentifier:@"popupmenu"];
    
      // show the popup
    //send notification
    NSNotificationCenter* notificationCenter = [NSNotificationCenter defaultCenter];
    NSValue *valPoint4Popup = [NSValue valueWithCGPoint:newpoint];
    [notificationCenter postNotificationName:@"point4popup" object:valPoint4Popup];
    
    _pointOfRef4ShowPopup=newpoint;
    
    
    EditCell_viewcontroller* editCell_VC = [[EditCell_viewcontroller alloc]init];
    
    UIPopoverController *popoverController = [[UIPopoverController alloc] initWithContentViewController:editCell_VC];
    popoverController.delegate = self;  //optional
    
    //todo - arrange so the popover will show in the center of the screen
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat screenWidth = screenSize.width;
    CGFloat screenHeight = screenSize.height;
    
    float WW = screenWidth - (screenWidth * 9/100);
    float HH = screenHeight - (screenHeight * 15/100);
    
    CGSize size = CGSizeMake(WW,HH); // size of view in popover…V2
    popoverController.popoverContentSize = size;
    //    viewModal2.view.center = self.view.superview.center;
    
    //    float HH = (self.view.superview.bounds.size.height - size.height)/2;
    //    float WW = (self.view.superview.bounds.size.width - size.width)/2;
    
    [popoverController presentPopoverFromRect:CGRectMake(40,40,10,10) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];

    
//    CGSize size = CGSizeMake(WW,HH); // size of view in popover…V2
//    popoverController.popoverContentSize = size;
//    //    viewModal2.view.center = self.view.superview.center;
//    
//    //    float HH = (self.view.superview.bounds.size.height - size.height)/2;
//    //    float WW = (self.view.superview.bounds.size.width - size.width)/2;
//    CGRect viewRect = [_globalFuncs getViewSize:self.view];
//    
//    float XX = (screenSize.width - WW)/2;
//    float YY = (screenSize.height - HH)/2;
//    
//  //  [popoverController presentPopoverFromRect:CGRectMake(_pointOfRef4ShowPopup.x,_pointOfRef4ShowPopup.y,10,10) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
//    [popoverController presentPopoverFromRect:CGRectMake(300,YY,5,5) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];

    
    
    
    
//    self.modalPresentationStyle = UIModalPresentationPopover;
//    self.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
//    
//    [self presentViewController:editCell_VC animated:true completion:nil];
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    //in order to be able to navigate between the menu and submenus, we need to declare UInavigation cotroller.
//    //IMPORTANT: UINAvigation controller CONTAINS the rest of the views that are acting like menus and are popover.
//    
//    
//    UINavigationController* navPopover_controller = [[UINavigationController alloc]initWithRootViewController:_popupmenuVC];
//    
//   // navPopover_controller.preferredContentSize = CGSizeMake(20, 12);
//    
//    
//    UIPopoverController *popover = [[UIPopoverController alloc]initWithContentViewController:navPopover_controller];
//    popover.delegate = self;
//    
//    //popover.popoverContentSize = CGSizeMake(20, 12);  //controller.view.frame.size ; //CGSizeMake (325, 425); //your custom size.
//    
//    
//    [popover presentPopoverFromRect:CGRectMake(newpoint.x, newpoint.y,10,10) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
    
}

-(void)showSplitView
{
    NSString * storyboardName = @"SplitView";
    NSString * viewControllerID = @"splitview";
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    SplitView_manual_viewcontroller* controller = (SplitView_manual_viewcontroller *)[storyboard instantiateViewControllerWithIdentifier:viewControllerID];
    
    controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    controller.modalPresentationStyle = UIModalPresentationFormSheet;
    
    controller.cellEditProperties = _cellSelectedbyUser;
    
    [self presentViewController:controller animated:YES completion:nil];

}

-(void)didDoubleTapInCell:(EditBoardCell_collectionviewcell *)cell
{
    NSIndexPath *indexPath = [_colEditBoard indexPathForCell:cell];
    _cellSelectedbyUser = _arrayOfCells[indexPath.row];
    
    NSLog(@"arrayofcells.count=%lu",_arrayOfCells.count);
    
    [EasyAlertView showWithTitle:TEXT_ALERT_TITLE
                         message:@"Enter new text"
                      alertStyle:UIAlertViewStylePlainTextInput
                      usingBlock:^(NSUInteger buttonIndex, NSMutableArray* inpText) {
                          if (buttonIndex == 0) {
                              _cellSelectedbyUser.cellText=[inpText objectAtIndex:0];
                              [_colEditBoard reloadData];
                          }
                      }
     
               cancelButtonTitle:@"OK"
               otherButtonTitles:@"Cancel", nil];
    
}

-(void)didTapOnceInCell:(EditBoardCell_collectionviewcell *)cell
{
    NSLog(@"didTapOnceInCell");
    
    NSIndexPath *indexPath = [_colEditBoard indexPathForCell:cell];
    _cellSelectedbyUser = _arrayOfCells[indexPath.row];
    
    
    
    if (_isCellSelectionbyUser) {
        if (_cellSelectedbyUser.selected)
        {
            _cellSelectedbyUser.selected=NO;
            [cell.contentView setBackgroundColor:[_cellSelectedbyUser cellBackgroundColor]];
            [_arrayOfSelCells removeObject:_cellSelectedbyUser];
            NSLog(@"_arrayOfSelCells remove item - new count is %lu",(unsigned long)_arrayOfSelCells.count);
            
            
            
        }
        else
        {
            _cellSelectedbyUser.selected=YES;
            [cell.contentView setBackgroundColor:[UIColor lightGrayColor]];
            [_arrayOfSelCells addObject:_cellSelectedbyUser];
            NSLog(@"_arrayOfSelCells add item - new count is %lu",(unsigned long)_arrayOfSelCells.count);
        }
    }
    
    
}

-(void)showRightClickMenu:(EditBoardCell_collectionviewcell *)cell
{
    NSIndexPath *indexPath = [_colEditBoard indexPathForCell:cell];
    _cellSelectedbyUser = _arrayOfCells[indexPath.row];
    
    
    UIAlertView* popupMenu = [[UIAlertView alloc]initWithTitle:@"RClick menu"
                                                       message:@"What would you like to do ?"
                                                      delegate:self cancelButtonTitle:@"Merge Cells"
                                             otherButtonTitles:@"Split Cells", @"Cancel", nil];
    
    popupMenu.cancelButtonIndex=2;
    [popupMenu show];
    
}


-(void)didPlayMessageInCell:(EditBoardCell_collectionviewcell *)cell
{
    
    
    NSIndexPath *indexPath = [_colEditBoard indexPathForCell:cell];
    _cellSelectedbyUser = _arrayOfCells[indexPath.row];
    
    // check if user made a voice recording
    
    if (_cellSelectedbyUser.cellSoundFilename == nil) {
     
        // he didn't, then use
        // Text - to - Speech
        
        Text2Speech* T2S = [[Text2Speech alloc]init];
        NSString* string = _cellSelectedbyUser.cellText;
        AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc] initWithString:string];
        NSLog(@"BCP-47 Language Code: %@", [T2S getGuessedUtteranceLanguageCode:string]);//   BCP47LanguageCodeForString(utterance.speechString));
        
        // guess user lang according to text
        utterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:[T2S getGuessedUtteranceLanguageCode:string]];
        NSLog(@"BCP-47 Language Code: %@", [T2S getGuessedUtteranceLanguageCode:string]);
        
        //utterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:[T2S getUtteranceLanguageCode:@"English"]];
        
        //    utterance.pitchMultiplier = 0.5f;
        utterance.rate = AVSpeechUtteranceMinimumSpeechRate;
        utterance.preUtteranceDelay = 0.0f; // 0.2f;
        utterance.postUtteranceDelay = 0.2f;
        
        AVSpeechSynthesizer *speechSynthesizer=[[AVSpeechSynthesizer alloc] init];
        speechSynthesizer.delegate = self;
        [speechSynthesizer speakUtterance:utterance];
    }
    else{
        // popupmenuPopoverController is declared as UIPopOverController
        if ([self.popover isPopoverVisible]) {
            [self.popover dismissPopoverAnimated:YES];
        }
        else
        {
            NSFileManager* fileManager = [[NSFileManager alloc]init];
            if ([fileManager fileExistsAtPath:[_cellSelectedbyUser.cellSoundFilename stringByExpandingTildeInPath]])
            {
                NSLog(@"play sound -%@",_cellSelectedbyUser.cellSoundFilename);
                //[GlobalData playTrack:TMP_REC_PATH ext:@""];
                
                AVAudioSession * audioSession = [AVAudioSession sharedInstance];
                [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
                [audioSession setActive:YES error:nil];
                //init Audio Player
                NSURL* url = [[NSURL alloc]initFileURLWithPath:[_cellSelectedbyUser.cellSoundFilename stringByExpandingTildeInPath]];
                NSError * playerError;
                _audioPlayer = [_audioPlayer initWithContentsOfURL:url error:&playerError];
                //[_audioPlayer setDelegate:self];
                if (playerError!= nil)
                    NSLog(@"Player initialization error: %@",playerError.description);
                
                if ([self.audioPlayer prepareToPlay])
                {
                    //self.wasPlaying = YES;
                    NSLog(@"Player prepared");
                    [_audioPlayer play];
                }
                else
                {
                    NSLog(@"Player not prepared");
                }
                
            }
            
        }
        
    }
    ///        // the _audioplayer HAS to be declared global and allocated in viewDidLoad
    //        //otherwise the AVAudioPlayer releases the object before playing => no sound heared
    //        [_audioPlayer initWithContentsOfURL:url error:&error];
}


#pragma mark -
#pragma mark Misc Functions



-(void)loadBoard
{
    
    NSLog(@"EditBoard - viewWillAppear");
    
    if (_appDelegate.flgRunBoardMode) {
        NSLog(@"Run Mode");
    }
    
    //update the _boardSelectedbyUser with current data
    
    // new board
    //    if (boardSelectedbyUser.brdID == 0 && Cols !=0 && Rows != 0)
    //    if ([myTag isEqualToString:@"newboard"]) {
    //    {
    //        //new board
    //        boardSelectedbyUser.brdName = @"Default";
    //        boardSelectedbyUser.brdCols=[NSNumber numberWithInt:Cols];
    //        boardSelectedbyUser.brdRows=[NSNumber numberWithInt:Rows];
    //        boardSelectedbyUser.brdCreatedBy = @"admin";
    //        boardSelectedbyUser.brdCreatedDate = [NSDate date];
    //        boardSelectedbyUser.brdLastUpdatedBy=@"admin";
    //        boardSelectedbyUser.brdLastUpdateDate=[NSDate date];
    //        //todo - later - if the app will work by users id
    //        boardSelectedbyUser.brdUserID=9999;
    //
    //        //show current data in userdefaults
    //        NSLog(@"%@", [[NSUserDefaults standardUserDefaults] dictionaryRepresentation]);
    //
    //        //todo - later - if the app will work by users id
    //
    ////        if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"UserID"] intValue] != boardSelectedbyUser.brdUserID) {
    ////
    ////            // NSString* strUserID = [NSString stringWithFormat:@"%d",boardSelectedbyUser.brdUserID];
    ////            NSString* strBoardIndx = [NSString stringWithFormat:@"%d01",boardSelectedbyUser.brdUserID];
    ////            boardSelectedbyUser.brdID = [strBoardIndx intValue];
    ////
    ////            [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInt:boardSelectedbyUser.brdID] forKey:@"BoardIndex"];
    ////
    ////
    ////            [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInt:boardSelectedbyUser.brdUserID] forKey:@"UserID"];
    ////
    ////        }
    ////        else
    ////        {
    ////            boardSelectedbyUser.brdUserID = [[[NSUserDefaults standardUserDefaults] valueForKey:@"UserID"] intValue];
    //
    //
    //        // read the existing boardID
    //            boardSelectedbyUser.brdID  = [[[NSUserDefaults standardUserDefaults] valueForKey:@"BoardIndex"] intValue];
    //        // +1
    //            boardSelectedbyUser.brdID++;
    //
    //        //put it back in userDefaluts
    //        [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInt:boardSelectedbyUser.brdID] forKey:@"BoardIndex"];
    //
    ////}
    //        // save userDefaults
    //        [[NSUserDefaults standardUserDefaults] synchronize];
    //
    //    }
    //
    //    else //load the existing data from existing board
    //    {
//    if (_appDelegate.flgEditBoardNavBack) {
//        
//    }
    else{
    
        //todo - read from userDefaults his default settings
        
        
        
        [_arrayOfCells removeAllObjects];
        [_matrixOfCells removeAllObjects];
        
        //------------------------------------------------------
        
        NSLog(@"show loaded board");
        // BoardsList_class* board4Loading = (BoardsList_class*)notification.object;
        XMLmanager_class* xmlFuncs = [[XMLmanager_class alloc]init];
        //retrieve the board from the array. the board will ALWAYS sit at index 0
        [xmlFuncs loadBoardData:board4Load];
      //  int iLastIndx = (int)[_appDelegate.arrayOfNavigationStackBoards count]-1;
      //  NSArray* array = [[NSArray alloc]initWithArray:[_appDelegate.arrayOfNavigationStackBoards objectAtIndex:iLastIndx]];
        boardSelectedbyUser = [_appDelegate.arrayOfLoadedBoard objectAtIndex:0];
        [self setTitle:boardSelectedbyUser.brdName];
        
        //boardSelectedbyUser = [_appDelegate.arrayOfNavigationStackBoards objectAtIndex:[_appDelegate.arrayOfNavigationStackBoards count]];
        //  Board_class* brd4Load =  [[_appDelegate arrayOfLoadedBoard] objectAtIndex:0];
        //            EditBoard_viewcontroller* editboardVC = [self.storyboard instantiateViewControllerWithIdentifier:@"editboard"];
        //
        //
        //            editboardVC.Cols = [brd4Load.brdCols intValue];
        //            editboardVC.Rows = [brd4Load.brdRows intValue];
        //            editboardVC.BoardName = brd4Load.brdName;
        //            editboardVC.boardSelectedbyUser = brd4Load;
        //
        //            NSLog(@"user choosed board using cellProperties - %@",brd4Load.brdName);
        //
        //            [self.navigationController pushViewController:editboardVC animated:YES];
        
        
        
        
        
        
        
        //---------------------------------------------------------
        NSMutableArray* arrayTMP = [[NSMutableArray alloc]init];
        for (int i=1; i<[[_appDelegate arrayOfLoadedBoard] count]; i++) {
            [arrayTMP addObject:[[_appDelegate arrayOfLoadedBoard] objectAtIndex:i]];
        }
        
        _matrixOfCells = [arrayTMP mutableCopy];
        
        
        for (int i=0; i<_matrixOfCells.count; i++)
        {
            NSMutableArray* arrayTMP = [[NSMutableArray alloc]initWithArray:[_matrixOfCells objectAtIndex:i]];
            for (int j=0; j<arrayTMP.count; j++ ) {
                Cell_class* cellFromData = [[Cell_class alloc]init];
                cellFromData = [arrayTMP objectAtIndex:j];
                
                if (cellFromData.mark4show)
                    [_arrayOfCells addObject:cellFromData];
            }
        }
        
        [_globalFuncs PrintOut_matrix:_matrixOfCells showIndex:NO showMark:YES];
        [_colEditBoard reloadData];
    }
    //    }
    
    NSLog(@"%@", [[NSUserDefaults standardUserDefaults] dictionaryRepresentation]);
    
    
    //    [self initBoard2];
    [_colEditBoard reloadData];
    
    // Cols = 0; Rows = 0;
    
    // this IF is for testing. if Cols and Rows =0 -> the app will show basic matrix of 12x12
    //    if (Cols==0 && Rows==0) {
    //
    //        Cols=NUMOFCELLSINCOL;
    //        Rows=NUMOFCELLSINROW;
    //    }
    //    else
    //        //[self mergeCellsAutowithRequestedCols:Cols andwithRequestedRows:Rows];
    //        [self mergeCells_auto_withNumOfRows:Rows andwithNumOfCols:Cols];
    

    
    
    
}



-(void)didPressBoardButton
{
    NSLog(@"show Board List");
    // [self.popover dismissPopoverAnimated:TRUE];
    
    BoardPopupmenu_tableviewcontroller *controller = [[BoardPopupmenu_tableviewcontroller alloc] init];
    [controller setDelegate:self];
    
    //check if any of the menu items on BoardPopupmenu should be disabled
    if (_arrayOfSelCells.count <= 1)// || _arrayOfSelCells.count != 2)
        controller.mnuMergeEnabled = false;
    else
        controller.mnuMergeEnabled = true;
    
    if (_arrayOfSelCells.count != 1)
        controller.mnuSplitEnabled = false;
    else
        controller.mnuSplitEnabled = true;
    
    controller.mnuUndoEnabled = _setMenuUndo;
    
    
    //in order to be able to navigate between the menu and submenus, we need to declare UInavigation cotroller.
    //IMPORTANT: UINAvigation controller CONTAINS the rest of the views that are acting like menus and are popover.


    UINavigationController* navPopover_controller = [[UINavigationController alloc]initWithRootViewController:controller];
    
    navPopover_controller.preferredContentSize = CGSizeMake(BOARDMENU_VIEW_SIZE_W, BOARDMENU_VIEW_SIZE_H);
    
    
    UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:navPopover_controller];
    popover.delegate = self;

    
    popover.popoverContentSize = CGSizeMake(BOARDMENU_VIEW_SIZE_W, BOARDMENU_VIEW_SIZE_H);  //controller.view.frame.size ; //CGSizeMake (325, 425); //your custom size.
    
    
    [popover presentPopoverFromBarButtonItem:navBoardButton permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    // [popover presentPopoverFromRect:CGRectMake(_pointOfRef4ShowPopup.x, _pointOfRef4ShowPopup.y, 10, 10) inView:self.view permittedArrowDirections: UIPopoverArrowDirectionAny animated:YES];
    
}

//-(void)setStartupBoard
//{
//    
//    NavTable_tableviewcontroller* navTableList = [[NavTable_tableviewcontroller alloc]init];// or UITableVC as which VC you have in your file
//    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:navTableList];
//    //[self.window addSubview:navController.view]; // this is an important line if missed out dont show navController
//    [self showViewController:navController sender:nil];
//}

-(void)showListOfBoards
{
    
    ListofObjects_tableviewcontroller *controller = [[ListofObjects_tableviewcontroller alloc] init];
    controller.showImages = NO;
    controller.showBoards = YES;
    controller.flgSetHomePage = NO; //indicates that the selected board id for loading and editing
    
    [self.navigationController pushViewController:controller animated:YES];
}

//-(void)saveboard_as
//{
//    
//    BoardsList_class* newBoard = [[BoardsList_class alloc]init];
//    // NSString* strName=@"";
//    
//    [EasyAlertView showWithTitle:BOARD_ALERT_TITLE message:@"Save Board as" alertStyle:UIAlertViewStylePlainTextInput usingBlock:^(NSUInteger buttonIndex, NSMutableArray* inpText)
//     {
//         
//         
//         newBoard.brdID = boardSelectedbyUser.brdID;
//         newBoard.brdFileName = [_globalFuncs repairString4UseAsFilename:[inpText objectAtIndex:0]];
//         newBoard.brdDate = [NSDate date];
//         //to do - open dlgbox and let user to set a personal icon for his main board
//         // there will be a folder containg the icons.
//         newBoard.brdIcon = @"stars.png";
//         
//         int flgBoardExistsAtIndex=-1;
//         
//         if (buttonIndex == 0) {
//             // check if there is allready a board with the same name
//             for (int i=0;i<[_appDelegate.arrayOfBoards count] ;i++)
//             {
//                 BoardsList_class* brdX = [[BoardsList_class alloc]init];
//                 brdX = [_appDelegate.arrayOfBoards objectAtIndex:i];
//                 if ([brdX.brdFileName isEqualToString:[inpText objectAtIndex:0]]) {
//                     flgBoardExistsAtIndex=i;
//                 }
//             }
//             
//             if (flgBoardExistsAtIndex>=0) {
//                 [EasyAlertView showWithTitle:BOARD_ALERT_TITLE message:@"Board with this name already exists."alertStyle:UIAlertViewStyleDefault usingBlock:^(NSUInteger buttonIndex, NSMutableArray* inpText)
//                  {
//                      if (buttonIndex == 0) { //user wants to replace existing board
//                          
//                          [_appDelegate.arrayOfBoards replaceObjectAtIndex:flgBoardExistsAtIndex withObject:newBoard];
//                          
//                          
//                          // save the board file containing the actuall data - board info + cells info
//                          NSMutableArray* arrayData4Save  = [[NSMutableArray alloc]initWithObjects:boardSelectedbyUser, nil];
//                          //[arrayData4Save addObjectsFromArray:_arrayOfCells];
//                          [arrayData4Save addObjectsFromArray:_matrixOfCells];
//                          XMLmanager_class* xmlManager = [[XMLmanager_class alloc]init];
//                          [xmlManager createBoardLocalXMLfilewithComment:@"Board" withData:arrayData4Save andwithBoardName:newBoard.brdFileName];//] stringByTrimmingCharactersInSet:
//                          // [NSCharacterSet whitespaceCharacterSet]]];
//                          
//                          // update file boards_list.xml
//                          XMLmanager_class* xmlCreateBoardList = [[XMLmanager_class alloc]init];
//                          [xmlCreateBoardList createBoardsList_localXMLfile:@"boards_list.xml" andwith:_appDelegate.arrayOfBoards];
//                          
//                          
//                      }
//                      
//                  }
//                            cancelButtonTitle:@"Overwrite"
//                            otherButtonTitles:@"Cancel", nil];
//             }
//             else{
//                 
//                 // save the board file containing the actuall data - board info + cells info
//                 NSMutableArray* arrayData4Save  = [[NSMutableArray alloc]initWithObjects:boardSelectedbyUser, nil];
//                 [arrayData4Save addObjectsFromArray:_matrixOfCells];
//                 XMLmanager_class* xmlManager = [[XMLmanager_class alloc]init];
//                 [xmlManager createBoardLocalXMLfilewithComment:@"Board" withData:arrayData4Save andwithBoardName:newBoard.brdFileName];
//                 
//                 //add the new board to arrayOfBoards array
//                 [_appDelegate.arrayOfBoards addObject:newBoard];
//                 
//                 // update file boards_list.xml
//                 XMLmanager_class* xmlCreateBoardList = [[XMLmanager_class alloc]init];
//                 [xmlCreateBoardList createBoardsList_localXMLfile:@"boards_list.xml" andwith:_appDelegate.arrayOfBoards];
//                 
//             }
//         }
//     }
//               cancelButtonTitle:@"Save"
//               otherButtonTitles:@"Cancel", nil];
//    
//    
//    
//    
//    
//    
//}

//-(CGSize)calcWorkScreenSize
//{
//    CGRect screenBound = [[UIScreen mainScreen] bounds];
//    //    CGRect screenMain = [UIScreen mainScreen].applicationFrame;
//    //    CGRect navBar = self.navigationController.navigationBar.frame;
//    //CGRect screenSize = screenMain; //screenBound.size;
//    CGFloat screenWidth = CGRectGetWidth(screenBound);//   screenSize.width;
//    CGFloat screenHeight = CGRectGetHeight(screenBound);//  screenSize.height;
//    CGSize screenSize = CGSizeMake(screenWidth, screenHeight);
//    return screenSize;
//}

//-(CGSize)calcCellSize
//{
//    NSLog(@"calcCellSize");
//    
//    CGSize screenSize = [self calcWorkScreenSize];
//    
//    [_colEditBoard setFrame:CGRectMake(1, 1, screenSize.width, screenSize.height)];
//    
//    float WW = _colEditBoard.frame.size.width;
//    float HH = _colEditBoard.frame.size.height;
//    
//    float cellWW = WW/NUMOFCELLSINCOL;
//    float cellHH = HH/NUMOFCELLSINROW;
//    
//    //todo - check for each device - checked for ipad air 2 -> OK
//    cellHH=cellHH-5.5f;
//    return CGSizeMake(cellWW, cellHH);
//    
//}

-(void)initBoard2
{
    //init the current display with the basic grid - 12x12 cells
    
    int cntCells=0;
    
    for (int i=0; i<NUMOFCELLSINCOL; i++){
        NSMutableArray* arrayRow = [[NSMutableArray alloc]init];
       
        for(int j=0;j<NUMOFCELLSINROW;j++)
        {
            //[arrayZ insertObject:@"" atIndex:j];
            NSString* str = [NSString stringWithFormat:@"%d",cntCells];
            Cell_class* cell = [[Cell_class alloc]init];
            cell.cellText=str;
            cell.cellBoardID = boardSelectedbyUser.brdID;
            cell.cellBackgroundColor = [UIColor clearColor];
            cell.cellBorderColor = [UIColor darkGrayColor];
            cell.cellImageID=@"-1";//[NSNumber numberWithInt:-1];
            cell.size = CGSizeMake(1,1);
            cell.cellIndex = cntCells;
            // cell.tag=[NSNumber numberWithInt:i];
            cell.coordinates = CGPointMake(i,j);
            [cell.collection addObject:[NSValue valueWithCGPoint:cell.coordinates]];
            cell.cellBoardLink = 0;
            cell.cellCreatedBy = @"creator";
            cell.cellCreatedDate = [NSDate date];
            cell.cellMP3Path = @"";
            cell.cellSoundFilename = @"";
            cell.cellSoundPath = @"";
            cell.cellVIDEOPath = @"";
            cell.cellWEBPath = @"";
            cell.cellLastUpdatedBy = @"creator";
            cell.cellLastUpdateDate = [NSDate date];
            
            [arrayRow addObject:cell];
            cntCells++;

        }
        [_matrixOfCells addObject:arrayRow];
    }
    



    
    
    [self setTags4Array:_arrayOfCells withTotalRows:NUMOFCELLSINROW withTotalCols:NUMOFCELLSINCOL withStartCell:nil];
    NSLog(@"initBoard - arrayofcells = %lu",(unsigned long)_arrayOfCells.count);
    
}


-(void)initBoard
{
    //init the current display with the basic grid - 12x12 cells
    
    int cntCols = 0;
    int cntRows=0;
    float xx=0;
    float yy=0;
    for (int i=0; i<144; i++)
    {
        
        NSString* str = [NSString stringWithFormat:@"%d",i];
        Cell_class* cell = [[Cell_class alloc]init];
        cell.cellText=str;
        cell.cellBackgroundColor = [UIColor clearColor];
        cell.cellBorderColor = [UIColor darkGrayColor];
        cell.cellImageID=@"-1";//[NSNumber numberWithInt:-1];
        CGSize cellSize;
        cellSize =CGSizeMake(1,1);
        cell.size = cellSize;
        // cell.tag=[NSNumber numberWithInt:i];
        cell.coordinates = CGPointMake(xx,yy);
        
        NSMutableArray* arrayX = [[NSMutableArray alloc]init];
        arrayX = [_matrixOfCells objectAtIndex:cntRows];
        [arrayX replaceObjectAtIndex:cntCols withObject:cell];
        
        if ((i+1)%NUMOFCELLSINROW==0) {
            xx++;
            yy=0;
            cntRows++;
            cntCols=0;
        }
        else
        {
            yy++;
            cntCols++;
        }
        cell.cellIndex=i;
        [_arrayOfCells addObject:cell];
        
    }
    
    
    
    
    [self setTags4Array:_arrayOfCells withTotalRows:NUMOFCELLSINROW withTotalCols:NUMOFCELLSINCOL withStartCell:nil];
    NSLog(@"initBoard - arrayofcells = %lu",(unsigned long)_arrayOfCells.count);
    
}


-(void)mergeCells_auto_withNumOfRows:(int)iRows andwithNumOfCols:(int)iCols
{
    // important : this merge is based on existing basic grid of 12x12 cells
    
    NSLog(@"mergeCells_auto_withNumOfRows");
    
    
    int cntTotCells=1;
    
    
    int numOfCellsInRow_User = NUMOFCELLSINROW/iCols;
    int numOfCellsInCol_User = NUMOFCELLSINCOL/iRows;
  
    cntTotCells = numOfCellsInRow_User;
    
    for (int i=0; i<_matrixOfCells.count; i++) {
        
        NSMutableArray* arrayRow = [_matrixOfCells objectAtIndex:i];
        
        for (int j=0; j<arrayRow.count; j++) {
            
            Cell_class* cellZ = [arrayRow objectAtIndex:j];
            cellZ.size = CGSizeMake(numOfCellsInRow_User, numOfCellsInCol_User);
            cellZ.mark4show = YES;
            [_arrayOfCells addObject:cellZ];
           
            [cellZ.collection removeAllObjects];
            for (int k=i; k<i+numOfCellsInCol_User; k++) {
                
                for (int l=j;l<j+numOfCellsInRow_User; l++) {
                    
                    CGPoint newPoint = CGPointMake(k, l);
                    [cellZ.collection addObject:[NSValue valueWithCGPoint:newPoint]];
                    
                }
            }
            j=j+numOfCellsInRow_User-1;
        }
        i=i+numOfCellsInCol_User-1;
    }

    [_globalFuncs PrintOut_array:_arrayOfCells showXY:NO showMARK:YES];
    [_globalFuncs PrintOut_matrix:_matrixOfCells showIndex:NO showMark:YES];
    
    
    
}


//-(void)mergeCellsAutowithRequestedCols:(int)iCols andwithRequestedRows:(int)iRows
//{
//    // important : this merge is based on existing basic grid of 12x12 cells
//    
//    NSLog(@"mergeCellsAutowithRequestedCols");
//    
//    
//    int cntTotCells=1;
//    
//    
//    int numOfCellsInRow_User = NUMOFCELLSINROW/iCols;
//    int numOfCellsInCol_User = NUMOFCELLSINCOL/iRows;
//    int newIndex=0;
//    cntTotCells = numOfCellsInRow_User;
//    BOOL newIndexSET=NO;
//    int currIndex=0;
//    Cell_class* currMergedCell = [[Cell_class alloc]init];
//    float XX=0;
//    float YY=0;
//    
//    NSLog(@"mergeCellsByMenuwith Cols:%d , Rows:%d",iCols,iRows);
//    
//    for(int i=0;i<iRows;i++)
//    {
//        if (i>0) {
//            cntTotCells = numOfCellsInRow_User;
//            newIndex++;
//            currIndex=newIndex;
//            newIndexSET=TRUE;
//            XX++;
//            YY=0;
//        }
//        NSLog(@"1 - XX=%f",XX);
//        for (int j=0; j<iCols; j++) {
//            
//            if(j>0)
//            {
//                YY++;
//                cntTotCells=cntTotCells+numOfCellsInRow_User;
//                if (!newIndexSET)
//                {
//                    if (i==0) {
//                        newIndex=j;
//                        currIndex=newIndex;
//                    }
//                    else {
//                        //newIndex=currIndex+1;
//                        newIndex++;
//                        currIndex=newIndex;
//                    }
//                    
//                    newIndexSET=YES;
//                }
//            }
//            NSLog(@"2 - XX=%f",XX);
//            for (int z=0; z<numOfCellsInCol_User; z++) {
//                if (z>0){
//                    currIndex=currIndex+NUMOFCELLSINROW-cntTotCells;
//                }
//                
//                for (int x=0; x<numOfCellsInRow_User; x++) {
//                    
//                    Cell_class* theCell = [_arrayOfCells objectAtIndex:currIndex];
//                    [_arrayOfSelCells addObject:theCell];
//                    currIndex++;
//                }
//            }
//            currMergedCell= [self merge_cellsfromArray:_arrayOfSelCells];
//           // currMergedCell.coordinates = CGPointMake(XX, YY);
//           // NSLog(@"currMergedCell.cellIndex=%d,xx=%f,yy=%f",currMergedCell.cellIndex,XX,YY);
//             NSLog(@"3 - XX=%f",XX);
//            newIndexSET=NO;
//        }
//        newIndexSET=NO;
//        
//    }
//    
//   
//}

-(void)firstTime_loadBoardCell:(EditBoardCell_collectionviewcell*)currCell withClassCell:(Cell_class*)theCell
{
    
    Images_class* currImage = [[Images_class alloc]initWithImageIndex:theCell.cellImageID];
    if (currImage != nil) {
        UIImage* imgFromLocal = [UIImage imageWithContentsOfFile:[currImage.imgPath stringByAppendingPathComponent: currImage.imgFileName]];
        currCell.imgSymbolCell.image =  imgFromLocal;
    }
    else
        //   currCell.imgSymbolCell.image=nil;
        
        NSLog(@"Update cell with semel:%@ , text:%@",currCell.imgSymbolCell,theCell.cellText);
    
    //todo - check status of textontop and update accordelly
    if (currCell.lblTextBottom.hidden == FALSE) {
        currCell.lblTextBottom.text=theCell.cellText;

    }
    if (currCell.lblTextTop.hidden == FALSE) {
        currCell.lblTextTop.text=theCell.cellText;

    }
    
    // NSLog(@"CollectionView has been updated with semel:%@ , text:%@",currCell.imgSemel,currCell.lblText);
}

-(void)rearange_objectsInCell:(EditBoardCell_collectionviewcell*)currCell
{
    
    int distFromTop =5;
    int distFromBottom = 5;
    int distYLbl2Symbol = 1;
    int lblHeight = 30;
    
    CGSize cellSize = CGSizeMake(currCell.frame.size.width,currCell.frame.size.height);
    
    //presumming that lblTestTop and lblTextBottom have the same size
    CGSize lblSize = CGSizeMake(cellSize.width-20, lblHeight);//currCell.lblTextTop.frame.size.height);
    CGPoint lblPointBottom,lblPointTop;
    
    if (currCell.imgSymbolCell.image == nil)
    {
        lblPointBottom = CGPointMake((cellSize.width-lblSize.width)/2, (cellSize.height-lblSize.height)/2);
        lblPointTop = lblPointBottom;
    }
        else
    {
        lblPointBottom = CGPointMake(5, (cellSize.height-lblSize.height-distFromBottom));
        lblPointTop = CGPointMake(5, distFromTop);
    }
    
    currCell.lblTextTop.frame = CGRectMake(lblPointTop.x, lblPointTop.y, lblSize.width, lblSize.height);
    currCell.lblTextBottom.frame = CGRectMake(lblPointBottom.x, lblPointBottom.y, lblSize.width, lblSize.height);
    
    //imgSize is set for EDIT MODE
    //todo - for RUN MODE it has to changed
    CGSize imgSymbolSize = CGSizeMake((cellSize.width-10), cellSize.height-lblSize.height*2-distFromBottom-distFromTop-distYLbl2Symbol*2);

    CGPoint imgSymbolPoint = CGPointMake(5, lblPointTop.y + lblSize.height+distYLbl2Symbol);
    
    currCell.imgSymbolCell.frame = CGRectMake(imgSymbolPoint.x, imgSymbolPoint.y, imgSymbolSize.width, imgSymbolSize.height);
    currCell.imgSymbolCell.contentMode = UIViewContentModeScaleAspectFit;
    
    currCell.btnEditCell.frame = CGRectMake(10, 10, currCell.btnEditCell.frame.size.width, currCell.btnEditCell.frame.size.height);

    //    //currCell.btnPlayMSG.frame = CGRectMake(
    //                    (cellSize.width - currCell.btnPlayMSG.frame.size.width-10),
    //                    (cellSize.height - currCell.btnPlayMSG.frame.size.height-10),
    //                    currCell.btnPlayMSG.frame.size.width,
    //                    currCell.btnPlayMSG.frame.size.height);
    
    currCell.btnPlayMSG.frame = CGRectMake(
                                           (currCell.btnEditCell.frame.origin.x+currCell.btnEditCell.frame.size.width+5),10,
                                           currCell.btnPlayMSG.frame.size.width,
                                           currCell.btnPlayMSG.frame.size.height);
    
    
    
}

-(void)splitCell2:(Cell_class*)selCell4Split
{
    
    //this algoritm is build for custom split that user chooses
    //-----------------------------------------------------------------------
    
    NSLog(@"splitCell2");
    
  //  [_globalFuncs PrintOut_matrix:_matrixOfCells showIndex:NO showMark:YES];

    NSLog(@"selCell4Split.collection is %@",selCell4Split.collection);
    
    
    //create an UNDO point
    _array4UNDO = [[NSMutableArray alloc]initWithArray:_arrayOfCells copyItems:TRUE];
    _matrix4UNDO = [[NSMutableArray alloc]initWithArray:_matrixOfCells copyItems:TRUE];
    
    
    [self splitCell_sortCollectionOfXY:selCell4Split.collection];
    
    selCell4Split.size = CGSizeMake(1, 1);
    selCell4Split.mark = NO;
    
    NSLog(@"After sorting the .collection");
    [_globalFuncs PrintOut_matrix:_matrixOfCells showIndex:NO showMark:YES];
    
    
    // begin creating the new _arrayOfCells
    NSMutableArray* tmpArrayOfCells = [[NSMutableArray alloc]init];
    NSLog(@"tmpArrayOfCells.count = %lu",(unsigned long)tmpArrayOfCells.count);
    NSLog(@"_arrayOfCells.count = %lu",(unsigned long)_arrayOfCells.count);

    NSMutableArray* arrayOfMarkCells = [[NSMutableArray alloc]init];
    
    for (int i=0; i<_matrixOfCells.count; i++) {
        NSMutableArray* arrayRow = [_matrixOfCells objectAtIndex:i];
        
        for (int j=0; j<arrayRow.count; j++) {
            Cell_class* cellZ = [arrayRow objectAtIndex:j];
            
            if (cellZ.mark) {
                //search if the cell allready added
                BOOL flgCellExists=NO;
                for (NSValue* valueX in arrayOfMarkCells){
                    
                    if (valueX.CGPointValue.x == cellZ.coordinates.x && valueX.CGPointValue.y == cellZ.coordinates.y) {
                        flgCellExists = YES;
                        break;
                    }
                }
                if (flgCellExists) {
                    flgCellExists=NO;
                
                }
                else{
                    for (NSValue* valueX in cellZ.collection){
                        [arrayOfMarkCells addObject:valueX];
                    }
                    
                    [tmpArrayOfCells addObject:cellZ];
                    cellZ.mark4show = YES;
                    NSLog(@"cell %d YES added",cellZ.cellIndex);
                }
                
            }
            else{
                cellZ.mark = YES;
                cellZ.mark4show = YES;
                [tmpArrayOfCells addObject:cellZ];
                
            }
//            [self splitCell_sortCollectionOfXY:arrayOfMarkCells];
            
        }
    }
    
    
//    for (Cell_class* cellX in tmpArrayOfCells){
//        
//        NSLog(@"cellX-index=%d, x,y=%f,%f",cellX.cellIndex,cellX.coordinates.x,cellX.coordinates.y);
//    }
    NSLog(@"tmpArrayOfCells.count = %lu",(unsigned long)tmpArrayOfCells.count);
    NSLog(@"_arrayOfCells.count = %lu",(unsigned long)_arrayOfCells.count);

    
    [selCell4Split.collection removeAllObjects];
    selCell4Split.size = CGSizeMake(1, 1);
    CGPoint pointX = CGPointMake(selCell4Split.coordinates.x, selCell4Split.coordinates.y);
    NSValue* valueX  = [NSValue valueWithCGPoint:pointX];
    [selCell4Split.collection addObject:valueX];
    selCell4Split.mark = YES;
    selCell4Split.mark4show=YES;
    
    [_arrayOfCells removeAllObjects];
    _arrayOfCells = tmpArrayOfCells;
    

    
    //[self updatematrix_afterSplit_withCell:selCell4Split];
    [_colEditBoard reloadData];
    
  
    
    
}

-(void)splitCell_sortCollectionOfXY:(NSMutableArray*)selArray4Sort
{
    
    //sort points in .collection array
    
    NSMutableArray* tmpMainArray = [[NSMutableArray alloc]init];
    
    
    // sort the X in each point. make 12 passes. for each X create a different array and add it a the same index as the X to tmpMainAray
    for (int i=0; i<NUMOFCELLSINCOL; i++) {
        
        NSMutableArray* tmpArray = [[NSMutableArray alloc]init];
        
        for (NSValue* valueX in selArray4Sort) {
            
            CGPoint point = CGPointMake(valueX.CGPointValue.x, valueX.CGPointValue.y);
            
            if (point.x == i) {
                [tmpArray addObject:[NSValue valueWithCGPoint:point]];
            }
            
        }
        
        [tmpMainArray addObject:tmpArray];
        
    }
    // sort the Y in each tmpArray. make 12 passes
    
    for (int i=0; i<tmpMainArray.count; i++) {
        
        NSMutableArray* tmpArray = [tmpMainArray objectAtIndex:i];
        
        for (int j=0; j<NUMOFCELLSINCOL; j++) {
            int prevPoint = -1;
            
            for (int z=0;z<tmpArray.count;z++) {
                
                NSValue* valueX = [tmpArray objectAtIndex:z];
                CGPoint point = CGPointMake(valueX.CGPointValue.x, valueX.CGPointValue.y);
                
                if (prevPoint == -1) {
                    //first loop
                    prevPoint = point.y;
                }
                else{
                    if (prevPoint > point.y) {
                        
                        NSValue* prevValueX = [tmpArray objectAtIndex:z-1];
                        [tmpArray replaceObjectAtIndex:z-1 withObject:valueX];
                        [tmpArray replaceObjectAtIndex:z withObject:prevValueX];
                    }
                    
                    
                }
                
            }
        }
    }

    
    // empty and load again .collection array
    
    
    [selArray4Sort removeAllObjects];
    for (int i=0; i<tmpMainArray.count; i++) {
        
        NSArray* arrayX = [tmpMainArray objectAtIndex:i];
        for (int j=0; j<arrayX.count; j++) {
            
            NSValue* valueX = [arrayX objectAtIndex:j];
            CGPoint pointX = CGPointMake(valueX.CGPointValue.x, valueX.CGPointValue.y);
            
            Cell_class* cellX = [[_matrixOfCells objectAtIndex:pointX.x] objectAtIndex:pointX.y];
            cellX.mark = NO;
            
            [selArray4Sort addObject:[arrayX objectAtIndex:j]];
            
        }
    }

    
}

-(void)splitCell:(Cell_class*)selCell4Split
{
    
    NSMutableArray* tempArray = [[NSMutableArray alloc]init] ;//]WithArray:_arrayOfCells];
    int oldIndex = 0;
  //  int orgIndex = selCell4Split.cellIndex;
    BOOL flgFound_selCell=NO;
    
    //cellEmpty.cellIndex=-1;
    
    int ww = selCell4Split.coordinates.y+selCell4Split.size.width;
    for (int q=0; q<_arrayOfCells.count; q++) {
        
        Cell_class* cellZ = [_arrayOfCells objectAtIndex:q];
        oldIndex = q;
        
        
        
        if (cellZ.cellIndex == selCell4Split.cellIndex) {
            [tempArray addObject:cellZ];
            NSLog(@"cell %d added",cellZ.cellIndex);
            flgFound_selCell=YES;
            for (int x=1; x<selCell4Split.size.width; x++) {
                Cell_class* cellEmpty = [[Cell_class alloc]init];
                cellEmpty.size = CGSizeMake(1, 1);
                cellEmpty.cellIndex = -1;
               // change - 25-09-2015
                // cellEmpty.coordinates = CGPointMake(selCell4Split.coordinates.x, selCell4Split.coordinates.y+x);
                //--------------------
                cellEmpty.cellText = [NSString stringWithFormat:@"%d",cellEmpty.cellIndex];
                [tempArray addObject:cellEmpty];
                NSLog(@"cell %d added",cellEmpty.cellIndex);
                
                
                
            }
            
        }
        else{
            NSLog(@"cellZ.index=%d",cellZ.cellIndex);
            if (flgFound_selCell) {
                if (ww == NUMOFCELLSINROW) {
                    // [tempArray addObject:cellZ];
                    break;
                }
                else
                {
                    ww = ww + cellZ.size.width;
                    [tempArray addObject:cellZ];
                    NSLog(@"cell %d added",cellZ.cellIndex);
                }
            }
            else
            {
                [tempArray addObject:cellZ];
                NSLog(@"cell %d added",cellZ.cellIndex);
            }
            
        }
        
    }
    
    if (selCell4Split.size.width==NUMOFCELLSINROW && selCell4Split.size.height==NUMOFCELLSINCOL) {
        for (int x=1; x<selCell4Split.size.height; x++) {
            for (int y=0; y<selCell4Split.size.width; y++) {
                Cell_class* cellEmpty = [[Cell_class alloc]init];
                cellEmpty.size = CGSizeMake(1, 1);
                cellEmpty.cellIndex = -1;
                cellEmpty.cellText = [NSString stringWithFormat:@"%d",cellEmpty.cellIndex];
                [tempArray addObject:cellEmpty];
                NSLog(@"cell %d added",cellEmpty.cellIndex);
                
            }
            
        }
        
    }
    else
    {
        for (int x=1; x<selCell4Split.size.height; x++) {
            for (int y=0; y<selCell4Split.size.width; y++) {
                Cell_class* cellEmpty = [[Cell_class alloc]init];
                cellEmpty.size = CGSizeMake(1, 1);
                cellEmpty.cellIndex = -1;
               // change - 25-09-2015
                //cellEmpty.coordinates = CGPointMake(selCell4Split.coordinates.x+x, selCell4Split.coordinates.y+y);
                //---------------------
                cellEmpty.cellText = [NSString stringWithFormat:@"%d",cellEmpty.cellIndex];
                [tempArray addObject:cellEmpty];
                NSLog(@"cell %d added",cellEmpty.cellIndex);
                
            }
            
        }
        
        if (oldIndex == _arrayOfCells.count-1) {
            oldIndex++;
        }
        for (int i=oldIndex; i<_arrayOfCells.count; i++) {
            Cell_class* cellZ = [_arrayOfCells objectAtIndex:i];
            if (cellZ.cellIndex == 15) {
//                NSLog(@"ERROR cellZ.index=%d",cellZ.cellIndex);
               
            }
            [tempArray addObject:cellZ];
            NSLog(@"cell %d added",cellZ.cellIndex);
        }
        
        
    }
    [_globalFuncs PrintOut_matrix:_matrixOfCells showIndex:NO showMark:YES];
    
    
    selCell4Split.size = CGSizeMake(1, 1);
    [_arrayOfCells removeAllObjects];
    _arrayOfCells = tempArray;
  
    [self updatematrix_afterSplit_withCell:selCell4Split];
    [_colEditBoard reloadData];
    
    
}

//-(NSArray*)splitCells2Basic:(Cell_class*)cellX
//{
//    
//    //this algoritm is build for custom split that user chooses
//    //-----------------------------------------------------------------------
//    
//    NSLog(@"splitCells2Basic");
//    
//    //create an UNDO point
//    [_array4UNDO removeAllObjects];
//    _array4UNDO = [[NSMutableArray alloc]initWithArray:_arrayOfCells copyItems:TRUE];
//    
//    
//    
//    
//    
//    NSMutableArray* array4return = [[NSMutableArray alloc]init];
//    
//    int totWidth = 0;
//    int totHeight = 0;
//    int prevIndex = -1;
//    
//    
//    NSMutableArray* arrayTable4ConvertIndx = [[NSMutableArray alloc]init];
//    
//    if (cellX.size.width > 1 || cellX.size.height>1) {
//        totWidth = cellX.size.width;
//        totHeight = cellX.size.height;
//    }
//    
//    //find cellX in matrix and split the same row
//    int indx = cellX.cellIndex+1;
//    Cell_class* cellZ = [[Cell_class alloc]init];
//    CGPoint cellXPoint = CGPointMake(cellX.coordinates.x, cellX.coordinates.y);
//    int xx = cellXPoint.x;
//    int yy = cellXPoint.y+1;
//    int ww = cellX.size.width;
//    while (ww > 1) {
//        cellZ = [[_matrixOfCells objectAtIndex:xx] objectAtIndex:yy];
//        cellZ.cellIndex = indx;
//        if (indx > _arrayOfCells.count-1)
//            [_arrayOfCells addObject:cellZ];
//        else
//            [_arrayOfCells insertObject:cellZ atIndex:cellZ.cellIndex];
//        
//        prevIndex = cellZ.cellIndex;
//        ww--;
//        yy++;
//        indx++;
//        
//    }
//    
//    //update the rest of the indexes's cells in the same row
//    for (int y=yy; y<NUMOFCELLSINROW; y++) {
//        cellZ = [[_matrixOfCells objectAtIndex:xx] objectAtIndex:y];
//        if (prevIndex!=cellZ.cellIndex) {
//            [self updateMatrixIndexes4Cell:cellZ withIndex:indx];
//            prevIndex = cellZ.cellIndex;
//            indx++;
//        }
//    }
//    // complete the rest of the split of cellX
//    int hh = cellX.size.height;
//    while (hh>1) {
//        xx++;
//        yy=cellX.coordinates.y;
//        for (int i=0; i<cellX.size.width; i++) {
//            cellZ = [[_matrixOfCells objectAtIndex:xx] objectAtIndex:yy];
//            cellZ.cellIndex = indx;
//            if (indx > _arrayOfCells.count-1)
//                [_arrayOfCells addObject:cellZ];
//            else
//                [_arrayOfCells insertObject:cellZ atIndex:cellZ.cellIndex];
//            
//            yy++;
//            indx++;
//            
//        }
//        hh--;
//    }
//    
//    
//    
//    
//    //update the rest of the matrix
//    xx++;
//    prevIndex=-1;
//    int currIndex=0;
//    BOOL flgExit=NO;
//    Cell_class* theCell = [[Cell_class alloc]init];
//    
//    for (int w=indx; w<_arrayOfCells.count; w++) {
//        theCell = [_arrayOfCells objectAtIndex:w];
//        // find theCell in matrix array
//        for (int i=xx; i<[_matrixOfCells count]; i++) {
//            if (flgExit)
//                break;
//            
//            NSMutableArray* arrayRow = [[NSMutableArray alloc]initWithArray:[_matrixOfCells objectAtIndex:i]];
//            for (int j=0; j<[arrayRow count]; j++) {
//                Cell_class* cellZ = [arrayRow objectAtIndex:j];
//                if (theCell.coordinates.x == cellZ.coordinates.x && theCell.coordinates.y == cellZ.coordinates.y) {
//                    currIndex = theCell.cellIndex;
//                    flgExit=YES;
//                    break;
//                }
//            }
//        }
//        //
//        // if theCell exists in matrix, find all the same indexes and change them
//        if(currIndex != -1)
//        {
//            flgExit = NO;
//            for (int i=theCell.coordinates.x; i<[_matrixOfCells count]; i++) {
//                NSMutableArray* arrayRow = [[NSMutableArray alloc]initWithArray:[_matrixOfCells objectAtIndex:i]];
//                for (int j=theCell.coordinates.y; j<[arrayRow count]; j++) {
//                    Cell_class* cellZ = [arrayRow objectAtIndex:j];
//                    if (cellZ.cellIndex == currIndex) {
//                        cellZ.cellIndex = w;
//                        cellZ.coordinates = CGPointMake(i,j);
//                        //  NSLog(@"split cells ------- current cell(%d,%d) index-%d",i,j,cellZ.cellIndex);
//                        
//                    }
//                }
//            }
//        }
//        // NSLog(@"split cells - all matrix ___________");
//        
//        
//        
//    }
//    
//    cellX.size = CGSizeMake(1, 1);
//    
//    
//    
//    
//    // [self refresh_arrayOfCellswith:CGSizeMake(0,0)];//includes canceling the selection
//    
//    for (int i=0; i<_arrayOfCells.count; i++) {
//        theCell = [_arrayOfCells objectAtIndex:i];
//        theCell.cellIndex=i;
//        theCell.cellText=[NSString stringWithFormat:@"%d",theCell.cellIndex];
//        theCell.selected=NO;
//        cellZ.cellIndex=i;
//        //theCell.cellBackgroundColor = [UIColor clearColor];
//        //theCell.cellBorderColor = [UIColor darkGrayColor];
//        //theCell.cellImageID=@"-1";//[NSNumber numberWithInt:-1];
//    }
//   // [self updatematrixby_arrayofcells];
//    
//    [self setTags4Array:_arrayOfCells withTotalRows:1 withTotalCols:1 withStartCell:theCell];
//    
//    //refresh collectionview
//    [_colEditBoard reloadData];
//    
//    //for testing
//    NSLog(@"finish splitting");
//    [_globalFuncs PrintOut_matrix:_matrixOfCells];
//    
//    return array4return;
//    
//}

//-(void)split_cellswithCells:(EditBoardCell_collectionviewcell*)cell
//{
//    //the verification if the cell is not at min size has been done before showing the menu
//
//    int WW=0;
//    int HH=0;
//    int numOfCellsOnRow=0;
//    int numOfCellsOnCol=0;
//    Cell_class* currCell = _arrayOfSelCells[0];
//    if (currCell.size.width > 1) {
//        if ((int)currCell.size.width % 2==0)
//        {
//            WW=(int)currCell.size.width/2;
//            numOfCellsOnCol = (int)currCell.size.width/WW;
//        }
//        else
//        {
//            WW=(int)currCell.size.width / (int)currCell.size.width;
//            numOfCellsOnCol = (int)currCell.size.width;
//        }
//    }
//
//    if(currCell.size.height >1){
//        if ((int)currCell.size.height % 2==0)
//        {
//            HH=(int)currCell.size.height/2;
//            numOfCellsOnRow = (int)currCell.size.height/HH;
//        }
//        else
//        {
//            HH=(int)currCell.size.height / (int)currCell.size.height;
//            numOfCellsOnRow = (int)currCell.size.height;
//        }
//
//    }
//
//    Cell_class* theCell=currCell;
//
//
//    //begin the split
//    int totCols = numOfCellsOnCol;
//    int newIndex = theCell.cellIndex+1;
//
//    for (int rows=0; rows<numOfCellsOnRow; rows++) {
//        if (rows>0) {
//
//
//
//            int BasicCellsInEachColCell = numOfCellsOnRow ;//       NUMOFCELLSINROW/Cols;
//            if (newIndex == theCell.cellIndex+BasicCellsInEachColCell) {
//
//                int XX=0;
//
//
//                if (theCell.coordinates.x == 0)
//                    XX=0;
//                else
//                    XX =theCell.coordinates.x/BasicCellsInEachColCell;
//
//
//                newIndex = newIndex+(Cols-(XX+1));
//            }
//
//
//        }
//        if (newIndex == theCell.cellIndex+1)
//            totCols=numOfCellsOnCol-1;
//        else
//            totCols = numOfCellsOnCol;
//
//        for (int cols=0; cols<totCols; cols++)
//        {
//            Cell_class* newCell = [[Cell_class alloc]init];
//            newCell.cellText = [NSString stringWithFormat:@"%d",newIndex+cols];
//            CGPoint newCellPoint;
//            newCellPoint.x=theCell.coordinates.x+cols;
//            newCellPoint.y=theCell.coordinates.y+rows;
//            newCell.coordinates = newCellPoint;
//            CGSize newCellSize = CGSizeMake(WW, HH);
//            newCell.size=newCellSize;
//            newCell.cellIndex=newIndex;
//            [_arrayOfCells insertObject:newCell atIndex:newIndex];
////             [self refresh_arrayOfCells];
////            for (int x=0;x<_arrayOfCells.count;x++)
////            {
////                Cell_class* cellX = [[Cell_class alloc]init];
////                cellX = _arrayOfCells[x];
////                if (cellX.cellIndex == newIndex) {
////                     NSLog(@"NEWCELL at index %d",newIndex);
////                }
////                else
////                    NSLog(@"cell at index %d",cellX.cellIndex);
////
////            }
//            newIndex++;
//
//        }
//    }
//
//    theCell.size= CGSizeMake(WW, HH);
//
//    //clean up the array of selected cells
//    [_arrayOfSelCells removeAllObjects];
//
//    [self refresh_arrayOfCellswith:CGSizeMake(0,0)];//includes canceling the selection
//
//
//    //refresh collectionview
//    [_colEditBoard reloadData];
//
//
//
//
//}


//-(BOOL)checkCellsAttached:(Cell_class*)cell1 andwith:(Cell_class*)cell2
//{
//    int WW1 = cell1.size.width;
//    int HH1 = cell1.size.height;
//    int XX1 = cell1.coordinates.x;
//    int YY1 = cell1.coordinates.y;
//
//    int WW2 = cell2.size.width;
//    int HH2 = cell2.size.height;
//    int XX2 = cell2.coordinates.x;
//    int YY2 = cell2.coordinates.y;
//
//    BOOL bAttached=false;
//
//    // the cells are have the same Y from top
//    if (YY1 == YY2) {
//        if (HH1 == HH2) { // check if they have the same height
//            if ((XX2 == (XX1+WW1)) || (XX1 == (XX2+WW2))) { // check if they are one near the other
//                bAttached=TRUE;
//            }
//        }
//    }
//
//    if (XX1 == XX2) {
//        if (WW1 == WW2) {
//            if ((YY2 == (YY1+HH1)) || (YY1 == (YY2+HH2))) {
//                bAttached=TRUE;
//            }
//        }
//    }
//
//    return bAttached;
//
//}

//-(void)mergeCells_custom:(Cell_class*)cellA andwith:(Cell_class*)cellB
//{
//
//   // algorithm build ONLY for cells choosed by user for merging
//    // 07-2015 - the merging is only for 2 cells at a time
//   //------------------------------------------------------------
//
//
//    if ([self checkCellsAttached:cellA andwith:cellB]) {
//
//            // needs to set the size according the selection
//            CGSize cellSize = [self calc2CellsMergeSize:cellA andwith:cellB];
//            cellA.size=cellSize;
//
//            // update the big array. remove the cells that have been merged
//            [_arrayOfCells removeObject:cellB];
//
//            [self refresh_arrayOfCellswith:CGSizeMake(0,0)];  //includes canceling the selection
//
//            //refresh collectionview
//            [_colEditBoard reloadData];
//
//
//
//    }
//    else
//    {
//
//        UIAlertView* msgbox = [[UIAlertView alloc]initWithTitle:@"Merging Cells" message:@"The choosen cells have to be close one the other.Please select again" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [msgbox show];
//
//        [self refresh_arrayOfCellswith:CGSizeMake(0,0)];  //includes canceling the selection
//
//        //refresh collectionview
//        [_colEditBoard reloadData];
//
//    }
//
//
//}

-(void)sortCells4MergeinArray:(NSMutableArray*)array4sort
{
    
    //sorting 0to9 _arrayOfSelCells
    for (int i=1;i<array4sort.count;i++)
    {
        
        if ([array4sort[i] cellIndex]< [array4sort[i-1] cellIndex])
        {
            [array4sort switch_itemsbetweenItemAtIndex:i andItemAtIndex:i-1];
        }
    }
    
    for (int i=0;i<array4sort.count;i++)
    {
        Cell_class* currCell = array4sort[i];
        NSLog(@"After Sorting - cellIndex=%d,cellWidth=%f,cellHeight=%f,cellX=%f, cellY=%f",currCell.cellIndex,currCell.size.width,currCell.size.height,currCell.coordinates.x,currCell.coordinates.y);
        //        NSLog(@"----------------cellWidth=%f, cellHeight=%f",currCell.size.width,currCell.size.height);
        //        NSLog(@"----------------cellX=%f, cellY=%f",currCell.coordinates.x,currCell.coordinates.y);
        NSLog(@"------------------------------");
    }
    
}


//-(void)mergeCells_newtry
//{
//    // pass through all the _arrayOfSelCells and split them to basic
//
//    NSLog(@"mergeCells_newtry");
//
//    NSMutableArray* arraySelCells_tmp = [[NSMutableArray alloc]init];
//
//    NSLog(@" _arrayOfSelCells.count = %lu",(unsigned long)_arrayOfSelCells.count);
//
//    [self sortCells4MergeinArray:arraySelCells_tmp];
//
//
//    for (Cell_class* cellX in _arrayOfSelCells)
//    {
//       [arraySelCells_tmp addObjectsFromArray:[self splitCells2Basic:cellX]];
//    }
//
//
//    if (_arrayOfSelCells.count>0)
//    {
//
//        //update collection view
//        [self refresh_arrayOfCells_incXY];
//        [_colEditBoard reloadData];
//
//
//        //sorting 0to9 arraySelCells_tmp
//
//        for (int j=0; j<arraySelCells_tmp.count; j++) {
//
//            for (int i=1;i<arraySelCells_tmp.count;i++)
//            {
//                Cell_class* cellX= arraySelCells_tmp[i];
//                if (cellX.cellIndex < [arraySelCells_tmp[i-1] cellIndex])
//                {
//                    [arraySelCells_tmp switch_itemsbetweenItemAtIndex:i andItemAtIndex:i-1];
//                }
//            }
//        }
//
//
//        // setting the correct X,Y
//        NSMutableArray* array4merge = [[NSMutableArray alloc]init];
//        Cell_class* firstCell = arraySelCells_tmp[0];
//        int XX= firstCell.coordinates.x+1;
//        int YY = firstCell.coordinates.y;
//        [array4merge addObject:firstCell];
//
//
//        int totWidth = 0;
//        int currWidth = 1;
//        BOOL isNewRow = false;
//
//        for (int i=1; i<arraySelCells_tmp.count; i++) {
//            Cell_class* cellX = arraySelCells_tmp[i];
//            Cell_class* prevCellX = arraySelCells_tmp[i-1];
//
//            if (cellX.cellIndex != prevCellX.cellIndex+1) {
//                if (isNewRow) {
//                    //merge the cells till now
//                    [self merge_cellsfromArray:array4merge];
//
//                    //start again
//                    [array4merge removeAllObjects];
//
//                    firstCell = cellX;
//                    i++;
//                    cellX=arraySelCells_tmp[i];
//                    XX=firstCell.coordinates.x+1;
//                    YY=firstCell.coordinates.y;
//
//                    [array4merge addObject:firstCell];
//                    totWidth=0;
//                    currWidth=1;
//                    isNewRow=false;
//
//                }
//                else{
//                //go 1 row down
//                XX=firstCell.coordinates.x;
//                YY=firstCell.coordinates.y+1;
//                totWidth=currWidth;
//                currWidth=0;
//                isNewRow=true;
//                }
//            }
//            else if(currWidth==totWidth && isNewRow)
//            {
//                currWidth=0;
//                YY++;
//                XX=firstCell.coordinates.x;
//            }
//            CGPoint newCellPoint = CGPointMake(XX, YY);
//            cellX.coordinates=newCellPoint;
//            currWidth++;
//            XX++;
//            [array4merge addObject:cellX];
//
//
//
//        }
//        if (isNewRow) {
//            [self merge_cellsfromArray:array4merge];
//            [array4merge removeAllObjects];
//        }
//
//
//
//        for (Cell_class* currCell in _arrayOfCells)
//        {
//            NSLog(@"After Sorting _arrayOfCells - cellIndex=%d",currCell.cellIndex);
//            NSLog(@"----------------cellWidth=%f, cellHeight=%f",currCell.size.width,currCell.size.height);
//            NSLog(@"----------------cellX=%f, cellY=%f",currCell.coordinates.x,currCell.coordinates.y);
//
//        }
//
//
//
//
//
//
//
//
//            //check if the cells can be merge
//
//        Cell_class* currCell = arraySelCells_tmp[0];
//        YY = currCell.coordinates.y;
//        XX = currCell.coordinates.x;
//
//        int width4compare=0;
//        totWidth=1;
//        int totHeight=1;
//
//        BOOL errMergeCells = false;
//
//        //for (Cell_class* cell in arraySelCells_tmp)
//        for (int i=1;i<arraySelCells_tmp.count;i++)
//        {
//            Cell_class* cell = [[Cell_class alloc]init];
//            cell = arraySelCells_tmp[i];
//            NSLog(@"cellIndex = %d",cell.cellIndex);
//
//            if (cell.coordinates.y == YY)
//            {
//                NSLog(@"cell.coordinates.y = %f, YY = %d",cell.coordinates.y,YY);
//
//                totWidth++;
//                NSLog(@"totWidth = %d",totWidth);
//
//            }
//            else if (cell.coordinates.x == XX) {
//                NSLog(@"cellIndex = %d",cell.cellIndex);
//                NSLog(@"cell.coordinates.x = %f, XX = %d",cell.coordinates.x,XX);
//                if (width4compare == 0)
//                    width4compare = totWidth;
//                else if (totWidth > width4compare || totWidth < width4compare)
//                {
//                    NSLog(@"ERROR - width4Compare = %d, totWidth = %d",width4compare,totWidth);
//                    errMergeCells=TRUE;
//                    break;
//                }
//                totWidth=1;
//                NSLog(@"totWidth = %d",totWidth);
//                YY=cell.coordinates.y;
//                NSLog(@"YY = %d",YY);
//                totHeight++;
//                NSLog(@"totHeight = %d",totHeight);
//            }
//            else{
//                NSLog(@"ERROR - not the same X - cell.x - %f <> XX - %d",cell.coordinates.x,XX);
//                errMergeCells=TRUE;
//                break;
//            }
//        }
//
////        if (errMergeCells) // can't merge cells
////        {
////            //undo basic spliting
////            _arrayOfCells = array4UNDO_AllCells;
////            [_colEditBoard reloadData];
////
////        }
//   }
//
//}


-(Cell_class*)mergecellsInArray:(NSMutableArray*)array4merge
{
    //this algoritm is build for custom merge that user chooses
    //-----------------------------------------------------------------------
    
    NSLog(@"mergecellsInArray");
    
    //create an UNDO point
    _array4UNDO = [[NSMutableArray alloc]initWithArray:_arrayOfCells copyItems:TRUE];
    _matrix4UNDO = [[NSMutableArray alloc]initWithArray:_matrixOfCells copyItems:TRUE];

    
    
    // sort the array containing the selected cells for merging
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"cellIndex" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    [array4merge sortUsingDescriptors:sortDescriptors];
    
    Cell_class* orgCell = [array4merge objectAtIndex:0];
    orgCell.mark4show=YES;
    int prevX = orgCell.coordinates.x;//+orgCell.size.height;
    int prevY = orgCell.coordinates.y;//+orgCell.size.width;
    int totHeight = orgCell.size.height;
    int totWidth = orgCell.size.width;
    
    
    for (int t=1;t<array4merge.count;t++) {
        
        Cell_class* cellX = [array4merge objectAtIndex:t];
        cellX.mark4show=NO;
        NSLog(@"array4merge has %d - %@",cellX.cellIndex,cellX.collection);

        if (prevY == cellX.coordinates.y) {
            totHeight = totHeight + cellX.size.height;
        }
        if (prevX == cellX.coordinates.x) {
            totWidth = totWidth + cellX.size.width;
        }
        
    }
    
    for (int i=1; i<array4merge.count; i++) {
        Cell_class* cellX = [array4merge objectAtIndex:i];
        for (NSValue* pointX in cellX.collection){
            [orgCell.collection addObject:pointX];
        }

    }
    
    
    
    
    orgCell.size = CGSizeMake(totWidth, totHeight);
    
    
    for (int i=1; i<[array4merge count]; i++) {
        Cell_class* cellZ = [array4merge objectAtIndex:i];
        cellZ.size = CGSizeMake(1, 1);
        
        [_arrayOfCells removeObject:cellZ];
    }
    
    [_globalFuncs PrintOut_matrix:_matrixOfCells showIndex:NO showMark:YES];
    
    //clean up the array of selected cells
    [array4merge removeAllObjects];

   // [self refresh_arrayOfCellswith:CGSizeMake(0,0)];  //includes canceling the selection
    
    //refresh collectionview
    [_colEditBoard reloadData];
    
     [self setTags4Array:_arrayOfCells withTotalRows:-1  withTotalCols:-1 withStartCell:orgCell];
    
    
    return orgCell;
    
    
    
}

-(Cell_class*)merge_cellsfromArray:(NSMutableArray*)array4merge
{
    
    
    //this algoritm is build for custom merge that user chooses
    //-----------------------------------------------------------------------
    
    NSLog(@"merge_cellsfromArray");
    
    //create an UNDO point
    _array4UNDO = [[NSMutableArray alloc]initWithArray:_arrayOfCells copyItems:TRUE];
    
    
    // sort the array containing the selected cells for merging
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"cellIndex" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    [array4merge sortUsingDescriptors:sortDescriptors];
    
    
    Cell_class* orgCell = [array4merge objectAtIndex:0];
    
    // needs to set the size according the selection
    CGSize cellSize = [self calcMergeSize4array:array4merge];
    
    
    if (cellSize.height > 0 && cellSize.width > 0) {
        // the merging is possible
        orgCell.size=cellSize;
        for (int i=1; i<[array4merge count]; i++) {
            Cell_class* cellZ = [array4merge objectAtIndex:i];
            [_arrayOfCells removeObject:cellZ];
        }
        
        //clean up the array of selected cells
        [array4merge removeAllObjects];
     
        
        //reorganize the matrix array
        // find where in the matrix the orgCell exists
        BOOL flgExit = NO;
        CGPoint orgPoint = CGPointMake(-1, -1);
        for (int i=0; i<[_matrixOfCells count]; i++) {
            if (flgExit)
                break;
            
            NSMutableArray* arrayRow = [[NSMutableArray alloc]initWithArray:[_matrixOfCells objectAtIndex:i]];
            for (int j=0; j<[arrayRow count]; j++) {
                if (orgCell.cellIndex == [[arrayRow objectAtIndex:j] cellIndex]) {
                    orgPoint = CGPointMake(i, j);
                    flgExit = YES;
                    break;
                }
            }
        }
        //
        // update the new size into the matrix cells
        int cellX= orgPoint.x;
        int cellY = orgPoint.y;
        for (int i=0; i<orgCell.size.height; i++) {
            for (int j=0; j<orgCell.size.width; j++) {
                
                Cell_class* cellZ = [[_matrixOfCells objectAtIndex:cellX] objectAtIndex:cellY];
               // NSLog(@"X,Y-(%d,%d)-cellIndex was %d -> now is %d ",cellX,cellY,cellZ.cellIndex,orgCell.cellIndex);
                cellZ.cellIndex = orgCell.cellIndex;
                cellY++;
            }
            cellX++;
            cellY = orgPoint.y;
            
        }
        
       // [_globalFuncs PrintOut_matrix:_matrixOfCells];
       // [_globalFuncs PrintOut_arrayXY:_arrayOfCells];
        
        [self refresh_arrayOfCellswith:CGSizeMake(0,0)];  //includes canceling the selection
        
        //refresh collectionview
        [_colEditBoard reloadData];
        
        [self setTags4Array:_arrayOfCells withTotalRows:-1  withTotalCols:-1 withStartCell:orgCell];
    }
    else
    {
        // merging can't be done
        [self refresh_arrayOfCellswith:CGSizeMake(0,0)];  //includes canceling the selection
        
    }
    
    //for testing
   // [_globalFuncs PrintOut_matrix:_matrixOfCells];
    
    return orgCell;
}


-(void)UndoLastAction
{
    _arrayOfCells = _array4UNDO;
    _matrixOfCells = _matrix4UNDO;
    
    [_colEditBoard reloadData];
}


//-(Cell_class*)merge_cells
//{
//
//
//    //this algoritm is build only for programaticaly merging for new board
//    // it is KNOWN that _arrayOfSelCells is the array that holds the cells for merging
//    //-----------------------------------------------------------------------
//
//    NSLog(@"merge_cells");
//
//    int cnt=0;
//    Cell_class* orgCell = [[Cell_class alloc]init];
//
//    [self sortCells4MergeinArray:_arrayOfSelCells];
//
//    NSMutableArray* arrayTMP = [[NSMutableArray alloc]init];
//
//    for (Cell_class* cellX in _arrayOfSelCells)
//    {
//        if(cnt==0) // the MIN index of the sellected cells. he is the one who will remain
//        {
//            cnt++;
//            // needs to set the size according the selection
//            CGSize cellSize = [self calcMergeSize4array:_arrayOfSelCells];
//            //the actual merging - the top-left cell of the selected cells is resized to the total size of all selected cells
//            cellX.size=cellSize;
//            orgCell = cellX;
//
//        }
//        else{
//            [arrayTMP addObject:cellX];
//            cnt++;
//        }
//    }
//
//    for (Cell_class* cellX in arrayTMP)
//    {// update the big array. remove the cells that have been merged
//
//        [_arrayOfCells removeObject:cellX];
//
//    }
//
//    //clean up the array of selected cells
//
//    [_arrayOfSelCells removeAllObjects];
//
//    //refresh collectionview
//    [_colEditBoard reloadData];
//
//    [self setTags4Array:_arrayOfCells withTotalRows:1 withTotalCols:1 withStartCell:orgCell];
//
//
//    return orgCell;
//
//
//}

-(void)refresh_arrayOfCellswith:(CGSize)cellSize
{
    
    
    //for testing
    NSLog(@"refresh_arrayOfCellswith");
  //  [_globalFuncs PrintOut_matrix:_matrixOfCells];
    
    
    
    BOOL flgExit = NO;
    int currIndex = -1;
    for (int indx=0;indx<_arrayOfCells.count;indx++)
    {
        // to do - check that te func doesn't overwrite existing user's data
        Cell_class* theCell = _arrayOfCells[indx];
        
        // find theCell in matrix array
        for (int i=0; i<[_matrixOfCells count]; i++) {
            if (flgExit)
                break;
            
            NSMutableArray* arrayRow = [[NSMutableArray alloc]initWithArray:[_matrixOfCells objectAtIndex:i]];
            for (int j=0; j<[arrayRow count]; j++) {
                Cell_class* cellZ = [arrayRow objectAtIndex:j];
                if (cellZ.coordinates.x == theCell.coordinates.x  && cellZ.coordinates.y == theCell.coordinates.y) {
                    currIndex = theCell.cellIndex;
                    flgExit=YES;
                    break;
                }
            }
        }
        //
        // if theCell exists in matrix, find all the same indexes and change them
        if(currIndex != -1)
        {
            flgExit = NO;
            for (int i=0; i<[_matrixOfCells count]; i++) {
                NSMutableArray* arrayRow = [[NSMutableArray alloc]initWithArray:[_matrixOfCells objectAtIndex:i]];
                for (int j=0; j<[arrayRow count]; j++) {
                    Cell_class* cellZ = [arrayRow objectAtIndex:j];
                    if (cellZ.cellIndex == currIndex) {
                        cellZ.cellIndex = indx;
                        if (cellZ.cellIndex == 15) {
                            NSLog(@"cellZ = 15");
                        }
                        // change - 25-09-2015
                        //cellZ.coordinates = CGPointMake(i,j);
                        //-------------------
                    }
                }
            }
        }
        else
            NSLog(@"refresh cells - ERROR");
        
        
        theCell.cellIndex=indx;
        theCell.cellText=[NSString stringWithFormat:@"%d",indx];
        theCell.selected=NO;
        theCell.cellBackgroundColor = [UIColor clearColor];
        theCell.cellBorderColor = [UIColor darkGrayColor];
        theCell.cellImageID=@"-1";//[NSNumber numberWithInt:-1];
        //  theCell.tag=[NSNumber numberWithInt:i];
        
        
        
        
        if (cellSize.height != 0 && cellSize.width != 0)
        {
            theCell.size = cellSize;
        }
    }
    
    
    
}

-(void)updateCellatIndex:(int)cellIndex with:(Cell_class*)cellData
{
    Cell_class* cellX = [[Cell_class alloc]init];
    cellX = [_arrayOfCells objectAtIndex:cellIndex];
    
    
}

//-(void)refresh_arrayOfCells_incXY
//{
//    int cntSel=0;
//    BOOL isSelectedCell = false;
//    BOOL didFase1 = false;
//    BOOL didFase2 = false;
//    int totWidth =0;
//
//    Cell_class* cell0 = _arrayOfCells[0];
//    cell0.cellIndex=0;
//    cell0.cellText=@"0";
//    cell0.selected=NO;
//
//
//    for (int i=1;i<_arrayOfCells.count;i++)
//    {
//        Cell_class* currCell = _arrayOfCells[i];
//        currCell.cellIndex=i;
//        currCell.cellText=[NSString stringWithFormat:@"%d",i];
//        currCell.selected=NO;
//    }
//
//    [_colEditBoard reloadData];
//
//
//    for (int i=0;i<_arrayOfCells.count;i++)
//    {
//        Cell_class* currCell = _arrayOfCells[i];
//        NSLog(@"cellIndex= %d,cellX=%f,cellY=%f",i,currCell.coordinates.x,currCell.coordinates.y);
//
//    }
//
//
//
//
//
////    for (int i=1;i<_arrayOfCells.count;i++)
////    {
////        Cell_class* currCell = _arrayOfCells[i];
////        Cell_class* prevCell = _arrayOfCells[i-1];
////
////        Cell_class* selCellX = _arrayOfSelCells[cntSel];
////        if (selCellX.coordinates.x == currCell.coordinates.x && selCellX.coordinates.y == currCell.coordinates.y)
////           isSelectedCell=true;
////
////        if ((currCell.size.height == 1 && currCell.size.width == 1) && (prevCell.size.height != currCell.size.height))
////        {
////            int WW = 0;
////
////            if (isSelectedCell && !didFase1) {
////
////                didFase1 = true;
////                int XX = selCellX.coordinates.x;
////                int YY = selCellX.coordinates.y;
////
////                int cntCell=currCell.cellIndex;
////                //int totWidth = prevCell.cellIndex-selCellX.cellIndex;
////
////                while (!(currCell.size.width !=1 && currCell.size.height !=1)) {
////
////                    Cell_class* cellX = _arrayOfCells[cntCell];
////
////                    CGPoint pointCell = CGPointMake(XX, YY);
////                    cellX.coordinates = pointCell;
////
////                    WW++;
////                    XX++;
////                    cntCell++;
////
////                }
////                totWidth=WW;
////            }
////
////            if (isSelectedCell && !didFase2) {
////
////                didFase2 = true;
////                int XX = selCellX.coordinates.x;
////                int YY = selCellX.coordinates.y+1;
////                //int WW = 0;
////                int cntCell=currCell.cellIndex;
////                //int totWidth = prevCell.cellIndex-selCellX.cellIndex;
////
////                while (!(currCell.size.width !=1 && currCell.size.height !=1)) {
////
////                    Cell_class* cellX = _arrayOfCells[cntCell];
////
////                    CGPoint pointCell = CGPointMake(XX, YY);
////                    cellX.coordinates = pointCell;
////
////                    WW++;
////                    cntCell++;
////                    if (WW==totWidth) {
////                        WW=0;
////                        YY++;
////                        XX=selCellX.coordinates.x;
////                    }
////
////
////                }
////                totWidth=WW;
////            }
////
////        }
////
////        //
////        //        if ((prevCell.size.height == 1 && prevCell.size.width == 1) && (prevCell.size.height != currCell.size.height))
////        //        {
////        //
////        //            if (isSelectedCell && !didFase2) {
////        //
////        //                //totWidth = prevCell.cellIndex-selCellX.cellIndex;
////        //                didFase2 = true;
////        //
////        //                int XX = selCellX.coordinates.x;
////        //                int YY = selCellX.coordinates.y;
////        //                int WW = 0;
////        //                int cntCell=Cell.cellIndex;
////        //                //int totWidth = prevCell.cellIndex-selCellX.cellIndex;
////        //
////        //                while (!(currCell.size.width !=1 && currCell.size.height !=1)) {
////        //
////        //                    Cell_class* cellX = _arrayOfCells[cntCell];
////        //
////        //                    CGPoint pointCell = CGPointMake(XX, YY);
////        //                    cellX.coordinates = pointCell;
////        //
////        //                    WW++;
////        //                    cntCell++;
////        //
////        //                }
////        //                totWidth=WW;
////        //
////        //                    //                if (WW==totWidth) {
////        //                    //                    WW=0;
////        //                    //                    YY++;
////        //                    //                    XX=selCellX.coordinates.x;
////        //                    //                }
////        //
////        //
////        //                }
////        //
////        //            }
////        //
////    }
////
////
////
////
////
////
////    for (int i=0;i<_arrayOfCells.count;i++)
////    {
////        Cell_class* currCell = _arrayOfCells[i];
////        currCell.cellIndex=i;
////        NSLog(@"cellX=%f,cellY=%f",currCell.coordinates.x,currCell.coordinates.y);
////
////    }
//}


//-(CGSize)calc2CellsMergeSize:(Cell_class*)cellA andwith:(Cell_class*)cellB
//{
//    int totHeight=0;
//
//    int totWidth=0;
//   // NSLog(@"cellA = %@",cell);
//   // NSLog(@"cellB = %@",cellB.size);
//
//
//    if (cellA.coordinates.x==cellB.coordinates.x){
//        totWidth=cellA.size.width;
//        totHeight=cellA.size.height+cellB.size.height;
//    }
//
//    if (cellA.coordinates.y ==cellB.coordinates.y) {
//        totHeight=cellA.size.height;
//        totWidth=cellA.size.width+cellB.size.width;
//    }
//
//    return CGSizeMake(totWidth, totHeight);
//
//}


-(CGSize)calcMergeSize4array:(NSArray*)array4merge
{
    
    
//    // for testing
//    for (Cell_class* aCell in array4merge)
//    {
//        NSLog(@"aCell index = %d",aCell.cellIndex);
//    }
    
    //everything is refering to the number of cells and NOT pixels
    BOOL flgVert = NO;
    BOOL flgHorz = NO;
    BOOL flgMergePossible = YES;
    
    // Cell_class* cell0 = array4merge[0];
    int totHeight = 0;//cell0.size.height;
    // NSMutableArray* WWidth = [[NSMutableArray alloc]init];
    int totWidth = 0;//cell0.size.width;
    
    //int cnt4merge=0;
    int prevI = -1;
    int prevJ = -1;
    CGPoint pointPrevLeftCell;
    
   

    
    if (flgMergePossible) {
        for (int i=0; i<[_matrixOfCells count]; i++) {
            NSMutableArray* arrayRow = [[NSMutableArray alloc]initWithArray:[_matrixOfCells objectAtIndex:i]];
            if (!flgMergePossible)
                break;
            
            for (int j=0; j<[arrayRow count]; j++) {
                if (!flgMergePossible)
                    break;
                
                for (Cell_class* cellZ in array4merge) {
                    int indx4merge = cellZ.cellIndex;
                    
                    if ([[[_matrixOfCells objectAtIndex:i] objectAtIndex:j] cellIndex] == indx4merge) {
                        if (prevI == -1 && prevJ == -1) {
                            // first loop
                            prevI=i;
                            prevJ=j;
                            totWidth++;// = totWidth + cellZ.size.width;
                            totHeight++;// = totHeight + cellZ.size.height;
                            pointPrevLeftCell = CGPointMake(i, j) ;                           //cnt4merge++;
                        }else{
                            if (i == prevI+1) {
                                // vertical
                                totHeight ++;// = totHeight + cellZ.size.height;
                                prevI = i;
                                // cnt4merge++;
                                flgVert = YES;
                                prevJ=j-1;
                                totWidth=0;
                                
                            }
                            if (j == prevJ+1) {
                                //horizontal
                                totWidth ++ ; //= totWidth+cellZ.size.width;
                                prevJ = j;
                                // cnt4merge++;
                                flgHorz =YES;
                            }
                            if (!flgHorz && !flgVert)
                            {
                                // can't be that the next cell is diagonal or no at all near the prev cell
                                flgMergePossible = NO;
                                break;
                                
                            }else
                            {
                                if (flgHorz && flgVert) // this situation can happend in 2 occations. One can be merged - the other not
                                {
                                    // check if the current cell is exactly bellow the most left cell in selection for merge
                                    if (i == pointPrevLeftCell.x+1 && j == pointPrevLeftCell.y) {
                                        // OK -> save the current point for current most left cell is selection for merge
                                        pointPrevLeftCell = CGPointMake(i, j);
                                    }
                                    else
                                    {
                                        // can't be that the next cell is diagonal or no at all near the prev cell
                                        // flgMergePossible = NO;
                                        //  break;
                                        
                                    }
                                    
                                }
                            }
                            
                            flgHorz = NO; flgVert=NO;
                            
                        }
                        
                    }
                    
                }
            }
        }
        
    }
    
    
    
    if (flgMergePossible)
        return CGSizeMake(totWidth, totHeight);
    
    else
        
        return CGSizeMake(0, 0);
}

-(void)add_image2XMLfile
{
    XMLmanager_class* xmlHandler = [[XMLmanager_class alloc]init];
    [xmlHandler createImagesLocalXMLfile:@"new image from camera" andwith:[_appDelegate arrayOfImages]];
}


-(void)setTags4Array:(NSArray*)arrayX withTotalRows:(int)rows withTotalCols:(int)cols withStartCell:(Cell_class*)orgCell
{
    
    NSString* T, *R, *B, *L;
    
    // if rows and cols = 12 -> set tags for the basic layout 12x12 = 144
    if (rows == 12 && cols == 12) {
        
        for (Cell_class* cellX in arrayX) {
            NSLog(@"cellIndex=%d",cellX.cellIndex);
            switch (cellX.cellIndex) {
                case 0:
                    T = @"-1";
                    L = @"-1";
                    R = [NSString stringWithFormat:@"%d",cellX.cellIndex+1];
                    B = [NSString stringWithFormat:@"%d",cellX.cellIndex+rows];
                    
                    break;
                    
                case 11:
                    T = @"-1";
                    L = [NSString stringWithFormat:@"%d",cellX.cellIndex-1];
                    R = @"-1";
                    B = [NSString stringWithFormat:@"%d",cellX.cellIndex+rows];
                    
                    break;
                    
                case 132:
                    T = [NSString stringWithFormat:@"%d",abs(cellX.cellIndex-rows)];
                    L = @"-1";
                    R = [NSString stringWithFormat:@"%d",cellX.cellIndex+1];
                    B = @"-1";
                    
                    
                    break;
                    
                case 143:
                    T = [NSString stringWithFormat:@"%d",abs(cellX.cellIndex-rows)];
                    L = [NSString stringWithFormat:@"%d",cellX.cellIndex-1];
                    R = @"-1";
                    B = @"-1";
                    
                    break;
                    
                default:
                    if (cellX.cellIndex > 0 && cellX.cellIndex < 11)
                    {
                        T = @"-1";
                        L = [NSString stringWithFormat:@"%d",cellX.cellIndex-1];
                        R =  [NSString stringWithFormat:@"%d",cellX.cellIndex+1];
                        B = [NSString stringWithFormat:@"%d",cellX.cellIndex+rows];
                        
                    }
                    else if (cellX.cellIndex > 132 && cellX.cellIndex < 143)
                    {
                        T = [NSString stringWithFormat:@"%d",cellX.cellIndex-rows];
                        L = [NSString stringWithFormat:@"%d",cellX.cellIndex-1];
                        R = [NSString stringWithFormat:@"%d",cellX.cellIndex+1];
                        B = @"-1";
                    }
                    else if((cellX.cellIndex % 12) == 0)
                    {
                        T = [NSString stringWithFormat:@"%d",abs(cellX.cellIndex-rows)];
                        L = @"-1";
                        R = [NSString stringWithFormat:@"%d",cellX.cellIndex+1];
                        B = [NSString stringWithFormat:@"%d",cellX.cellIndex+rows];
                    }
                    else if(((cellX.cellIndex - (rows - 1)) % 12) == 0)
                    {
                        T = [NSString stringWithFormat:@"%d",abs(cellX.cellIndex-rows)];
                        L = [NSString stringWithFormat:@"%d",cellX.cellIndex-1];
                        R = @"-1";
                        B = [NSString stringWithFormat:@"%d",cellX.cellIndex+rows];
                    }
                    
                    else{
                        T = [NSString stringWithFormat:@"%d",abs(cellX.cellIndex-rows)];
                        L = [NSString stringWithFormat:@"%d",cellX.cellIndex-1];
                        R = [NSString stringWithFormat:@"%d",cellX.cellIndex+1];
                        B = [NSString stringWithFormat:@"%d",cellX.cellIndex+rows];
                    }
                    
                    
                    break;
            }
            
            
            NSMutableDictionary* dictTag = [[NSMutableDictionary alloc]init] ;
            [dictTag setValue:T forKey:@"T"];
            [dictTag setValue:R forKey:@"R"];
            [dictTag setValue:B forKey:@"B"];
            [dictTag setValue:L forKey:@"L"];
            
            cellX.tag = dictTag;
            
            
        }
        
        
    }
    else
    {
        // update tags to ALL cells when the grid is not on it's basic state - 12x12
        for (int i=0; i<[_matrixOfCells count]; i++) {
            NSMutableArray* arrayRow = [[NSMutableArray alloc]initWithArray:[_matrixOfCells objectAtIndex:i]];
            for (int j=0; j<[arrayRow count]; j++) {
                Cell_class* cellZ = [[_matrixOfCells objectAtIndex:i] objectAtIndex:j];
                T=@""; R=@""; B=@""; L=@"";
                
                // check TOP border
                if (i == 0) {
                    T = @"-1";
                }
                else
                {
                    int indx = j;
                    for (int s=0; s<cellZ.size.width; s++) {
                        T = [T stringByAppendingString:[NSString stringWithFormat:@"%d,",[[[_matrixOfCells objectAtIndex:i-1] objectAtIndex:indx] cellIndex]]];
                        indx++;
                        
                    }
                }
                // check BOTTOM border
                if (i == NUMOFCELLSINCOL-1) {
                    B = @"-1";
                }
                else
                {
                    int indx = j;
                    int row = i;
                    // go down to the row bellow the large cell
                    while ([[[_matrixOfCells objectAtIndex:row] objectAtIndex:indx] cellIndex] == cellZ.cellIndex) {
                        if (row == NUMOFCELLSINCOL-1) {
                            B = @"-1";
                            break;
                        }
                        else
                            row++;
                    }
                    if (![B isEqualToString:@"-1"]) {
                        for (int s=0; s<cellZ.size.width; s++) {
                            B = [B stringByAppendingString:[NSString stringWithFormat:@"%d,",[[[_matrixOfCells objectAtIndex:row] objectAtIndex:indx] cellIndex]]];
                            indx++;
                        }
                    }
                }
                
                // check LEFT border
                if (j == 0) {
                    L = @"-1";
                }
                else{
                    
                    int indx = i;
                    for (int s=0; s<cellZ.size.height; s++) {
                        L = [L stringByAppendingString:[NSString stringWithFormat:@"%d,",[[[_matrixOfCells objectAtIndex:indx] objectAtIndex:j-1] cellIndex]]];
                        indx++;
                    }
                    
                }
                
                //check RIGHT border
                if (j == NUMOFCELLSINROW-1) {
                    R = @"-1";
                }
                else{
                    
                    int indx = i;
                    int col = j;
                    // go right to the nearest col to the large cell
                    
                    while ([[[_matrixOfCells objectAtIndex:indx] objectAtIndex:col] cellIndex] == cellZ.cellIndex) {
                        if (col == NUMOFCELLSINROW-1) {
                            R = @"-1";
                            break;
                        }
                        else
                            col++;
                    }
                    if (![R isEqualToString:@"-1"]) {
                        
                        for (int s=0; s<cellZ.size.height; s++) {
                            R=[R stringByAppendingString:[NSString stringWithFormat:@"%d,",[[[_matrixOfCells objectAtIndex:indx] objectAtIndex:col] cellIndex]]];
                            indx++;
                        }
                    }
                }
                
                NSMutableDictionary* dictTag = [[NSMutableDictionary alloc]init] ;
                [dictTag setValue:T forKey:@"T"];
                [dictTag setValue:R forKey:@"R"];
                [dictTag setValue:B forKey:@"B"];
                [dictTag setValue:L forKey:@"L"];
                
                cellZ.tag = dictTag;
                
                
                
            }
            
            
        }
    }
}

-(void)updateMatrixIndexes4Cell:(Cell_class*)orgCell withIndex:(int)newIndex
{
    //reorganize the matrix array
    // find where in the matrix the orgCell exists
    // CGPoint orgPoint = CGPointMake(-1, -1);
    CGPoint orgPoint = CGPointMake(orgCell.coordinates.x, orgCell.coordinates.y);
    
    // update the new size into the matrix cells
    int cellX= orgPoint.x;
    int cellY = orgPoint.y;
    for (int i=0; i<orgCell.size.height; i++) {
        for (int j=0; j<orgCell.size.width; j++) {
            
            Cell_class* cellZ = [[_matrixOfCells objectAtIndex:cellX] objectAtIndex:cellY];
            NSLog(@"X,Y-(%d,%d)-cellIndex was %d -> now is %d ",cellX,cellY,cellZ.cellIndex,newIndex);
            cellZ.cellIndex = newIndex;
            cellY++;
        }
        cellX++;
        cellY = orgPoint.y;
        
    }
    
    
    
}


-(void)searchMatrix4Cell:(Cell_class*)cell4check andUpdatewithIndex:(int)newIndx
{
    for (int i=cell4check.coordinates.x; i<_matrixOfCells.count; i++) {
        for (int j=cell4check.coordinates.y; j<_matrixOfCells.count; j++) {
            
            Cell_class* cellZ = [[_matrixOfCells objectAtIndex:i] objectAtIndex:j];
            if(cellZ.cellIndex == cell4check.cellIndex)
            {
                //NSLog(@"X,Y-(%d,%d)-cellIndex was %d -> now is %d ",cellX,cellY,cellZ.cellIndex,newIndex);
                cellZ.cellIndex = newIndx;
            }
            
        }
        
    }
    
}

-(void)updatematrix_afterSplit_withCell:(Cell_class*)selCell4Split
{
    
    int totWidth=0;
    int xx = 0;
 //   int yy= 0;
    Cell_class* cell = [_arrayOfCells objectAtIndex:0];
    cell.cellIndex=0;
    cell.cellText = [NSString stringWithFormat:@"%d",0];
    cell.coordinates = CGPointMake(0, 0);

    totWidth=cell.size.width;
    xx=cell.size.width;
    
    // go through the arrayOfCells and update the index
    for (int q=1; q<_arrayOfCells.count; q++) {
        Cell_class* cellX = [_arrayOfCells objectAtIndex:q];
        cellX.cellIndex=q;
        cellX.cellText = [NSString stringWithFormat:@"%d",q];
        
    }
    
    
    // to do - check that te func doesn't overwrite existing user's data
    
    //assign correct coordinates for the cells in sel4SplitCell
    for (int i=selCell4Split.coordinates.x;i<selCell4Split.coordinates.x+selCell4Split.size.height;i++) {
        
        for (int j=selCell4Split.coordinates.y;j<selCell4Split.coordinates.y+selCell4Split.size.width;j++){
            
   //         Cell_class* cellZ = [[_matrixOfCells objectAtIndex:i] objectAtIndex:j];
           // change - 25-09-2015
            // cellZ.coordinates = CGPointMake(i, j);
            //-------------------
            
        }
    }
    
   
    
    
    
    BOOL flgExit = NO;
    int currIndex = -1;
    for (int q=1; q<_arrayOfCells.count; q++) {
        Cell_class* theCell = [_arrayOfCells objectAtIndex:q];
        // find theCell in matrix array
        for (int i=0; i<[_matrixOfCells count]; i++) {
            if (flgExit)
                break;
            
            NSMutableArray* arrayRow = [[NSMutableArray alloc]initWithArray:[_matrixOfCells objectAtIndex:i]];
            for (int j=0; j<[arrayRow count]; j++) {
                Cell_class* cellZ = [arrayRow objectAtIndex:j];
                if (theCell.coordinates.x == cellZ.coordinates.x && theCell.coordinates.y == cellZ.coordinates.y) {
                    currIndex = theCell.cellIndex;
                    flgExit=YES;
                    break;
                }
            }
        }
        
        //
        // if theCell exists in matrix, find all the same indexes and change them
        if(currIndex != -1)
        {
            
            flgExit = NO;
            for (int i=theCell.coordinates.x; i<theCell.coordinates.x+theCell.size.height; i++) {
                
                for (int j=theCell.coordinates.y; j<theCell.coordinates.y+theCell.size.width; j++) {
                    Cell_class* cellZ = [[_matrixOfCells objectAtIndex:i] objectAtIndex:j];
                    if (currIndex == 12) {
//                        NSLog(@"ERROR2 - cellZ.index=%d",cellZ.cellIndex);
                    }
                    cellZ.cellIndex = currIndex;
               
                }
            }
        }
        else
       
        
        
        theCell.selected=NO;
        theCell.cellBackgroundColor = [UIColor clearColor];
        theCell.cellBorderColor = [UIColor darkGrayColor];
        theCell.cellImageID=@"-1";//[NSNumber numberWithInt:-1];
        //  theCell.tag=[NSNumber numberWithInt:i];
        
    }
    
   }

#pragma mark -
#pragma mark Image handling Funcs
- (NSString*)saveImage:(UIImage*)image withName:(NSString*) imageName
{
    if (image != nil)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString* path = [documentsDirectory stringByAppendingPathComponent:imageName];
        NSData* data = UIImagePNGRepresentation(image);
        [data writeToFile:path atomically:YES];
        return path;
    }
    else
        return nil;
}

- (UIImage*)loadImage
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* path = [documentsDirectory stringByAppendingPathComponent:@"test.png" ];
    UIImage* image = [UIImage imageWithContentsOfFile:path];
    return image;
}


-(UIImage*)resizeImage:(UIImage*)image
{
    float actualHeight = image.size.height;
    float actualWidth = image.size.width;
    float imgRatio = actualWidth/actualHeight;
    float maxRatio = 320.0/480.0;
    
    if(imgRatio!=maxRatio){
        if(imgRatio < maxRatio){
            imgRatio = 480.0 / actualHeight;
            actualWidth = imgRatio * actualWidth;
            actualHeight = 480.0;
        }
        else{
            imgRatio = 320.0 / actualWidth;
            actualHeight = imgRatio * actualHeight;
            actualWidth = 320.0;
        }
    }
    CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
    UIGraphicsBeginImageContext(rect.size);
    [image drawInRect:rect];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //imgFromUserChoice = img;
    return  img;
}



#pragma mark -
#pragma mark UIALertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView.title isEqualToString:@"Save Photo"]) {
        if (buttonIndex==0) {
            NSString* imgName = [NSString stringWithFormat:@"%@",[alertView textFieldAtIndex:0].text];
            
            NSString* imgPath = [self saveImage:imgFromUserChoice withName:imgName];
            
            if (imgPath != nil) {
                Cell_class* theCell = [[Cell_class alloc]init];
                theCell=(Cell_class*)_arrayOfCells[_cellSelectedbyUser.cellIndex];
                [_arrayOfCells replaceObjectAtIndex:_cellSelectedbyUser.cellIndex withObject:theCell];
                
                [_colEditBoard reloadData];
                
            }
            
        }
    }
    
    //enter text in cell
    //    if ([alertView.title isEqualToString:TEXT_ALERT_TITLE]) {
    //        if (buttonIndex == 0) {
    //
    //            _cellSelectedbyUser.cellText=[alertView textFieldAtIndex:0].text;
    //            [_colEditBoard reloadData];
    //        }
    //    }
    
    // save board
    BOOL flgBoardNameExists=NO;
    if ([alertView.title isEqualToString:BOARD_ALERT_TITLE]) {
        if (buttonIndex == 0) {
            // check if there is allready a board with the same name
            for (BoardsList_class* brdX in _appDelegate.arrayOfBoards)
            {
                if ([brdX.brdFileName isEqualToString:[alertView textFieldAtIndex:0].text]) {
                    flgBoardNameExists=YES;
                }
            }
            
            if (flgBoardNameExists) {
                UIAlertView* alertSameBoardName = [[UIAlertView alloc]initWithTitle:BOARDSAMENAME_ALERT_TITLE message:@"Board with this name already exists." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Overwrite", nil];
                [alertSameBoardName show];
            }
            else
            {
                //add board to arrayOfBoards and recreate the boards list file
                BoardsList_class* brdX = [[BoardsList_class alloc]init];
                brdX.brdFileName =[alertView textFieldAtIndex:0].text;
                brdX.brdDate = [NSDate date];
                brdX.brdIcon = [UIImage imageNamed:@"table_48x48.gif"];
                [_appDelegate.arrayOfBoards addObject:brdX];
                XMLmanager_class* xmlCreateBoardList = [[XMLmanager_class alloc]init];
                [xmlCreateBoardList createBoardsList_localXMLfile:@"boards_list.xml" andwith:_appDelegate.arrayOfBoards];
                
                // save the board file containing the actuall data - board info + cells info
                NSMutableArray* arrayData4Save  = [[NSMutableArray alloc]initWithObjects:boardSelectedbyUser, nil];
                [arrayData4Save addObjectsFromArray:_matrixOfCells];
                XMLmanager_class* xmlManager = [[XMLmanager_class alloc]init];
                [xmlManager createBoardLocalXMLfilewithComment:@"Board" withData:arrayData4Save andwithBoardName:[alertView textFieldAtIndex:0].text];
            }
        }
    }
    
    
    if ([alertView.title isEqualToString:@"RClick menu"]) {
        if (buttonIndex == 0) {
            //merge cells
            _cellSelectedbyUser.cellText=[alertView textFieldAtIndex:0].text;
            [_colEditBoard reloadData];
        }
        
        if (buttonIndex == 1) {
            //split cells
            _cellSelectedbyUser.cellText=[alertView textFieldAtIndex:0].text;
            [_colEditBoard reloadData];
        }
        //        if (buttonIndex == 2) {
        //            //cancel
        //
        //
        //            _cellSelectedbyUser.cellText=[alertView textFieldAtIndex:0].text;
        //            [_colEditBoard reloadData];
        //        }
        
    }
    
    
}



#pragma mark -
#pragma mark BoardPopupmenuDelegate

- (void)MergeAction {
    
    NSNotificationCenter* notificationcenter = [NSNotificationCenter defaultCenter];
    [notificationcenter postNotificationName:@"dismisspopover" object:@"MergeAction"];
    
   // [self merge_cellsfromArray:_arrayOfSelCells];
    [self mergecellsInArray:_arrayOfSelCells];
    
    [_arrayOfSelCells removeAllObjects];
    
    _setMenuUndo = true;
    
}
//
- (void)SplitAction {
    
    NSNotificationCenter* notificationcenter = [NSNotificationCenter defaultCenter];
    [notificationcenter postNotificationName:@"dismisspopover" object:@"SplitAction"];
    
    // [self splitCells2Basic:_arrayOfSelCells[0]];
    [self splitCell2:_arrayOfSelCells[0]];
    
    [_arrayOfSelCells removeAllObjects];
    
    _setMenuUndo = true;
    
    
}

- (void)Undo {
    
    NSNotificationCenter* notificationcenter = [NSNotificationCenter defaultCenter];
    [notificationcenter postNotificationName:@"dismisspopover" object:@"UndoAction"];
    
    [self UndoLastAction];
    
}


- (void)SaveBoardAs {
    
    NSNotificationCenter* notificationcenter = [NSNotificationCenter defaultCenter];
    [notificationcenter postNotificationName:@"dismisspopover" object:@"SaveBoardAs"];
    
    [self saveboard:TRUE];
    
}

-(void)saveboard:(BOOL)SaveAs
{
    
    BoardsList_class* newBoard = [[BoardsList_class alloc]init];
    
         newBoard.brdID = boardSelectedbyUser.brdID;
         newBoard.brdFileName = [_globalFuncs repairString4UseAsFilename:boardSelectedbyUser.brdName];
         newBoard.brdDate = [NSDate date];
         //to do - open dlgbox and let user to set a personal icon for his main board
         // there will be a folder containg the icons.
         newBoard.brdIcon = @"stars.png";
         
    if (SaveAs) {
        [EasyAlertView showWithTitle:BOARD_ALERT_TITLE message:@"Enter new name for this board"alertStyle:UIAlertViewStylePlainTextInput usingBlock:^(NSUInteger buttonIndex, NSMutableArray* inpText)
         {
             if (buttonIndex == 0) { //user wants to replace existing board
                 
                 newBoard.brdFileName = [inpText objectAtIndex:0];
                 boardSelectedbyUser.brdName = [inpText objectAtIndex:0];
                 //add the new board to arrayOfBoards array
                 [_appDelegate.arrayOfBoards addObject:newBoard];
 
                 
                 // save the board file containing the actuall data - board info + cells info
                 NSMutableArray* arrayData4Save  = [[NSMutableArray alloc]initWithObjects:boardSelectedbyUser, nil];
                 //[arrayData4Save addObjectsFromArray:_arrayOfCells];
                 [arrayData4Save addObjectsFromArray:_matrixOfCells];
                 XMLmanager_class* xmlManager = [[XMLmanager_class alloc]init];
                 [xmlManager createBoardLocalXMLfilewithComment:@"Board" withData:arrayData4Save andwithBoardName:newBoard.brdFileName];//] stringByTrimmingCharactersInSet:
                 // [NSCharacterSet whitespaceCharacterSet]]];
                 
                 // update file boards_list.xml
                 XMLmanager_class* xmlCreateBoardList = [[XMLmanager_class alloc]init];
                 [xmlCreateBoardList createBoardsList_localXMLfile:@"boards_list.xml" andwith:_appDelegate.arrayOfBoards];
                 
                 
             }
             if (buttonIndex == 1) { // user pressed Cancel
                 UIAlertView* msgbox = [[UIAlertView alloc]initWithTitle:BOARD_ALERT_TITLE message:@"Saving cancelled" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                 [msgbox show];
             }
             
         }
                   cancelButtonTitle:@"Save"
                   otherButtonTitles:@"Cancel", nil];
    }

    
    else{
        // save the board file containing the actuall data - board info + cells info
        
        
        
        NSMutableArray* arrayData4Save  = [[NSMutableArray alloc]initWithObjects:boardSelectedbyUser, nil];
        [arrayData4Save addObjectsFromArray:_matrixOfCells];
        XMLmanager_class* xmlManager = [[XMLmanager_class alloc]init];
        [xmlManager createBoardLocalXMLfilewithComment:@"Board" withData:arrayData4Save andwithBoardName:newBoard.brdFileName];
        
        
        // update file boards_list.xml
        XMLmanager_class* xmlCreateBoardList = [[XMLmanager_class alloc]init];
        [xmlCreateBoardList createBoardsList_localXMLfile:@"boards_list.xml" andwith:_appDelegate.arrayOfBoards];
        
        // check if there is allready a board with the same name
        int flgBoardExistsAtIndex=-1;
        for (int i=0;i<[_appDelegate.arrayOfBoards count] ;i++)
        {
            BoardsList_class* brdX = [[BoardsList_class alloc]init];
            brdX = [_appDelegate.arrayOfBoards objectAtIndex:i];
            if ([brdX.brdFileName isEqualToString:boardSelectedbyUser.brdName]) {
                flgBoardExistsAtIndex=i;
            }
        }
        
        if (flgBoardExistsAtIndex == -1) { //if it is don't add it to the array
            
            //add the new board to arrayOfBoards array
            [_appDelegate.arrayOfBoards addObject:newBoard];
                 }
 
    }
    
    
}



- (void)LoadBoard {
    
    NSNotificationCenter* notificationcenter = [NSNotificationCenter defaultCenter];
    [notificationcenter postNotificationName:@"dismisspopover" object:@"showListOfBoards"];
    
    [self showListOfBoards];
    
}


#pragma mark -
#pragma mark – TEXTFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    boardSelectedbyUser.brdName = textField.text;
    [self SaveBoardAs];
}

#pragma mark -
#pragma mark – RFQuiltLayoutDelegate

- (CGSize) blockSizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.row >= _arrayOfCells.count)
        NSLog(@"Asking for index paths of non-existant cells!! %ld from %lu cells", (long)indexPath.row, (unsigned long)_arrayOfCells.count);
    
    //    if (indexPath.row % 10 == 0)
    //        return CGSizeMake(3, 1);
    //    if (indexPath.row % 11 == 0)
    //        return CGSizeMake(2, 1);
    //    else if (indexPath.row % 7 == 0)
    //        return CGSizeMake(1, 3);
    //    else if (indexPath.row % 8 == 0)
    //        return CGSizeMake(1, 2);
    //    else if(indexPath.row % 11 == 0)
    //        return CGSizeMake(2, 2);
    //    if (indexPath.row == 0) return CGSizeMake(5, 5);
    //
    //    return CGSizeMake(1, 1);
    
    
    Cell_class* currCell = [_arrayOfCells objectAtIndex:indexPath.row];
    return CGSizeMake(currCell.size.width, currCell.size.height);
    // return CGSizeMake(3, 1);///    currCell.size;
}

- (UIEdgeInsets)insetsForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //    if (indexPath.item == 0) { // first item of section
    //                CGRect frame = _collGrid.contentI                  currentItemAttributes.frame;
    //                frame.origin.x = sectionInset.left; // first item of the section should always be left aligned
    //                currentItemAttributes.frame = frame;
    //
    //        return currentItemAttributes;
    //    }
    
    
    return UIEdgeInsetsMake(2, 2, 2, 2);
    
}

#pragma mark -
#pragma mark NEOColorPickerViewController

- (void)colorPickerViewController:(NEOColorPickerBaseViewController *)controller didSelectColor:(UIColor *)color {
    // self.view.backgroundColor = color;
    
    if (color != nil) {
        
        if ([controller.title isEqualToString:@"Choose a color for Border"]) {
            _cellSelectedbyUser.cellBorderColor=color;
            
        }
        
        if ([controller.title isEqualToString:@"Choose a color for Background"]) {
            _cellSelectedbyUser.cellBackgroundColor=color;
        }
        
        [_colEditBoard reloadData];
        
    }
    
    
    
    
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)colorPickerViewControllerDidCancel:(NEOColorPickerBaseViewController *)controller {
    [controller dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark -
#pragma mark ImagePickerViewController


//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)
//{
//
//}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    
    // if image comes from album don't save it again
    // UIImagePickerControllerReferenceURL IS nil when image comes from camera
    if ( [info valueForKey:UIImagePickerControllerReferenceURL] == nil)
    {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        
    }
    
    
    
    UIImage* resizedImage = [self resizeImage:image];
    
    Images_class* imgX = [[Images_class alloc]init];
    
    [EasyAlertView showWithTitle:IMAGESAVE_ALERT_TITLE message:@"Save image as ..." alertStyle:UIAlertViewStylePlainTextInput usingBlock:^(NSUInteger buttonIndex, NSMutableArray* inpText)
     {
         if (buttonIndex == 0) {
             NSString* strImageName = [inpText objectAtIndex:0];
             
             int iIndex = (int)[_appDelegate iTotalUserImages] +1;
             NSString* strSaveName = [[NSString stringWithFormat:@"%@%d",PREFIX_USER_IMAGES,iIndex] stringByAppendingPathExtension:@"png"];
             
             NSData* data = UIImagePNGRepresentation(resizedImage);
             
             NSString* imagePath = [[LIBRARY_MAIN_FOLDER stringByAppendingPathComponent:SYMBOLS_FOLDER_FROM_USER] stringByAppendingPathComponent:strSaveName];
             
             NSError* error;
             NSFileManager* filemanager = [NSFileManager defaultManager];
         
             NSString* dirUser = [LIBRARY_MAIN_FOLDER stringByAppendingPathComponent:SYMBOLS_FOLDER_FROM_USER] ;
             
             
             [filemanager createDirectoryAtPath:dirUser withIntermediateDirectories:YES attributes:nil error:&error];
             
             [data writeToFile:imagePath atomically:YES];
             
             
             
             
             BOOL res = [imgX updateImageClasswithShowName:strImageName
                                        andwithDescription:@"camera"
                                           andwithFileName:strSaveName
                                               andwithPath:SYMBOLS_FOLDER_FROM_USER
                                           andwithCategory:@"general"
                                        andwithUpdatedDate:[NSDate date]
                                      andwithUpdatedDateby:@"admin"
                                             andwithPrompt:@""
                                               andwithType:@""
                                              andwithIndex:[strSaveName stringByDeletingPathExtension]];
             
             
             
             if (!res) {
                 NSLog(@"Couldn't update image from camera");
             }
             else
             {
                 //add new image from camera to arrayOfImages
                 [_appDelegate.arrayOfImages addObject:imgX];
                 
                 //update total num of images from user
                 _appDelegate.iTotalUserImages= iIndex;
                 
                 // //add the new image from camera to the xml file in background
                 [self performSelectorInBackground:@selector(add_image2XMLfile) withObject:nil];
                 
                 //anounce that image has been capture
                 NSNotificationCenter* notificationcenter = [NSNotificationCenter defaultCenter];
                 [notificationcenter postNotificationName:@"imageFromCamera" object:imgX];
                 
             }
         }
     }
     
               cancelButtonTitle:@"Save" otherButtonTitles:@"Cancel", nil];
    
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}


//add double-tap gesture to each cell
//    UITapGestureRecognizer *tapPressGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userDidTapOnCell:)];
//    tapPressGesture.numberOfTapsRequired=1;
//    tapPressGesture.delegate=self;
//    [currCell addGestureRecognizer:tapPressGesture];

//    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(userDidPressLongOnCell)];
//    longPressGesture.minimumPressDuration = 2.0;
//    [currCell addGestureRecognizer:longPressGesture];
//

@end
