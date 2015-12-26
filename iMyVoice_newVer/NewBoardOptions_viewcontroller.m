
//
//  NewBoardOptions_viewcontroller.m
//  iMyVoice_newVer
//
//  Created by Simona Tzalik on 16/4/15.
//  Copyright (c) 2015 Techno M.A.G. All rights reserved.
//

#import "NewBoardOptions_class.h"
#import "NewBoardOptions_viewcontroller.h"
#import "NewBoardOptionsCell_collectionviewCell.h"
#import "DeviceFuncs.h"
#import "EditBoard_viewcontroller.h"
#import "ListofObjects_tableviewcontroller.h"
#import "GlobalsFunctions_class.h"
#import "BoardsList_class.h"
#import "XMLmanager_class.h"
#import "Board_class.h"
#import "Cell_class.h"
#import "AppDelegate.h"
#import "EasyAlertView.h"
#import "Popover_viewcontroller.h"




@interface NewBoardOptions_viewcontroller () <UICollectionViewDataSource,UICollectionViewDelegate,UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UICollectionView *colNewBoardOptions;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Message;
@property (weak, nonatomic) IBOutlet UIButton *btnLoadExistingBoard;
@property UIPopoverController* popover;
@property AppDelegate* appDelegate;
@property CGSize viewSize;
@property GlobalsFunctions_class* genFuncs;
@property BOOL flgKeyboardOnScreen;



@property NSMutableArray* arrayOfNewBoardOptions;
//@property NSMutableArray* arrayImages;
@property DeviceFuncs* myDevice;
@property NewBoardOptions_class* optBoards;
@property GlobalsFunctions_class* globalsFuncs;
@property Board_class* boardSelectedbyUser;
@property NewBoardOptionsCell_collectionviewCell* cellSelectedByUser;
@property NewBoardOptionsCell_collectionviewCell* prevcellSelectedByUser; // used for controlling the txtField enabled or not

@property NSMutableArray* matrixOfCells; // the duplicate from EditCell - it's declared here just fro save the new board user choosed when loading this view from cellProperties intended for new board for link

@end

@implementation NewBoardOptions_viewcontroller
@synthesize flgShowModal,lbl_Message,btnLoadExistingBoard,colNewBoardOptions;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _myDevice = [[DeviceFuncs alloc]init];
    _globalsFuncs = [[GlobalsFunctions_class alloc]init];
    _appDelegate = DELEGATE;
    _cellSelectedByUser = [[NewBoardOptionsCell_collectionviewCell alloc]init];
    _prevcellSelectedByUser = [[NewBoardOptionsCell_collectionviewCell alloc]init];
    _prevcellSelectedByUser = nil;
    _genFuncs = [[GlobalsFunctions_class alloc]init];
    _flgKeyboardOnScreen = false;
    
    _matrixOfCells = [[NSMutableArray alloc]initWithCapacity:NUMOFCELLSINROW];
    _boardSelectedbyUser = [[Board_class alloc]init];
    if (self.parentViewController != nil) {
        _viewSize = self.parentViewController.view.frame.size;
        
    }
    else
        _viewSize=self.view.frame.size;
    
    //init array of new board options with images
    _arrayOfNewBoardOptions = [[NSMutableArray alloc]initWithArray:nil copyItems:YES];
    
    
    //notifications for - reacting to the choice the user made
    NSNotificationCenter* notificationCenter = [NSNotificationCenter defaultCenter];
    
    [notificationCenter addObserver:self selector:@selector(notificationUserDidSelectBoardFromList:) name:@"boardfromlist" object:nil];
    
    
    [notificationCenter addObserver:self selector:@selector(notificationUserDidChoosedNewBoard:) name:@"userDidChooseNewBoard" object:nil];
    
    [notificationCenter addObserver:self selector:@selector(notificationDismissPopover:) name:@"dismisspopover" object:nil];
    
    [notificationCenter addObserver:self selector:@selector(showListOfExisitingBoards:) name:@"showlistexistingboards" object:nil];
    
    
    [notificationCenter addObserver:self selector:@selector(notificationKeyboardOnScreen) name:@"UIKeyboardDidShowNotification" object:nil];
    
    // UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
    //                             action:@selector(dismissKeyboardOnScreen)];
    
    // [self.view addGestureRecognizer:tap];
    
    
    
    NewBoardOptions_class* optBoards = [[NewBoardOptions_class alloc]init];
    optBoards.name =@"grid_1.png";
    optBoards.cols=1;
    optBoards.rows = 1;
    optBoards.imgIcon = [UIImage imageNamed:@"grid_1.png"];
    optBoards.indx = 1;
    [_arrayOfNewBoardOptions addObject:optBoards];
    
    
    NewBoardOptions_class* optBoards1 = [[NewBoardOptions_class alloc]init];
    optBoards1.name =@"grid_2.png";
    optBoards1.cols=2;
    optBoards1.rows = 1;
    optBoards1.imgIcon = [UIImage imageNamed:@"grid_2.png"];
    optBoards1.indx = 2;
    [_arrayOfNewBoardOptions addObject:optBoards1];
    
    NewBoardOptions_class* optBoards2 = [[NewBoardOptions_class alloc]init];
    optBoards2.name =@"grid_4.png";
    optBoards2.cols= 2;
    optBoards2.rows = 2;
    optBoards2.imgIcon = [UIImage imageNamed:@"grid_4.png"];
    optBoards2.indx = 3;
    [_arrayOfNewBoardOptions addObject:optBoards2];
    
    NewBoardOptions_class* optBoards3 = [[NewBoardOptions_class alloc]init];
    optBoards3.name =@"grid_6.png";
    optBoards3.cols= 3;
    optBoards3.rows = 2;
    optBoards3.imgIcon = [UIImage imageNamed:@"grid_6.png"];
    optBoards3.indx = 4;
    [_arrayOfNewBoardOptions addObject:optBoards3];
    
    NewBoardOptions_class* optBoards4 = [[NewBoardOptions_class alloc]init];
    optBoards4.name =@"grid_9.png";
    optBoards4.cols= 3;
    optBoards4.rows = 3;
    optBoards4.imgIcon = [UIImage imageNamed:@"grid_9.png"];
    optBoards4.indx = 5;
    [_arrayOfNewBoardOptions addObject:optBoards4];
    
    NewBoardOptions_class* optBoards5 = [[NewBoardOptions_class alloc]init];
    optBoards5.name =@"grid_12.png";
    optBoards5.cols=4;
    optBoards5.rows = 3;
    optBoards5.imgIcon = [UIImage imageNamed:@"grid_12.png"];
    optBoards5.indx = 6;
    [_arrayOfNewBoardOptions addObject:optBoards5];
    
    //    optBoards.name =@"cell_15.png";
    //    optBoards.cols=6;
    //    optBoards.rows = 4;
    //    optBoards.imgIcon = [UIImage imageNamed:@"cell_15.png"];
    //    [_arrayOfNewBoardOptions addObject:optBoards];
    
    NewBoardOptions_class* optBoards6 = [[NewBoardOptions_class alloc]init];
    optBoards6.name =@"grid_16.png";
    optBoards6.cols=4;
    optBoards6.rows = 4;
    optBoards6.imgIcon = [UIImage imageNamed:@"grid_16.png"];
    optBoards6.indx = 7;
    [_arrayOfNewBoardOptions addObject:optBoards6];
    
    //refresh data
    [colNewBoardOptions reloadData];
    
    //set navigationBar - add NEXT button
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.frame = CGRectMake(0, 0, 100, 30);
//    //  [button setImage:[UIImage imageNamed:@"table_48x48.gif"] forState:UIControlStateNormal];
//    [button setTitle:@"Next" forState:UIControlStateNormal];
//    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(doLoadNewBoard) forControlEvents:UIControlEventTouchUpInside];
//    
//    
//    UIBarButtonItem* navBoardButton=[[UIBarButtonItem alloc]init];
//    [navBoardButton setCustomView:button];
//    self.navigationItem.rightBarButtonItem=navBoardButton;
    
    
    //    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self     action:@selector(doLoadNewBoard)];
    //    [addButton setTitle:@"NEXT >"];
    //    NSArray *barButtons = [NSArray arrayWithObjects:addButton, nil];
    //    self.navigationItem.rightBarButtonItems = barButtons;
    
    
    
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    colNewBoardOptions.backgroundColor=[UIColor grayColor];
    
    [self arrangeObjectsOnScreen:(int)self.view.tag];
}

-(void) viewWillLayoutSubviews
{
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
}


#pragma mark UICOllectionVewDelegate + DATAsource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _arrayOfNewBoardOptions.count;
    
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NewBoardOptionsCell_collectionviewCell* currCell =[collectionView dequeueReusableCellWithReuseIdentifier:@"customcell" forIndexPath:indexPath];
    
    NewBoardOptions_class* cellX =_arrayOfNewBoardOptions[indexPath.row];
    
    currCell.imgNewBoard.image = (UIImage*)cellX.imgIcon;
    currCell.txtBoardName.tag = cellX.indx;
    [currCell.txtBoardName setDelegate:(id)self];
    
    
    return currCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
{
    
    NewBoardOptionsCell_collectionviewCell* currCell= (NewBoardOptionsCell_collectionviewCell*)[colNewBoardOptions cellForItemAtIndexPath:indexPath];
    
    
//    if (_prevcellSelectedByUser != nil) {
//        [_prevcellSelectedByUser.txtBoardName setEnabled:FALSE];
//        _cellSelectedByUser = currCell;
//        _prevcellSelectedByUser = _cellSelectedByUser;
//    }
//    else
//        _prevcellSelectedByUser = _cellSelectedByUser;
    
  //  [currCell.txtBoardName becomeFirstResponder];
  
    // show popover with new board details
    
    NSString* storyboardName = @"Main";
    NSString* viewControllerID = @"popover";
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    Popover_viewcontroller* popoverVC = [storyboard instantiateViewControllerWithIdentifier:viewControllerID];
    
    popoverVC.viewType=0;
    popoverVC.viewObject = currCell.imgNewBoard.image;
    
    UIPopoverController* popoverSelectedBoard = [[UIPopoverController alloc]initWithContentViewController:popoverVC];
    
    [popoverSelectedBoard delegate];
    
    [popoverVC.view center];
    
    
    int XX = currCell.frame.origin.x; //(_viewSize.width - 400)/2;
    int YY = 100 ; //currCell.frame.origin.y;  //(_viewSize.height - 300)/2;
    
    popoverSelectedBoard.popoverContentSize = CGSizeMake(400, 300);  //controller.view.frame.size ; //CGSizeMake (325, 425); //your custom size.

    [popoverSelectedBoard presentPopoverFromRect:CGRectMake(XX,YY,10,10) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
    
    
    
    
    
    
    
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
    NewBoardOptions_class* currCell_class = [_arrayOfNewBoardOptions objectAtIndex:indexPath.row];
    _boardSelectedbyUser.brdRows = [NSNumber numberWithInt:currCell_class.rows];
    _boardSelectedbyUser.brdCols = [NSNumber numberWithInt:currCell_class.cols];
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    // Adjust cell size for orientation
//    if (UIDeviceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
//        return CGSizeMake(170.f, 170.f);
//    }
//    return CGSizeMake(192.f, 192.f);



//    NewBoardOptionsCell_collectionviewCell* currCell= (NewBoardOptionsCell_collectionviewCell*)[colNewBoardOptions cellForItemAtIndexPath:indexPath];
    CGSize cellSize;
    if (self.view.tag == 99) {
       // [currCell setFrame:CGRectMake(currCell.frame.origin.x, currCell.frame.origin.y, colNewBoardOptions.frame.size.width, 100)];
       // [currCell.imgNewBoard setFrame:CGRectMake(0, 0, currCell.frame.size.width, currCell.frame.size.height)];
        cellSize= CGSizeMake(100, 100);
    }
    else{
        //currCell.frame = CGRectMake(currCell.frame.origin.x, currCell.frame.origin.y, 300, 300);
        cellSize= CGSizeMake(200, 200);
    }

    return cellSize;
}



#pragma mark MiscFunctions

- (IBAction)btnLoadExistingBoard:(UIButton *)sender {
    
    NSLog(@"show List of Boards+SearchBar");
    [self.popover dismissPopoverAnimated:TRUE];
    
    [self showListOfExisitingBoards:sender];
    
}



-(void)showListOfExisitingBoards:(NSObject*)sender
{
    NSLog(@"showListOfExisitingBoards");
    
    if ([sender isKindOfClass:[UIButton class]]) {
        UIButton* btn = (UIButton*)sender;
        ListofObjects_tableviewcontroller *controller = [[ListofObjects_tableviewcontroller alloc] init];
        controller.showImages = NO;
        controller.showBoards = YES;
        UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:controller];
        popover.delegate = (id)self;
        
        [popover presentPopoverFromRect:CGRectMake(btn.frame.origin.x,btn.frame.origin.y,10,10) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        
    }
    else
        NSLog(@"showListOfExisitngBoards-ERROR");
    
}

-(void)doLoadNewBoard
{
   
//    BoardsList_class* savedBoard =  [self saveboard];
//    if (self.view.tag == 99) {// means the NewBoard is shown from cellProperties
//        
//        // -------------
//        NSLog(@"NewBoardOptions - Cell Properties - doLoadNewBoard");
//        NSNotificationCenter* notificationCenter = [NSNotificationCenter defaultCenter];
//        [notificationCenter postNotificationName:@"boardfromlist4link" object:savedBoard];
//        [self.navigationController popToRootViewControllerAnimated:YES];
//        // --------------
//        
//    }
//    else{
//        
//        NSLog(@"NewBoardOptions - Main Screen - doLoadNewBoard");
//        BoardsList_class* board4Loading = savedBoard;//(BoardsList_class*)notification.object;
//        EditBoard_viewcontroller* editboardVC = [self.storyboard instantiateViewControllerWithIdentifier:@"editboard"];
//        editboardVC.board4Load = board4Loading;
//        
//        NSLog(@"user choosed board using cellProperties - %@",board4Loading.brdFileName);
//        
//        [self.navigationController pushViewController:editboardVC animated:YES];
//    }
}

// notification for choosing new board from main screen
-(void)notificationUserDidSelectBoardFromList : (NSNotification*) notification
{
    
    BoardsList_class* board4Loading = (BoardsList_class*)notification.object;
    
    if (self.view.tag == 99) {// means the NewBoard is shown from cellProperties
        
        NSLog(@"NewBoardOptions - Cell Properties - notificationUserDidSelectBoardFromList");
        // -------------
        
        NSNotificationCenter* notificationCenter = [NSNotificationCenter defaultCenter];
        [notificationCenter postNotificationName:@"boardfromlist4link" object:board4Loading];
        [self.navigationController popToRootViewControllerAnimated:YES];
        // --------------
        
    }
    else{
        
        NSLog(@"NewBoardOptions - MainScreen - notificationUserDidSelectBoardFromList");
        [self.popover dismissPopoverAnimated:TRUE];
        NSNotificationCenter* notificationcenter = [NSNotificationCenter defaultCenter];
        [notificationcenter postNotificationName:@"dismisspopover" object:@"notificationUserDidSelectBoardFromList"];
        
        EditBoard_viewcontroller* editboardVC = [self.storyboard instantiateViewControllerWithIdentifier:@"editboard"];
        editboardVC.board4Load = board4Loading;
        NSLog(@"user choosed board using cellProperties - %@",board4Loading.brdFileName);
        
        [self.navigationController pushViewController:editboardVC animated:YES];
    }
}

-(void)notificationUserDidChoosedNewBoard:(NSNotification*)notification
{
    
    _boardSelectedbyUser.brdName = [[(NSArray*)notification.object objectAtIndex:0] text];
    
    
    BoardsList_class* savedBoard =  [self saveboard];
    if (self.view.tag == 99) {// means the NewBoard is shown from cellProperties
        
        // -------------
        NSLog(@"NewBoardOptions - Cell Properties - doLoadNewBoard");
        NSNotificationCenter* notificationCenter = [NSNotificationCenter defaultCenter];
        [notificationCenter postNotificationName:@"boardfromlist4link" object:savedBoard];
        [self.navigationController popToRootViewControllerAnimated:YES];
        // --------------
        
    }
    else{
        
        NSLog(@"NewBoardOptions - Main Screen - doLoadNewBoard");
        BoardsList_class* board4Loading = savedBoard;//(BoardsList_class*)notification.object;
        EditBoard_viewcontroller* editboardVC = [self.storyboard instantiateViewControllerWithIdentifier:@"editboard"];
        editboardVC.board4Load = board4Loading;
        
        NSLog(@"user choosed board using cellProperties - %@",board4Loading.brdFileName);
        
        [self.navigationController pushViewController:editboardVC animated:YES];
    }

}

-(void)createToolBar
{
    
    // declare frame of uitoolbar
    
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    toolbar.frame = CGRectMake(0, 0, 300, 44);
    UIBarButtonItem *button1 = [[UIBarButtonItem alloc] initWithTitle:@"Send" style:UIBarButtonItemStyleDone target:self action:@selector(sendAction)];
    
    UIBarButtonItem *button2=[[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(cancelAction)];
    
    [toolbar setItems:[[NSArray alloc] initWithObjects:button1,button2, nil]];
    [self.view addSubview:toolbar];
    
    
    
}

//-(void)dismissKeyboardOnScreen
//{
//
//    if (_flgKeyboardOnScreen ) {
//        [[self view] endEditing:TRUE];
//        _flgKeyboardOnScreen = FALSE;
//    }
//
//
//
//}

#pragma mark TEXTFieldDelegate


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    _boardSelectedbyUser.brdName = textField.text;
    NSLog(@"textFieldDidEndEditing:");
    [textField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"textFieldShouldReturn:");
    _boardSelectedbyUser.brdName = textField.text;
    [textField resignFirstResponder];
    
    return  TRUE;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return TRUE;
}

- (void)textViewDidChange:(UITextView *)textView{
    NSLog(@"textViewDidChange:");
}

- (void)textViewDidChangeSelection:(UITextView *)textView{
    NSLog(@"textViewDidChangeSelection:");
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    
    [textView setText:@""];
    NSLog(@"textViewShouldBeginEditing:");
    return YES;
}


-(void)arrangeObjectsOnScreen:(int)tag
{
    
    
    float WW = _viewSize.width;
    float HH = _viewSize.height;
    float lblWidth = 250;
    float lblHeight = 30;
    float X,Y,W,H;
    
    switch (tag) {
        case 99:
            
            _viewSize = self.parentViewController.view.frame.size;
            
            X = (_viewSize.width-lblWidth)-20;
            Y = 30;
            [lbl_Message setFrame:CGRectMake( X, Y, lblWidth, lblHeight)];
            lbl_Message.minimumScaleFactor=0.7;
            
            X=20;
            Y=lbl_Message.frame.origin.y+lbl_Message.frame.size.height+10;
            
            W = _viewSize.width-40;
            
            // H = _viewSize.height-self.navigationController.navigationBar.frame.size.height - 50;
            H = (_viewSize.height-self.navigationController.navigationBar.frame.size.height) / 2;
            
            
            [colNewBoardOptions setFrame:CGRectMake(X, Y, W, H)];
            
            [colNewBoardOptions.collectionViewLayout invalidateLayout];
            
            
            //set button load existing boards
            X = (WW-btnLoadExistingBoard.frame.size.width)-50;
            Y = colNewBoardOptions.frame.origin.y+colNewBoardOptions.frame.size.height+100;
            btnLoadExistingBoard.frame = CGRectMake( X, Y, btnLoadExistingBoard.frame.size.width, btnLoadExistingBoard.frame.size.height);
            
            
            break;
            
        default:
            
            
            
            X = (WW-lblWidth)-50;Y = 100; //(HH-lblHeight);
            [lbl_Message setFrame:CGRectMake( X, Y, lblWidth, lblHeight)];
            lbl_Message.minimumScaleFactor=0.7;
            NSLog(@"lblMessage size W-%f H-%f", lbl_Message.frame.size.width,lbl_Message.frame.size.height);
            
            // set collection view size
            X=50;
            Y=lbl_Message.frame.origin.y+lbl_Message.frame.size.height+30;
            
            int W = WW-100;
            
            int H = HH-300;
            
            colNewBoardOptions.frame = CGRectMake(X, Y, W, H);
            
            //set button load existing boards
            X = (WW-btnLoadExistingBoard.frame.size.width)-50;
            Y = colNewBoardOptions.frame.origin.y+colNewBoardOptions.frame.size.height+100;
            btnLoadExistingBoard.frame = CGRectMake( X, Y, btnLoadExistingBoard.frame.size.width, btnLoadExistingBoard.frame.size.height);
            
            break;
    }
    
    
    
    
    
    
}

-(void)notificationKeyboardOnScreen
{
    _flgKeyboardOnScreen = TRUE;
}

-(void)notificationDismissPopover:(NSNotification*) notification
{
    NSLog(@"dismiss popup menu");
    
    NSObject* obj = notification.object;
    NSLog(@"notification.object = %@",obj.description);
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)createNavigationBar
{
    //UINavigationItem* btnDone = [[UINavigationItem alloc]init];
    // [btnDone setTitle:@"Done"];
    UINavigationBar* nav = [[UINavigationBar alloc]init];
    [self.view addSubview:nav];
    //
    //    UIBarButtonItem* btnDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(createLinktoNewBoard)];
    //
    //
    //    nav.navigationItem.rightBarButtonItem = btnDone;
    
}

-(BoardsList_class*)saveboard//:(int)rows and:(int)cols
{
    
    BoardsList_class* newBoard = [[BoardsList_class alloc]init];
    [self initBoard];
    int Rows = [_boardSelectedbyUser.brdRows intValue];
    int Cols = [_boardSelectedbyUser.brdCols intValue];
    
    [self mergeCells_auto_withNumOfRows:Rows andwithNumOfCols:Cols];
    
    
    
    //    [EasyAlertView showWithTitle:BOARD_ALERT_TITLE message:@"Save Board as" alertStyle:UIAlertViewStylePlainTextInput usingBlock:^(NSUInteger buttonIndex, NSMutableArray* inpText)
    //     {
    
    
    //new board
    // _boardSelectedbyUser.brdName = [_globalsFuncs repairString4UseAsFilename:[inpText objectAtIndex:0]];
    // _boardSelectedbyUser.brdCols=[NSNumber numberWithInt:cols];
    // _boardSelectedbyUser.brdRows=[NSNumber numberWithInt:rows];
    _boardSelectedbyUser.brdCreatedBy = @"admin";
    _boardSelectedbyUser.brdCreatedDate = [NSDate date];
    _boardSelectedbyUser.brdLastUpdatedBy=@"admin";
    _boardSelectedbyUser.brdLastUpdateDate=[NSDate date];
    _boardSelectedbyUser.brdUserID=9999;
    
    // read the existing boardID
    _boardSelectedbyUser.brdID  = [[[NSUserDefaults standardUserDefaults] valueForKey:@"BoardIndex"] intValue];
    // +1
    _boardSelectedbyUser.brdID++;
    
    //put it back in userDefaluts
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInt:_boardSelectedbyUser.brdID] forKey:@"BoardIndex"];
    
    // save userDefaults
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    
    
    newBoard.brdDate = [NSDate date];
    //to do - open dlgbox and let user to set a personal icon for his main board
    // there will be a folder containg the icons.
    newBoard.brdIcon = @"stars.png";
    newBoard.brdFileName = _boardSelectedbyUser.brdName;
    
    int flgBoardExistsAtIndex=-1;
    
    // if (buttonIndex == 0) {
    // check if there is allready a board with the same name
    for (int i=0;i<[_appDelegate.arrayOfBoards count] ;i++)
    {
        BoardsList_class* brdX = [[BoardsList_class alloc]init];
        brdX = [_appDelegate.arrayOfBoards objectAtIndex:i];
        if ([brdX.brdFileName isEqualToString:_boardSelectedbyUser.brdName]) {
            flgBoardExistsAtIndex=i;
        }
    }
    
    if (flgBoardExistsAtIndex>=0) {
        //if file exists, overwrite it
        
      //  _boardSelectedbyUser.brdName = [NSString stringWithFormat:@"%@ (copy)",_boardSelectedbyUser.brdName];
    }
    //                 [EasyAlertView showWithTitle:BOARD_ALERT_TITLE message:@"Board with this name already exists."alertStyle:UIAlertViewStyleDefault usingBlock:^(NSUInteger buttonIndex, NSMutableArray* inpText)
    //                  {
    //                      if (buttonIndex == 0) { //user wants to replace existing board
    //
    //                          [_appDelegate.arrayOfBoards replaceObjectAtIndex:flgBoardExistsAtIndex withObject:_boardSelectedbyUser];
    //
    //
    //                          // save the board file containing the actuall data - board info + cells info
    //                          //  NSMutableArray* arrayData4Save  = [[NSMutableArray alloc]initWithObjects:boardSelectedbyUser, nil];
    //                          NSMutableArray* arrayData4Save  = [[NSMutableArray alloc]initWithObjects:newBoard, nil];
    //                          //[arrayData4Save addObjectsFromArray:_arrayOfCells];
    //                          [arrayData4Save addObjectsFromArray:_matrixOfCells];
    //
    //                          XMLmanager_class* xmlManager = [[XMLmanager_class alloc]init];
    //                          [xmlManager createBoardLocalXMLfilewithComment:@"Board" withData:arrayData4Save andwithBoardName:newBoard.brdFileName];//] stringByTrimmingCharactersInSet:
    //                          // [NSCharacterSet whitespaceCharacterSet]]];
    //
    //                          // update file boards_list.xml
    //                          XMLmanager_class* xmlCreateBoardList = [[XMLmanager_class alloc]init];
    //                          [xmlCreateBoardList createBoardsList_localXMLfile:@"boards_list.xml" andwith:_appDelegate.arrayOfBoards];
    //
    //                          //                          // -------------
    //                          //                          Board_class* boardLinked = _boardSelectedbyUser;
    //                          //                          [self.navigationController popToRootViewControllerAnimated:YES];
    //                          //                          NSNotificationCenter* notificationCenter = [NSNotificationCenter defaultCenter];
    //                          //                          [notificationCenter postNotificationName:@"boardfromlist4link" object:boardLinked];
    //                          //                          // --------------
    //
    //                      }
    //
    //                  }
    //                            cancelButtonTitle:@"Overwrite"
    //                            otherButtonTitles:@"Cancel", nil];
    //             }
    //             else{
    
    // save the board file containing the actuall data - board info + cells info
    NSMutableArray* arrayData4Save  = [[NSMutableArray alloc]initWithObjects:_boardSelectedbyUser, nil];
    [arrayData4Save addObjectsFromArray:_matrixOfCells];
    XMLmanager_class* xmlManager = [[XMLmanager_class alloc]init];
    [xmlManager createBoardLocalXMLfilewithComment:@"Board" withData:arrayData4Save andwithBoardName:newBoard.brdFileName];
    
    //add the new board to arrayOfBoards array
    [_appDelegate.arrayOfBoards addObject:newBoard];
    
    // update file boards_list.xml
    XMLmanager_class* xmlCreateBoardList = [[XMLmanager_class alloc]init];
    [xmlCreateBoardList createBoardsList_localXMLfile:@"boards_list.xml" andwith:_appDelegate.arrayOfBoards];
    
    //                 // -------------
    //                 Board_class* boardLinked = _boardSelectedbyUser;
    //                 [self.navigationController popToRootViewControllerAnimated:YES];
    //                 NSNotificationCenter* notificationCenter = [NSNotificationCenter defaultCenter];
    //                 [notificationCenter postNotificationName:@"boardfromlist4link" object:boardLinked];
    //                 // --------------
    
    
    //             }
    //         }
    //     }
    //               cancelButtonTitle:@"Save"
    //               otherButtonTitles:@"Cancel", nil];
    
    
    
    return newBoard;
    
    
}

-(void)initBoard
{
    //todo - this VC and EditBoard VC uses the same initboard and merhe cell.
    //todo - I have to make those modules general.
    
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
            // [_arrayOfCells addObject:cellZ];
            
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
    
    //    [_globalFuncs PrintOut_array:_arrayOfCells showXY:NO showMARK:YES];
    //    [_globalFuncs PrintOut_matrix:_matrixOfCells showIndex:NO showMark:YES];
    //
    
    
}

@end
