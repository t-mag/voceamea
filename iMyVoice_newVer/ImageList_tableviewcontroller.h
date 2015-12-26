//
//  ImageList_tableviewcontroller.h
//  iMyVoice_newVer
//
//  Created by Simona Tzalik on 13/6/15.
//  Copyright (c) 2015 Techno M.A.G. All rights reserved.
//

#import <UIKit/UIKit.h>

UISearchBar* searchBar;
UITableView* tblImageList;

@interface ImageList_tableviewcontroller : UIViewController

@property NSMutableArray* arraySearchResults;
@property UISearchBar* searchBar;
@property UITableView* tblImageList;

@property BOOL isSearching;
@property BOOL letUserSelectRow;
@end
