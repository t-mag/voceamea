//
//  EditBoard_viewcontroller.h
//  iMyVoice_newVer
//
//  Created by Simona Tzalik on 16/4/15.
//  Copyright (c) 2015 Techno M.A.G. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "PopupMenu_viewcontroller.h"
#import "CellOptions_viewcontroller.h"
#import "Board_class.h"
#import "BoardsList_class.h"

@interface EditBoard_viewcontroller : UIViewController

@property int Rows;
@property int Cols;
@property NSString* BoardName;
@property NSString* myTag;
@property Board_class* boardSelectedbyUser;
@property BoardsList_class* board4Load;
@property UIImage* imgFromUserChoice;
@property UIPopoverController* popover;
@property UIBarButtonItem *navBoardButton;

-(void)mergeCells_auto_withNumOfRows:(int)iRows andwithNumOfCols:(int)iCols;
//-(id)initWithBoard:(Board_class*)bord2initwith;

@end
