//
//  BoardPopupmenu_tableviewcontroller.h
//  iMyVoice_newVer
//
//  Created by Simona Tzalik on 27/6/15.
//  Copyright (c) 2015 Techno M.A.G. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BoardPopupmenu_tableviewcontroller;
@protocol BoardPopupmenuDelegate <NSObject>

@optional
-(void)SaveBoardAs;
-(void)SaveBoard;
-(void)LoadBoard;
-(void)MergeAction; //menu related
-(void)SplitAction; //menu related
-(void)Undo; //menu related
-(void)setStartupBoard;

@end



@interface BoardPopupmenu_tableviewcontroller : UITableViewController

@property id<BoardPopupmenuDelegate> delegate;


@property NSMutableArray* arrayMenuItems;
@property BOOL mnuMergeEnabled;
@property BOOL mnuSplitEnabled;
@property BOOL mnuUndoEnabled;
@end
