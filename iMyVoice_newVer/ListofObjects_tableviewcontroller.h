//
//  ListofObjects_tableviewcontroller.h
//  iMyVoice_newVer
//
//  Created by Simona Tzalik on 14/6/15.
//  Copyright (c) 2015 Techno M.A.G. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListofObjects_tableviewcontroller : UITableViewController

@property NSMutableArray* arraySearchResults;
@property UISearchBar* searchBar;


@property BOOL showImages;
@property BOOL showBoards;
@property BOOL showAddSymbol;
@property BOOL showFontsList;
@property BOOL isSearching;
@property NSString* searchItem;
@property BOOL letUserSelectRow;
@property BOOL flgSetHomePage;

//the delegate functions needs to be declared public because searchbar is setted inside the tableview
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar;
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText;
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar;
@end
