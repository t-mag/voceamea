//
//  AppDelegate.h
//  iMyVoice_newVer
//
//  Created by Simona Tzalik on 16/4/15.
//  Copyright (c) 2015 Techno M.A.G. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BoardsList_class.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property NSMutableArray* arrayOfImages;
@property NSMutableArray* arrayOfBoards;
@property NSMutableArray* arrayOfLoadedBoard;//contains the board class and cells class of the current loaded board
@property NSMutableArray* arrayOfNavigationStackBoards;//contains the boards currently loaded by user and fictivly exising in navigation controller stack. Items of arrayOfNavigationStackBoards are of type arrayOfLoadedBoard
@property NSInteger iTotalUserImages;
@property BoardsList_class* HomepageBoard; // contains the main board to run from
@property BOOL flgEditBoardNavBack; // indicates if during Edit Board mode - user pressed BACK
@property BOOL flgRunBoardMode;
@property BOOL flgEditBoardMode;


@property NSMutableDictionary* dictPurchasedPackages;



@end

