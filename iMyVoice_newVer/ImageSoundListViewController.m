//
//  ImageSoundListViewController.m
//  MyVoice
//
//  Created by kostya on 27.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ImageSoundListViewController.h"
#import "AppDelegate.h"
#import "Globals.h"


@implementation ImageSoundListViewController

@synthesize ImageSoundListTable, isImageShowing, isNav;
@synthesize delegate = _delegate;
@synthesize selectedItemStr;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        
    }
    return self;
}

//- (void)dealloc
//{
//    [super dealloc];
//}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    if (isSearching)
        return [copyListOfItems count];
    else
        return (isImageShowing?[onlyImages count]:[onlySounds count]);
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [[self ImageSoundListTable] dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
    {
       // cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
         cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSString *resourceName;
    if(isSearching)
        resourceName = [copyListOfItems objectAtIndex:indexPath.row];
    else
        resourceName = isImageShowing?[onlyImages objectAtIndex: [indexPath row]]:[onlySounds objectAtIndex:[indexPath row]];
    [cell textLabel].text = resourceName;
    
//    if (selectedItemStr != nil && [resourceName isEqualToString: selectedItemStr])
//        [ImageSoundListTable selectRowAtIndexPath: indexPath animated: YES scrollPosition: UITableViewScrollPositionTop];
    
    
    if (isImageShowing)
    {
        UIImage *img;
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *bundleRoot = [[NSBundle mainBundle] bundlePath];
        
        NSString *str;
        if (isSearching)
            str = [bundleRoot stringByAppendingPathComponent:[copyListOfItems objectAtIndex: [indexPath row]]];
        else
            str = [bundleRoot stringByAppendingPathComponent:[onlyImages objectAtIndex: [indexPath row]]];
        BOOL fileExist = [fileManager fileExistsAtPath:str];
        
        if (fileExist == YES)
        {
            if (isSearching)
                img = [UIImage imageNamed: [copyListOfItems objectAtIndex: [indexPath row]]];
            else
                img = [UIImage imageNamed: [onlyImages objectAtIndex: [indexPath row]]];
        }
        else
        {
            NSString *pngPath;
            
            if (isSearching)
                pngPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat: @"Documents/%@", [copyListOfItems objectAtIndex: [indexPath row]]]];
            else
                pngPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat: @"Documents/%@", [onlyImages objectAtIndex: [indexPath row]]]];
            img = [UIImage  imageWithContentsOfFile:pngPath];
        }
        
        
        
        UIGraphicsBeginImageContext(CGSizeMake(40, 40));
        [img drawInRect:CGRectMake(0, 0, 40, 40)];
        UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        [[cell imageView] setImage: scaledImage];
    }
    else
    {
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *bundleRoot = [[NSBundle mainBundle] bundlePath];
        
        NSString *str;
        if (isSearching)
            str = [bundleRoot stringByAppendingPathComponent:[copyListOfItems objectAtIndex: [indexPath row]]];
        else
            str = [bundleRoot stringByAppendingPathComponent:[onlySounds objectAtIndex: [indexPath row]]];
        BOOL fileExist = [fileManager fileExistsAtPath:str];
        
        if (fileExist == YES)
        {
              }
        else
        {
            NSString *pngPath;
            
            if (isSearching)
                pngPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat: @"Documents/%@", [copyListOfItems objectAtIndex: [indexPath row]]]];
            else
                pngPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat: @"Documents/%@", [onlySounds objectAtIndex: [indexPath row]]]];
        }
    }
    

    cell.tag = indexPath.row;
    
    // Set cell type
    cell.accessoryType =  UITableViewCellAccessoryNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_delegate != nil) 
    {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

        if (isImageShowing == YES)
           // [_delegate changeTileImage: [cell textLabel].text];
            NSLog(@"(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath");
        else
        {
       
            [_delegate changeTileSound: [cell textLabel].text];
        }

        if (isNav == YES)
            [self.navigationController popViewControllerAnimated: YES];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    //MyVoiceAppDelegate *appDelegate = (MyVoiceAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (isImageShowing == YES)
        return @"Choose a Symbol"; //[appDelegate myLocalizedString: @"Cells Images"];
    else
        return @"Choose a Sound"; //[appDelegate myLocalizedString: @"Cells Sounds" ];
}

-(void) searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    isSearching = YES;
    letUserSelectRow = NO;
    self.ImageSoundListTable.scrollEnabled = YES;
    
  //  self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemDone target:self action:@selector(doneSearching_Clicked:)] autorelease];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemDone target:self action:@selector(doneSearching_Clicked:)];
}

-(void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [copyListOfItems removeAllObjects];
    
    if ([searchText length] > 0)
    {
        isSearching = YES;
        letUserSelectRow = YES;
        self.ImageSoundListTable.scrollEnabled = YES;
        [self searchTableView];
    }
    else
    {
        isSearching = NO;
        letUserSelectRow = NO;
        self.ImageSoundListTable.scrollEnabled = YES;
    }
    
    [self.ImageSoundListTable reloadData];
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self searchTableView];
}

- (void) searchTableView
{
    NSString *searchText = searchBaar.text;
    NSMutableArray *searchArray = [[NSMutableArray alloc] init];
    
    if (isImageShowing){
        for (NSString *sTemp in onlyImages)
        {
            [searchArray addObject: sTemp];
        }
    }else{
        for (NSString *sTemp in onlySounds)
        {
            [searchArray addObject: sTemp];
        }
    }
        
        for (NSString *sTemp in searchArray)
        {
            NSRange titleResultsRange = [sTemp rangeOfString:searchText options:NSCaseInsensitiveSearch];
            
            if (titleResultsRange.length > 0)
            {
                [copyListOfItems addObject:sTemp];
            }
        }
    
//    [searchArray release];
    searchArray = nil;
    
}

- (void) doneSearching_Clicked:(id)sender
{
    searchBaar.text = @"";
    [searchBaar resignFirstResponder];
    
    letUserSelectRow = YES;
    isSearching = NO;
    self.navigationItem.rightBarButtonItem = nil;
    self.ImageSoundListTable.scrollEnabled = YES;
    
    [self.ImageSoundListTable reloadData];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    
    NSLog(@"ImageSoundListViewController::viewDidLoad");

    [super viewDidLoad];
    
    // Add the search bar
    
    self.ImageSoundListTable.tableHeaderView = searchBaar;
    searchBaar.autocorrectionType = UITextAutocorrectionTypeNo;
    searchBaar.delegate = self;
    
    isSearching = NO;
    letUserSelectRow = NO;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSError * error;
    NSArray * dirContents;
    copyListOfItems = [[NSMutableArray alloc] init];
    
    if (isImageShowing == NO)
    {
        onlySounds = [[NSMutableArray alloc] init];
        onlyImages = nil;
        
        NSString * bundleRoot = [NSString stringWithFormat:@"%@", [[NSBundle mainBundle] bundlePath]] ;
        dirContents = [fileManager contentsOfDirectoryAtPath: bundleRoot error:&error];
          NSString * ext = @"*.aiff";
        [onlySounds setArray: [dirContents filteredArrayUsingPredicate: [NSPredicate predicateWithFormat:@"SELF like %@", ext]]];
        
        NSArray *documentsPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDir = [documentsPaths objectAtIndex: 0];
        
        NSArray *documentsDirContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDir error:nil];
        NSArray *onlyPNGs = [documentsDirContents filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self ENDSWITH '.aiff'"]];
        
        [onlySounds addObjectsFromArray: onlyPNGs];
        [copyListOfItems addObjectsFromArray: onlySounds];
        
    }
    else
    {
        NSString * bundleRoot = [NSString stringWithFormat:@"%@", [[NSBundle mainBundle] bundlePath]] ;
        dirContents = [fileManager contentsOfDirectoryAtPath: bundleRoot error:&error];
        onlyImages = [[NSMutableArray alloc] init];
        onlySounds = nil;
        NSString * ext = @"*.png";
        [onlyImages setArray: [dirContents filteredArrayUsingPredicate: [NSPredicate predicateWithFormat:@"SELF like %@", ext]]];
    
        NSArray *documentsPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDir = [documentsPaths objectAtIndex: 0];
    
        NSArray *documentsDirContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDir error:nil];
        NSArray *onlyPNGs = [documentsDirContents filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self ENDSWITH '.png'"]];
        
        [onlyImages addObjectsFromArray: onlyPNGs];
        [copyListOfItems addObjectsFromArray: onlyImages];
    }
    
}

- (void) viewDidAppear:(BOOL)animated
{
}

- (void)viewDidUnload
{
//    if (onlyImages!=nil) [onlyImages release];
//    if (onlySounds!=nil) [onlySounds release];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
  
}

@end
