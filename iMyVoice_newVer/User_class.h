//
//  User_class.h
//  iMyVoice_newVer
//
//  Created by Simona Tzalik on 8/6/15.
//  Copyright (c) 2015 Techno M.A.G. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface User_class : NSObject

@property int       userID;
@property NSString* userName;
@property NSString* userNationalIndex;
@property int       userMainBoardID;
@property NSMutableArray* userBoards; //keeps all the boards belonging to that user
@property int       userTextPosition;
@property NSString* userFont;
@property int       userFontSize;
@property NSString* userFontType;
@property UIColor*  userFontColor;
@property int       userScanType; // connects to class SCAN
@property int       userScanFrameWidth;
@property UIColor*  userScanFrameColor;
@property BOOL*     userShowSentenceLine;
@property NSString* userCreatedBy;
@property NSDate*   userCreatedDate;
@property NSString* userLastUpdatedBy;
@property NSDate*   userLastUpdateDate;


-(id)init;

@end
