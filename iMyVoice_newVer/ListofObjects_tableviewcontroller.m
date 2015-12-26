//
//  ListofObjects_tableviewcontroller.m
//  iMyVoice_newVer
//
//  Created by Simona Tzalik on 14/6/15.
//  Copyright (c) 2015 Techno M.A.G. All rights reserved.
//

#import "ListofObjects_tableviewcontroller.h"
//#import "ImageList_tableviewcontroller.h"
#import "AppDelegate.h"
#import "Globals.h"
#import "ImageList_TableViewCell.h"
#import "Images_class.h"
#import "BoardsList_class.h"
#import "GlobalsFunctions_class.h"
#import "NewBoardOptions_viewcontroller.h"

@interface ListofObjects_tableviewcontroller ()<UITableViewDataSource,UITableViewDelegate,UISearchDisplayDelegate,UISearchBarDelegate>


@property AppDelegate* appDelegate;
@property GlobalsFunctions_class* globalsFuncs;
@property UITableView* tblList;
@property CGSize sizeView;
@property NSArray* arrayFontsList;

@end

@implementation ListofObjects_tableviewcontroller
@synthesize showImages,showBoards,showAddSymbol,isSearching,letUserSelectRow,arraySearchResults,showFontsList,searchItem;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"ListOfObjects - DidLoad");
    // Do any additional setup after loading the view.
    _appDelegate = DELEGATE;
    _globalsFuncs = [[GlobalsFunctions_class alloc]init];
    _tblList = self.tableView;
    _arrayFontsList = [[NSArray alloc]initWithArray:_globalsFuncs.getAllFontsAvailable];
    _sizeView = self.view.frame.size;
    
    
    
    [_tblList setDelegate:self];
    [_tblList setDataSource:self];
    
    _searchBar = [[UISearchBar alloc]init];
    [self.view addSubview:_searchBar];
    _searchBar.frame =CGRectMake(1,1, _sizeView.width, 40);
    if (isSearching && showImages) {
        if(![searchItem isEqualToString:@""])
        {
            
            _searchBar.text = searchItem;
        }
    }
    [_tblList setTableHeaderView:_searchBar];
    [_searchBar setDelegate:self];
    _tblList.frame = CGRectMake(1,1,_sizeView.width,_sizeView.height-_searchBar.frame.size.height);
    
    arraySearchResults = [[NSMutableArray alloc]init];
}

-(void)viewWillAppear:(BOOL)animated
{
    
    NSLog(@"ListOfObjects - viewWillAppear");
    
    if (showAddSymbol) {
        UIBarButtonItem* addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(createNewBoardFromLink)];
        
        self.navigationItem.rightBarButtonItem = addButton;
        
    }
   
    
    
}

-(void)viewDidLayoutSubviews
{
    
    //  _tblList.frame = CGRectMake(1,_searchBar.frame.origin.y+_searchBar.frame.size.height+1,_sizeView.width,_sizeView.height-_searchBar.frame.size.height);
 
    
}

-(void)viewDidAppear:(BOOL)animated
{
   
}


-(void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.preferredContentSize = CGSizeMake(_sizeView.width, _sizeView.height);
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
    if (isSearching)
    {
        return [arraySearchResults count];
    }
    else
    {
        if (showBoards) {
            return [_appDelegate.arrayOfBoards count];
        }
        if (showImages) {
            return [_appDelegate.arrayOfImages count]; //(isImageShowing?[onlyImages count]:[onlySounds count]);
        }
        if (showFontsList) {
            return [_arrayFontsList count]; //(isImageShowing?[onlyImages count]:[onlySounds count]);
        }
        return 0;
    }
    
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"custom";
    
    // the line below comes instead of setting the name of the reusableIdentifer
    // that we give at design time on mainstoryboard
    
    [_tblList registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
    
    // then continue as ussual
    // ---------------------------
    
    UITableViewCell* currCell = [_tblList dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    
    if (currCell == nil) {
        currCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    Images_class* imgClass = [[Images_class alloc]init];
    BoardsList_class* brdClass = [[BoardsList_class alloc]init];
    
    
    if(isSearching) //if(_tblImageList == self.searchDisplayController.searchResultsTableView)
    {
        if (showBoards) {
            brdClass= arraySearchResults[indexPath.row];
            
        }
        
        if (showImages) {
            imgClass= arraySearchResults[indexPath.row];
        }
        if (showFontsList) {
            // imgClass = _globalsFuncs.getAllFontsAvailable[indexPath.row];
            
        }
        
        
        
    }
    else{
        if (showBoards) {
            brdClass = _appDelegate.arrayOfBoards[indexPath.row];
            
        }
        if (showImages) {
            imgClass = _appDelegate.arrayOfImages[indexPath.row];
            
        }
        if (showFontsList) {
            // imgClass = _globalsFuncs.getAllFontsAvailable[indexPath.row];
            
        }
        
        
        
        
    }
    
    if (showBoards) {
        //imgX.imgPath actually contains the full name inc. path of the image
        
        
        NSString* dirBoards=[_globalsFuncs getFullDirectoryPathfor:BOARDS_MAIN_FOLDER];
        NSString* fileXML = [dirBoards stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",brdClass.brdFileName]];
        fileXML = [fileXML stringByAppendingPathExtension:@"xml"];
        BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:fileXML];
        if (fileExists) {
            
            currCell.imageView.image = [UIImage imageNamed:brdClass.brdIcon];
            [currCell.textLabel setText:[NSString stringWithFormat:@"%@",brdClass.brdFileName]];
            
        }
        else
        {
            NSLog(@"Board NOT exists");
            currCell.imageView.image = [UIImage imageNamed:@"table_48x48.gif"];
            
        }
        return currCell;
        
    }
    
    else if (showImages) {
        
        
        //imgClass.imgPath actually contains the full name inc. path of the image
        NSString* imgFullFilename = [[LIBRARY_MAIN_FOLDER stringByAppendingPathComponent:imgClass.imgPath] stringByAppendingPathComponent:imgClass.imgFileName];
        // imgFullFilename = [imgFullFilename stringByAppendingPathComponent:imgClass.imgFileName];
        
        NSData* imgData = [NSData dataWithContentsOfFile:imgFullFilename];
        if (imgData != nil) {
            currCell.imageView.image = [UIImage imageWithData:imgData];
            [currCell.textLabel setText:[NSString stringWithFormat:@"%@",imgClass.imgShowName]];
        }
        else
        {
            NSLog(@"Image NOT exists");
            currCell.imageView.image = [UIImage imageNamed:@"myvoice.jpg"];
            
        }
        return currCell;
    }
    else if (showFontsList) {
        
        
        NSString* fontFamilyName = [_arrayFontsList objectAtIndex:indexPath.row];
        
        currCell.imageView.image=[UIImage imageNamed:@"letter_f"];
        [currCell.textLabel setText:[NSString stringWithFormat:@"%@",fontFamilyName]];
        
        
        return currCell;
        
    }
    else
        
    {
        return NULL;
    }
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
    
    if (showImages) {
        Images_class* selectedIMG = [[Images_class alloc]init];
        
        if (isSearching) {
            
            selectedIMG = [arraySearchResults objectAtIndex:indexPath.row];
            
        }
        else{
            selectedIMG = [_appDelegate.arrayOfImages objectAtIndex:indexPath.row];
        }
        //send notification
        NSNotificationCenter* notificationcenter = [NSNotificationCenter defaultCenter];
        [notificationcenter postNotificationName:@"imagefromlist" object:selectedIMG];
        [self.navigationController popToRootViewControllerAnimated:TRUE];
    }
    
    if (showBoards) {
        BoardsList_class* selectedBRD = [[BoardsList_class alloc]init];
        
        if (isSearching) {
            selectedBRD = [arraySearchResults objectAtIndex:indexPath.row];
        }
        else{
            selectedBRD = [_appDelegate.arrayOfBoards objectAtIndex:indexPath.row];
        }
        
        if (_flgSetHomePage) {// set the default board for run
            _appDelegate.HomepageBoard = selectedBRD;
            _flgSetHomePage = NO;
            
            //todo - save it in user default;
            // NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            // [defaults setValue:selectedBRD forKey:@"homepageboard"];
            
            NSNotificationCenter* notificationcenter = [NSNotificationCenter defaultCenter];
            [notificationcenter postNotificationName:@"setHomepageInDefaults" object:@"notificationSetHomepageBoard"];
            
        }
        else{
            if (self.view.tag == 99) {
                //send notification for loading the board
                NSNotificationCenter* notificationcenter = [NSNotificationCenter defaultCenter];
                [notificationcenter postNotificationName:@"boardfromlist4link" object:selectedBRD];
                [self.navigationController popToRootViewControllerAnimated:TRUE];

            }
            else
            {
            //send notification for loading the board
            NSNotificationCenter* notificationcenter = [NSNotificationCenter defaultCenter];
            [notificationcenter postNotificationName:@"boardfromlist" object:selectedBRD];
            }
        }
    }
    
    if (showFontsList) {
        
        NSString* selectedFont = [_arrayFontsList objectAtIndex:indexPath.row];
        NSNotificationCenter* notificationcenter = [NSNotificationCenter defaultCenter];
        [notificationcenter postNotificationName:@"fontfromList" object:selectedFont];
        [self.navigationController popToRootViewControllerAnimated:TRUE];
    }

}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    if (showImages)
    {
        return @"Choose a Symbol"; //[appDelegate myLocalizedString: @"Cells Images"];
    }
    else
        if(showBoards)
        {
            return  @"Select a board for loading";
        }
        else return @"";
   
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.row == _appDelegate.arrayOfImages.count) {
        if (isSearching && showImages) {
            if(![searchItem isEqualToString:@""])
            {
                
                _searchBar.text = searchItem;
                [self searchTableView:_searchBar];
            }
        }

    }
}


#pragma mark - SearchBar Delegate



//- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar;                       // called when text ends editing



//- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar;                     // called when cancel button pressed


- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar  // called when text starts editing
{
    isSearching = YES;
    letUserSelectRow = NO;
    _tblList.scrollEnabled=YES;
    
    //  self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemDone target:self action:@selector(doneSearching_Clicked:)] autorelease];
    //  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemDone target:self action:@selector(doneSearching_Clicked:)];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText // called when text changes (including clear)
{
    [arraySearchResults removeAllObjects];
    
    if ([searchText length] > 0)
    {
        isSearching = YES;
        letUserSelectRow = YES;
        _tblList.scrollEnabled=YES;
        [self searchTableView:searchBar];
    }
    else
    {
        isSearching = NO;
        letUserSelectRow = NO;
        _tblList.scrollEnabled=YES;
    }
    
    [_tblList reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar  // called when keyboard search button pressed
{
    [self searchTableView:searchBar];
}

- (void)searchTableView:(UISearchBar*)searchBar
{

    NSString *searchText =  searchBar.text;
    
    for (Images_class *sTemp in _appDelegate.arrayOfImages)
    {
        NSRange titleResultsRange = [sTemp.imgShowName rangeOfString:searchText options:NSCaseInsensitiveSearch];
        
        if (titleResultsRange.length > 0)
        {
            [arraySearchResults addObject:sTemp];
            
        }
    }

}

- (void) doneSearching_Clicked:(id)sender
{
    _searchBar.text = @"";
    [_searchBar resignFirstResponder];
    
    letUserSelectRow = YES;
    isSearching = NO;
    self.navigationItem.rightBarButtonItem = nil;
    // self.ImageSoundListTable.scrollEnabled = YES;
    _tblList.scrollEnabled = YES;
    
    //[self.ImageSoundListTable reloadData];
    [_tblList reloadData];
}


#pragma mark -
#pragma mark LINKS

-(void)createNewBoardFromLink
{
    NSString* storyboardName = @"Main";
    NSString* viewControllerID = @"newboard";
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
   // newBoardVC = (UINavigationController *)[storyboard instantiateViewControllerWithIdentifier:viewControllerID];
    
    
    UIViewController* newBoardVC = (UINavigationController *)[storyboard instantiateViewControllerWithIdentifier:viewControllerID];
    //newBoardVC.flgShowModal = TRUE;
    newBoardVC.view.tag=99; // for indication that the view is loaded from cell properties
   // self.preferredContentSize = CGSizeMake(450, 350);
    [self.navigationController pushViewController:newBoardVC animated:YES];
    
    
    
}


@end
