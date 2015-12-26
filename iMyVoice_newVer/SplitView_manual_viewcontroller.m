//
//  SplitView_manual_viewcontroller.m
//  iMyVoice_newVer
//
//  Created by Simona Tzalik on 11/13/15.
//  Copyright © 2015 Techno M.A.G. All rights reserved.
//

#import "SplitView_manual_viewcontroller.h"
#import "Globals.h"
#import "GlobalsFunctions_class.h"
#import "EditCell_BASIC_viewcontroller.h"
#import "EditCell_FONTS_viewcontroller.h"


@interface SplitView_manual_viewcontroller () <UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate>
@property NSArray* arrayMenuItems;
@property UIToolbar* toolbar;
@property UINavigationController* navController;
@property CGRect rectDetails;

@property UIViewController* editBasic_VC;
@property UIViewController* editFonts_VC;
@property UIViewController* editLinks_VC;
@property UIViewController* editMessage_VC;
@property UIViewController* editFrame_VC;


@end

@implementation SplitView_manual_viewcontroller
@synthesize tblMenu,cellEditProperties,tempCellProperties;

//-(id)init{
//  self = [super init];
//    
//    self.cellEditProperties = [[Cell_class alloc]init];
//    self.tempCellProperties = [[Cell_class alloc]init];
//    return self ;
//}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    tempCellProperties = [[Cell_class alloc]init];
    [self updateTempCellPropertes];
    
    _arrayMenuItems = [[NSArray alloc]initWithObjects:@"Basic",@"Fonts",@"Links",@"Messages",@"Frame and Background", nil];
    _toolbar = [[UIToolbar alloc]init];
    [self loadViewControllers];
    _navController = [[UINavigationController alloc]init];
    [self addChildViewController:_navController];
    [self.view addSubview:_navController.view];          // 2
    [_navController didMoveToParentViewController:self];
 
    [tblMenu setDelegate:self];
    [tblMenu setDataSource:self];
    
    
   
   
    
    [_navController showViewController:_editBasic_VC sender:self];
    
    [tblMenu reloadData];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
   
    
//    [_toolbar setFrame:CGRectMake(0, 0, self.view.frame.size.width, TOOLBARHIGH)];
//    UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
//    
//    UIBarButtonItem *flexibleSpaceButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    
//    UIBarButtonItem *doneButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction  target:self action:@selector(done)];
//    
//    _toolbar.items = [NSArray arrayWithObjects:cancelButtonItem,flexibleSpaceButtonItem, doneButtonItem, nil];
//    
//    _toolbar.backgroundColor = [UIColor lightGrayColor];
//    [self.view addSubview:_toolbar];
//    
//    //----------
//    
//    
//   
//    float totHeight = self.view.frame.size.height - _toolbar.frame.size.height;
//    float topY = _toolbar.frame.origin.y+_toolbar.frame.size.height;
//    
//    [tblMenu setFrame:CGRectMake(0, _toolbar.frame.size.height, self.view.frame.size.width /4.5, totHeight)];
//    _rectDetails = CGRectMake(tblMenu.frame.origin.x+tblMenu.frame.size.width, topY, self.view.frame.size.width-tblMenu.frame.size.width, totHeight);
//    
//    [_navController.view setFrame:_rectDetails];
////    [_navController.view setBackgroundColor:[UIColor lightGrayColor]];
  //  [_navController pushViewController:[_navController.viewControllers objectAtIndex:0] animated:TRUE];
    
    

    
    
    
    
    
    
    
    
    
   // CGRect rectTMP = CGRectMake(160, 50, 400, 550);

    
    
//    
//    float totHeight = self.view.frame.size.height - _toolbar.frame.size.height;
//    float topY = _toolbar.frame.origin.y+_toolbar.frame.size.height;
//    
//    tblMenu.frame = CGRectMake(0,topY,self.view.frame.size.width/5,totHeight);
//    
//    [viewDetailsContainer setFrame:CGRectMake(tblMenu.frame.origin.x + tblMenu.frame.size.width, topY, self.view.frame.size.width - tblMenu.frame.size.width, totHeight)];
//    
//    
//    EditCell_BASIC_viewcontroller* editBasic_VC = [[EditCell_BASIC_viewcontroller alloc]init];
    
//        NSString * storyboardName = @"SplitView";
//        NSString * viewControllerID = @"navcontroller";
//        UIStoryboard * storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
//        UINavigationController*  navController = (UINavigationController*)[storyboard instantiateViewControllerWithIdentifier:viewControllerID];
//    
//    [navController setViewControllers:[NSArray arrayWithObject:editBasic_VC] animated:TRUE];
//    navController.navigationBar.backgroundColor = [UIColor blueColor];
    
    //    [_navController initWithRootViewController:editBasic_VC];
    
   
  // UINavigationController* navController = (UINavigationController*) [viewDetailsContainer.subviews objectAtIndex:1];
    
     
     
   //  [navController setViewControllers:[NSArray arrayWithObject:editBasic_VC] animated:TRUE];
   // [self.navigationController pushViewController:self.fakeRootViewController animated:NO];
    // [self.navigationController pushViewController:editBasic_VC animated:YES];
    
  //  [self.navigationController pushViewController:editBasic_VC animated:TRUE];
   // self.navigationController.navigationBar.backgroundColor = [UIColor blueColor];
   // [self.navigationController.view setFrame:CGRectMake(tblMenu.frame.origin.x + tblMenu.frame.size.width, topY, self.view.frame.size.width - tblMenu.frame.size.width, totHeight)];

    
  
}

-(void)viewDidAppear:(BOOL)animated
{
   
    
    // select the row 0 - Basic
    [tblMenu.delegate tableView:tblMenu didSelectRowAtIndexPath:0];
    
    
//    [_toolbar setFrame:CGRectMake(0, 0, self.view.frame.size.width, TOOLBARHIGH)];
//    UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
//    
//    UIBarButtonItem *flexibleSpaceButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    
//    UIBarButtonItem *doneButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction  target:self action:@selector(done)];
//    
//    _toolbar.items = [NSArray arrayWithObjects:cancelButtonItem,flexibleSpaceButtonItem, doneButtonItem, nil];
//    
//    _toolbar.backgroundColor = [UIColor lightGrayColor];
//    [self.view addSubview:_toolbar];
//    
//    //----------
//    
//    
//    
//    float totHeight = self.view.frame.size.height - _toolbar.frame.size.height;
//    float topY = _toolbar.frame.origin.y+_toolbar.frame.size.height;
//    
//    [tblMenu setFrame:CGRectMake(0, _toolbar.frame.size.height, self.view.frame.size.width /4.5, totHeight)];
//    _rectDetails = CGRectMake(tblMenu.frame.origin.x+tblMenu.frame.size.width, topY, self.view.frame.size.width-tblMenu.frame.size.width, totHeight);
//    
//    [_navController.view setFrame:_rectDetails];
//    //    [_navController.view setBackgroundColor:[UIColor lightGrayColor]];
//    //  [_navController pushViewController:[_navController.viewControllers objectAtIndex:0] animated:TRUE];
//    
//    
//    
//    
//    
    
    
    
    
    
    
    
    // CGRect rectTMP = CGRectMake(160, 50, 400, 550);
    
    
    
    //
    //    float totHeight = self.view.frame.size.height - _toolbar.frame.size.height;
    //    float topY = _toolbar.frame.origin.y+_toolbar.frame.size.height;
    //
    //    tblMenu.frame = CGRectMake(0,topY,self.view.frame.size.width/5,totHeight);
    //
    //    [viewDetailsContainer setFrame:CGRectMake(tblMenu.frame.origin.x + tblMenu.frame.size.width, topY, self.view.frame.size.width - tblMenu.frame.size.width, totHeight)];
    //
    //
    //    EditCell_BASIC_viewcontroller* editBasic_VC = [[EditCell_BASIC_viewcontroller alloc]init];
    
    //        NSString * storyboardName = @"SplitView";
    //        NSString * viewControllerID = @"navcontroller";
    //        UIStoryboard * storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    //        UINavigationController*  navController = (UINavigationController*)[storyboard instantiateViewControllerWithIdentifier:viewControllerID];
    //
    //    [navController setViewControllers:[NSArray arrayWithObject:editBasic_VC] animated:TRUE];
    //    navController.navigationBar.backgroundColor = [UIColor blueColor];
    
    //    [_navController initWithRootViewController:editBasic_VC];
    
    
    // UINavigationController* navController = (UINavigationController*) [viewDetailsContainer.subviews objectAtIndex:1];
    
    
    
    //  [navController setViewControllers:[NSArray arrayWithObject:editBasic_VC] animated:TRUE];
    // [self.navigationController pushViewController:self.fakeRootViewController animated:NO];
    // [self.navigationController pushViewController:editBasic_VC animated:YES];
    
    //  [self.navigationController pushViewController:editBasic_VC animated:TRUE];
    // self.navigationController.navigationBar.backgroundColor = [UIColor blueColor];
    // [self.navigationController.view setFrame:CGRectMake(tblMenu.frame.origin.x + tblMenu.frame.size.width, topY, self.view.frame.size.width - tblMenu.frame.size.width, totHeight)];
    
    

}

-(void)viewWillLayoutSubviews
{
    
    NSString* viewTitle = @"Cell properties";
    
    
    [_toolbar setFrame:CGRectMake(0, 0, self.view.frame.size.width, TOOLBARHIGH)];
    UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(toolbarCancel)];
    
    UIBarButtonItem *flexibleSpaceButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [flexibleSpaceButtonItem setTitle:viewTitle];
    
    
    UIBarButtonItem *doneButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone  target:self action:@selector(toolbarDone)];

    
   // UIBarButtonItem *doneButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction  target:self action:@selector(done)];
    
    _toolbar.items = [NSArray arrayWithObjects:cancelButtonItem,flexibleSpaceButtonItem, doneButtonItem, nil];
    
    _toolbar.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:_toolbar];
    
    //----------
    
    
    
    float totHeight = self.view.frame.size.height - _toolbar.frame.size.height;
    float topY = _toolbar.frame.origin.y+_toolbar.frame.size.height;
    
    [tblMenu setFrame:CGRectMake(0, _toolbar.frame.size.height, self.view.frame.size.width /2.5, totHeight)];
    _rectDetails = CGRectMake(tblMenu.frame.origin.x+tblMenu.frame.size.width, topY, self.view.frame.size.width-tblMenu.frame.size.width, totHeight);
    
    [_navController.view setFrame:_rectDetails];
    //    [_navController.view setBackgroundColor:[UIColor lightGrayColor]];
    //  [_navController pushViewController:[_navController.viewControllers objectAtIndex:0] animated:TRUE];
    
    
    
    
    
    
    
    
    
    
    
    
    // CGRect rectTMP = CGRectMake(160, 50, 400, 550);
    
    
    
    //
    //    float totHeight = self.view.frame.size.height - _toolbar.frame.size.height;
    //    float topY = _toolbar.frame.origin.y+_toolbar.frame.size.height;
    //
    //    tblMenu.frame = CGRectMake(0,topY,self.view.frame.size.width/5,totHeight);
    //
    //    [viewDetailsContainer setFrame:CGRectMake(tblMenu.frame.origin.x + tblMenu.frame.size.width, topY, self.view.frame.size.width - tblMenu.frame.size.width, totHeight)];
    //
    //
    //    EditCell_BASIC_viewcontroller* editBasic_VC = [[EditCell_BASIC_viewcontroller alloc]init];
    
    //        NSString * storyboardName = @"SplitView";
    //        NSString * viewControllerID = @"navcontroller";
    //        UIStoryboard * storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    //        UINavigationController*  navController = (UINavigationController*)[storyboard instantiateViewControllerWithIdentifier:viewControllerID];
    //
    //    [navController setViewControllers:[NSArray arrayWithObject:editBasic_VC] animated:TRUE];
    //    navController.navigationBar.backgroundColor = [UIColor blueColor];
    
    //    [_navController initWithRootViewController:editBasic_VC];
    
    
    // UINavigationController* navController = (UINavigationController*) [viewDetailsContainer.subviews objectAtIndex:1];
    
    
    
    //  [navController setViewControllers:[NSArray arrayWithObject:editBasic_VC] animated:TRUE];
    // [self.navigationController pushViewController:self.fakeRootViewController animated:NO];
    // [self.navigationController pushViewController:editBasic_VC animated:YES];
    
    //  [self.navigationController pushViewController:editBasic_VC animated:TRUE];
    // self.navigationController.navigationBar.backgroundColor = [UIColor blueColor];
    // [self.navigationController.view setFrame:CGRectMake(tblMenu.frame.origin.x + tblMenu.frame.size.width, topY, self.view.frame.size.width - tblMenu.frame.size.width, totHeight)];
    
    

}

-(void)loadViewControllers
{
    NSString*  storyboardName = @"SplitView";
    NSString*  viewControllerID = @"edit_basic";
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    _editBasic_VC = (UINavigationController *)[storyboard instantiateViewControllerWithIdentifier:viewControllerID];
    
    storyboardName = @"SplitView";
    viewControllerID = @"edit_fonts";
    storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    _editFonts_VC = (UINavigationController *)[storyboard instantiateViewControllerWithIdentifier:viewControllerID];
    
    storyboardName = @"SplitView";
    viewControllerID = @"edit_links";
    storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    _editLinks_VC = (UINavigationController *)[storyboard instantiateViewControllerWithIdentifier:viewControllerID];
   
    storyboardName = @"SplitView";
    viewControllerID = @"edit_message";
    storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    _editMessage_VC = (UINavigationController *)[storyboard instantiateViewControllerWithIdentifier:viewControllerID];
    
    storyboardName = @"SplitView";
    viewControllerID = @"edit_frame";
    storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    _editFrame_VC = (UINavigationController *)[storyboard instantiateViewControllerWithIdentifier:viewControllerID];
}


-(void)updateTempCellPropertes
{
    tempCellProperties = cellEditProperties;
}



-(void)toolbarCancel
{
     NSNotificationCenter* notificationcenter = [NSNotificationCenter defaultCenter];
     [notificationcenter postNotificationName:@"dismisspopover" object:@"toolbarCancel"];

}

-(void)toolbarDone
{
    [self saveChanges];
    //call saveboard in editBoard
    NSNotificationCenter* notificationcenter = [NSNotificationCenter defaultCenter];
    [notificationcenter postNotificationName:@"saveboard" object:nil];
    
}


-(void)saveChanges
{
    if (cellEditProperties.cellBackgroundColor != tempCellProperties.cellBackgroundColor) {
        cellEditProperties.cellBackgroundColor = tempCellProperties.cellBackgroundColor;
    }
    if (cellEditProperties.cellBoardLink != tempCellProperties.cellBoardLink) {
        cellEditProperties.cellBoardLink = tempCellProperties.cellBoardLink;
    }
    
    if (cellEditProperties.cellBorderColor != tempCellProperties.cellBorderColor) {
        cellEditProperties.cellBorderColor = tempCellProperties.cellBorderColor;
    }
    
    if (cellEditProperties.cellBorderWidth != tempCellProperties.cellBorderWidth) {
        cellEditProperties.cellBorderWidth = tempCellProperties.cellBorderWidth;
    }
    
    if (cellEditProperties.cellFont  != tempCellProperties.cellFont) {
        cellEditProperties.cellFont = tempCellProperties.cellFont;
    }
    
    if (cellEditProperties.cellFontColor != tempCellProperties.cellFontColor) {
        cellEditProperties.cellFontColor = tempCellProperties.cellFontColor;
    }
    
    if (cellEditProperties.cellFontSize != tempCellProperties.cellFontSize) {
        cellEditProperties.cellFontSize = tempCellProperties.cellFontSize;
    }
    
    if (cellEditProperties.cellFontType != tempCellProperties.cellFontType) {
        cellEditProperties.cellFontType = tempCellProperties.cellFontType;
    }
    
    if (cellEditProperties.cellImageID != tempCellProperties.cellImageID) {
        cellEditProperties.cellImageID = tempCellProperties.cellImageID;
    }
    
    if (cellEditProperties.cellMessage != tempCellProperties.cellMessage) {
        cellEditProperties.cellMessage = tempCellProperties.cellMessage;
    }
    
    if (cellEditProperties.cellMP3Path != tempCellProperties.cellMP3Path) {
        cellEditProperties.cellMP3Path = tempCellProperties.cellMP3Path;
    }
    
    if (cellEditProperties.cellSoundFilename != tempCellProperties.cellSoundFilename) {
        cellEditProperties.cellSoundFilename = tempCellProperties.cellSoundFilename;
    }
    
    if (cellEditProperties.cellSoundPath != tempCellProperties.cellSoundPath) {
        cellEditProperties.cellSoundPath = tempCellProperties.cellSoundPath;
    }
    
    if (cellEditProperties.cellText != tempCellProperties.cellText) {
        cellEditProperties.cellText = tempCellProperties.cellText;
    }
    
    if (cellEditProperties.cellVIDEOPath != tempCellProperties.cellVIDEOPath) {
        cellEditProperties.cellVIDEOPath = tempCellProperties.cellVIDEOPath;
    }
    
    if (cellEditProperties.cellWEBPath != tempCellProperties.cellWEBPath) {
        cellEditProperties.cellWEBPath = tempCellProperties.cellWEBPath;
    }
    
    if (cellEditProperties.cellHidden != tempCellProperties.cellHidden) {
        cellEditProperties.cellHidden = tempCellProperties.cellHidden;
    }

    if (cellEditProperties.cellTextOnTop != tempCellProperties.cellTextOnTop) {
        cellEditProperties.cellTextOnTop = tempCellProperties.cellTextOnTop;
    }

    
    NSNotificationCenter* notificationcenter = [NSNotificationCenter defaultCenter];
    [notificationcenter postNotificationName:@"updatecellproperties" object:cellEditProperties];

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
#pragma mark TABLEVIEW delegate
#pragma mark -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrayMenuItems.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* currCell = [tableView dequeueReusableCellWithIdentifier:@"basic"];
    [currCell.textLabel setText:[_arrayMenuItems objectAtIndex:indexPath.row]];
    return currCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* currSelection = [_arrayMenuItems objectAtIndex:indexPath.row];
    
    if ([currSelection isEqualToString:@"Basic"]) {
     
        [_navController setViewControllers:[NSArray arrayWithObject:_editBasic_VC] animated:TRUE];
    }

    if ([currSelection isEqualToString:@"Fonts"]) {
       
        [_navController setViewControllers:[NSArray arrayWithObject:_editFonts_VC] animated:TRUE];
     }
    
    if ([currSelection isEqualToString:@"Links"]) {
        
        [_navController setViewControllers:[NSArray arrayWithObject:_editLinks_VC] animated:TRUE];
    }
    
    if ([currSelection isEqualToString:@"Messages"]) {
        
        [_navController setViewControllers:[NSArray arrayWithObject:_editMessage_VC] animated:TRUE];
    }

    if ([currSelection isEqualToString:@"Frame and Background"]) {
        
        [_navController setViewControllers:[NSArray arrayWithObject:_editFrame_VC] animated:TRUE];
    }

}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;
{
    
    return @"Cell Properties";
    
    
    
}


@end
