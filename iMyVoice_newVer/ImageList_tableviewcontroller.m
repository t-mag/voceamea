//
//  ImageList_tableviewcontroller.m
//  iMyVoice_newVer
//
//  Created by Simona Tzalik on 13/6/15.
//  Copyright (c) 2015 Techno M.A.G. All rights reserved.
//

#import "ImageList_tableviewcontroller.h"
#import "AppDelegate.h"
#import "Globals.h"
#import "ImageList_TableViewCell.h"
#import "Images_class.h"

@interface ImageList_tableviewcontroller () <UITableViewDataSource,UITableViewDelegate,UISearchDisplayDelegate,UISearchBarDelegate>


@property AppDelegate* appDelegate;

@end


@implementation ImageList_tableviewcontroller
@synthesize isSearching,letUserSelectRow,arraySearchResults;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _appDelegate = DELEGATE;
   _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(1,5, IMAGELIST_VIEW_SIZE_W, 30)];
   _tblImageList = [[UITableView alloc]initWithFrame:CGRectMake(1,_searchBar.frame.origin.y+_searchBar.frame.size.height+1,IMAGELIST_VIEW_SIZE_W,IMAGELIST_VIEW_SIZE_H-_searchBar.frame.size.height)];
    
   
    
    [_searchBar setDelegate:self];
    [_tblImageList setDelegate:self];
    [_tblImageList setDataSource:self];
    [self.view addSubview:_searchBar];
    [self.view addSubview:_tblImageList];

    arraySearchResults = [[NSMutableArray alloc]init];
    
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
   // self.view.frame= CGRectMake(0, 0, IMAGELIST_VIEW_SIZE_W-5, IMAGELIST_VIEW_SIZE_H-5);
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - from iMyvoice OLD
#pragma mark - Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isSearching)
        return [arraySearchResults count];
    else
        return [_appDelegate.arrayOfImages count]; //(isImageShowing?[onlyImages count]:[onlySounds count]);
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
     static NSString *cellIdentifier = @"custom";

    // the line below comes instead of setting the name of the reusableIdentifer that we give at design time on mainstoryboard
    [_tblImageList registerClass:[ImageList_TableViewCell class] forCellReuseIdentifier:cellIdentifier];
    // then continue as ussual
    // ---------------------------
    ImageList_TableViewCell* currCell = [_tblImageList dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    NSLog([NSString stringWithFormat:@"%ld",(long)indexPath.row]);
    
    if (currCell == nil) {
        currCell = [[ImageList_TableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
           }
    
    NSString* strFileName ;
    Images_class* imgX = [[Images_class alloc]init];
    
    if(isSearching) //if(_tblImageList == self.searchDisplayController.searchResultsTableView)
    {
        imgX= arraySearchResults[indexPath.row];
        strFileName = imgX.imgShowName;
    }
    else{
        imgX = _appDelegate.arrayOfImages[indexPath.row];
        strFileName = imgX.imgShowName;
    }
    
   
    
    
    imgX.imgPath = [imgX.imgPath stringByExpandingTildeInPath];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:imgX.imgPath];
    if (fileExists) {
        currCell.imgSymbol.image = [UIImage imageWithContentsOfFile:imgX.imgPath];
        [currCell.lblImageShowName setText:[NSString stringWithFormat:@"%@",strFileName]];
    }
    NSLog([NSString stringWithFormat:@"%d",isSearching]);
   
    NSLog(currCell.lblImageShowName.text);
    return currCell;
//
//        UIGraphicsBeginImageContext(CGSizeMake(40, 40));
//        [img drawInRect:CGRectMake(0, 0, 40, 40)];
//        UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//        
//        [[cell imageView] setImage: scaledImage];
   }


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (_delegate != nil)
//    {
//        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//        
//        if (isImageShowing == YES)
//            // [_delegate changeTileImage: [cell textLabel].text];
//            NSLog(@"(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath");
//        else
//        {
//            
//            [_delegate changeTileSound: [cell textLabel].text];
//        }
//        
//        if (isNav == YES)
//            [self.navigationController popViewControllerAnimated: YES];
//    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    //MyVoiceAppDelegate *appDelegate = (MyVoiceAppDelegate *)[[UIApplication sharedApplication] delegate];
    
  //  if (isImageShowing == YES)
        return @"Choose a Symbol"; //[appDelegate myLocalizedString: @"Cells Images"];
//    else
//        return @"Choose a Sound"; //[appDelegate myLocalizedString: @"Cells Sounds" ];
}


#pragma mark - SearchBar Delegate



//- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar;                       // called when text ends editing



//- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar;                     // called when cancel button pressed


- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar  // called when text starts editing
{
    isSearching = YES;
    letUserSelectRow = NO;
    //self.ImageSoundListTable.scrollEnabled = YES;
    _tblImageList.scrollEnabled=YES;
    
    //  self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemDone target:self action:@selector(doneSearching_Clicked:)] autorelease];
  //  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemDone target:self action:@selector(doneSearching_Clicked:)];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText // called when text changes (including clear)
{
    //[copyListOfItems removeAllObjects];
    [arraySearchResults removeAllObjects];
    
    if ([searchText length] > 0)
    {
        isSearching = YES;
        letUserSelectRow = YES;
        //self.ImageSoundListTable.scrollEnabled = YES;
         _tblImageList.scrollEnabled=YES;
        [self searchTableView:searchBar];
    }
    else
    {
        isSearching = NO;
        letUserSelectRow = NO;
        //self.ImageSoundListTable.scrollEnabled = YES;
         _tblImageList.scrollEnabled=YES;
    }
    
   // [self.ImageSoundListTable reloadData];
    [_tblImageList reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar  // called when keyboard search button pressed
{
    [self searchTableView:searchBar];
}

- (void)searchTableView:(UISearchBar*)searchBar
{
   
    
// //   if (isImageShowing){
//        for (NSString *sTemp in _appDelegate.arrayOfImages)
//        {
//            [searchArray addObject: sTemp];
//            
//        }
//    }else{
//        for (NSString *sTemp in onlySounds)
//        {
//            [searchArray addObject: sTemp];
//        }
//    }
    
    NSString *searchText =  searchBar.text;
   // NSMutableArray *searchArray = [[NSMutableArray alloc] init];
    
//    for (NSString *sTemp in _appDelegate.arrayOfImages)
//    {
//        [searchArray addObject: sTemp];
//        
//    }

    
    for (Images_class *sTemp in _appDelegate.arrayOfImages)
    {
        NSRange titleResultsRange = [sTemp.imgShowName rangeOfString:searchText options:NSCaseInsensitiveSearch];
        
        if (titleResultsRange.length > 0)
        {
            [arraySearchResults addObject:sTemp];
            
        }
    }
    
    //    [searchArray release];
  //  searchArray = nil;
    
}

- (void) doneSearching_Clicked:(id)sender
{
    _searchBar.text = @"";
    [_searchBar resignFirstResponder];
    
    letUserSelectRow = YES;
    isSearching = NO;
    self.navigationItem.rightBarButtonItem = nil;
   // self.ImageSoundListTable.scrollEnabled = YES;
    _tblImageList.scrollEnabled = YES;
    
    //[self.ImageSoundListTable reloadData];
    [_tblImageList reloadData];
}






































//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}


/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
