//
//  BoardPopupmenu_tableviewcontroller.m
//  iMyVoice_newVer
//
//  Created by Simona Tzalik on 27/6/15.
//  Copyright (c) 2015 Techno M.A.G. All rights reserved.
//

#import "BoardPopupmenu_tableviewcontroller.h"
#import "AppDelegate.h"
#import "Globals.h"
#import "EditBoard_viewcontroller.h"
#import "NavTable_tableviewcontroller.h"
#import "ListofObjects_tableviewcontroller.h"

@interface BoardPopupmenu_tableviewcontroller ()<UITableViewDataSource,UITableViewDelegate>


@property AppDelegate* appDelegate;
@property UITableView* tblMenu;
@property CGSize sizeView;
//@property UINavigationController *navController;

//@property EditBoard_viewcontroller* editboardVC;

@end

@implementation BoardPopupmenu_tableviewcontroller
@synthesize arrayMenuItems,mnuMergeEnabled,mnuSplitEnabled,mnuUndoEnabled;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"BoardPopupmenu_tableviewcontroller.m viewDidLoad");
    
    _appDelegate = DELEGATE;
    _tblMenu = self.tableView;
    
    _sizeView = self.view.frame.size;

    
    
    // _navController = [[UINavigationController alloc]initWithRootViewController:self];
    
    [_tblMenu setDelegate:self];
    [_tblMenu setDataSource:self];
    
    
    
    
    
    
    
    //if the array hasn't been load with items from outside
    if (arrayMenuItems == nil) arrayMenuItems=[[NSMutableArray alloc]init];
    
    // temp
    [arrayMenuItems addObject:@"Merge Cells"];
    [arrayMenuItems addObject:@"Split Cells"];
    [arrayMenuItems addObject:@"Save Board as"];
    [arrayMenuItems addObject:@"Load Board"];
    [arrayMenuItems addObject:@"Undo last action"];
    [arrayMenuItems addObject:@"StartUp Board"];
    
    
    
}

-(void)viewDidLayoutSubviews
{
    
    //  _tblList.frame = CGRectMake(1,_searchBar.frame.origin.y+_searchBar.frame.size.height+1,_sizeView.width,_sizeView.height-_searchBar.frame.size.height);
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@"viewwillappear");
   
    
    self.navigationItem.title = @"Board Settings";
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

#pragma mark - from iMyvoice OLD
#pragma mark - Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrayMenuItems.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"custom";
    
    // the line below comes instead of setting the name of the reusableIdentifer that we give at design time on mainstoryboard
    [_tblMenu registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
    // then continue as ussual
    // ---------------------------
    
    UITableViewCell* currCell = [_tblMenu dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    
    if (currCell == nil) {
        currCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    [currCell.textLabel setText:[arrayMenuItems objectAtIndex:indexPath.row]] ;
    
    
    
    if ([[currCell.textLabel text] isEqualToString:@"Merge Cells"])
        [currCell.textLabel setEnabled:mnuMergeEnabled];
    
    if ([[currCell.textLabel text] isEqualToString:@"Split Cells"])
        [currCell.textLabel setEnabled:mnuSplitEnabled];
   
    if ([[currCell.textLabel text] isEqualToString:@"Undo last action"])
        [currCell.textLabel setEnabled:mnuUndoEnabled];
    
    if ([[currCell.textLabel text] containsString:@"StartUp Board"])
    {
        if (_appDelegate.HomepageBoard != nil) {
            NSString* str = [NSString stringWithFormat:@"%@",currCell.textLabel.text];
            NSString* brdName = [_appDelegate.HomepageBoard brdFileName];
            
            [currCell.textLabel setText:[str stringByAppendingString:[NSString stringWithFormat:@" - %@",brdName]]];
        }
        currCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
       // [self.delegate setStartupBoard];

    }
    
    if ([[currCell.textLabel text] isEqualToString:@"Load Board"])
    {
        
        currCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        // [self.delegate setStartupBoard];
        
    }

    
    return currCell;
  }


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    //send notification
    
//    NSLog(@"BoardPopupmenu_tableviewcontroller.m CALLING actiononcells");
//    NSNotificationCenter* notificationcenter = [NSNotificationCenter defaultCenter];
//    [notificationcenter postNotificationName:@"actiononcells" object:[arrayMenuItems objectAtIndex:indexPath.row]];
    
    UITableViewCell* currCell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
  
    
    if ([[currCell.textLabel text] isEqualToString:@"Merge Cells"])
        [self.delegate MergeAction];

    
    if ([[currCell.textLabel text] isEqualToString:@"Split Cells"])
         [self.delegate SplitAction];
    
    if ([[currCell.textLabel text] isEqualToString:@"Undo last action"])
        [self.delegate Undo];

    if ([[currCell.textLabel text] isEqualToString:@"Save Board as"])
        [self.delegate SaveBoardAs];

    if ([[currCell.textLabel text] isEqualToString:@"Load Board"])
    {
        
        ListofObjects_tableviewcontroller *controller = [[ListofObjects_tableviewcontroller alloc] init];
        controller.showImages = NO;
        controller.showBoards = YES;
        controller.flgSetHomePage = NO; //indicates that the selected board is for load for editing
        
        [self.navigationController pushViewController:controller animated:YES];
    }
    
    if ([[currCell.textLabel text] containsString:@"StartUp Board"])
    {
        
        ListofObjects_tableviewcontroller *controller = [[ListofObjects_tableviewcontroller alloc] init];
        controller.showImages = NO;
        controller.showBoards = YES;
        controller.flgSetHomePage = YES; //indicates that the selected board goes to set the homepageboard
       
        [self.navigationController pushViewController:controller animated:YES];
    }
        
        


   }

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    //MyVoiceAppDelegate *appDelegate = (MyVoiceAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //  if (isImageShowing == YES)
   // return @"Choose a Symbol"; //[appDelegate myLocalizedString: @"Cells Images"];
    //    else
    //        return @"Choose a Sound"; //[appDelegate myLocalizedString: @"Cells Sounds" ];
    return @"";
}

//#pragma mark -
//#pragma mark Delegate Funcs
//- (void)MergeAction {
//
//        NSLog(@"MergeAction in BoardPopupmenu_tableviewcontroller");
//    
//        //  if([self.delegate respondsToSelector:@selector(MergeAction:forCell:)]) {
//        if([self.delegate respondsToSelector:@selector(MergeAction)]) {
//            // [self.delegate MergeAction:sender forCell:self];
//            [self.delegate MergeAction];
//    //
//       }
//
//
//}


@end
