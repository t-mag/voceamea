//
//  ImageSoundListViewController.h
//  MyVoice
//
//  Created by kostya on 27.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageSoundListViewDelegate.h"
@interface ImageSoundListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate>
{
    id<ImageSoundListViewDelegate> _delegate;
    BOOL isNav;
    BOOL isImageShowing;
    
    NSMutableArray *onlyImages;
    NSMutableArray *onlySounds;
    NSMutableArray  *copyListOfItems;
    
    IBOutlet UISearchBar *searchBaar;
    IBOutlet UITableView *ImageSoundListTable;
    
   // NSString* selectedItemStr;
    
    
    int scrollToItemIndex;
    
    BOOL isSearching;
    BOOL letUserSelectRow;
}

//@property (nonatomic) MediaTypes mediaType;
@property (nonatomic, retain) id<ImageSoundListViewDelegate> delegate;
@property (nonatomic, readwrite) BOOL isNav;
@property (nonatomic, readwrite) BOOL isImageShowing;
@property (nonatomic, retain) UITableView *ImageSoundListTable;

@property (nonatomic, assign) NSString *selectedItemStr;

- (void) searchTableView;

@end
