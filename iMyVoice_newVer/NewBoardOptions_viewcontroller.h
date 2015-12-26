//
//  NewBoardOptions_viewcontroller.h
//  iMyVoice_newVer
//
//  Created by Simona Tzalik on 16/4/15.
//  Copyright (c) 2015 Techno M.A.G. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NewBoardOptions_viewcontroller : UIViewController

@property BOOL flgShowModal; //if TRUE - show the viewcontroller smaller than the all screen

+ (id)copyWithZone:(struct _NSZone *)zone;
- (void)showListOfExisitingBoards:(NSObject*)sender;

@end
