//
//  Board_class.h
//  iMyVoice_newVer
//
//  Created by Simona Tzalik on 16/4/15.
//  Copyright (c) 2015 Techno M.A.G. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Board_class : NSObject

@property int       brdID;
@property int       brdUserID;
@property UIImage*  brdIcon;
@property NSNumber* brdCols;
@property NSNumber* brdRows;
@property NSString* brdName;
@property NSString* brdCreatedBy;
@property NSDate*   brdCreatedDate;
@property NSString* brdLastUpdatedBy;
@property NSDate*   brdLastUpdateDate;


//@property  NSMutableArray* cells;

@end
