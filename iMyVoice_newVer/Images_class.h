//
//  Images_class.h
//  iMyVoice_newVer
//
//  Created by Simona Tzalik on 20/5/15.
//  Copyright (c) 2015 Techno M.A.G. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIKit/UIKit.h"
#import "AppDelegate.h"

@interface Images_class : NSObject

@property AppDelegate* appdelegate;

@property NSString* imgIndex; // connects to class CELL
@property NSString* imgShowName;
@property NSString* imgDescription;
@property NSString* imgFileName;
@property NSString* imgPath;
@property NSString* imgCategory;
@property NSString* imgPrompt;
@property NSString* imgType;
@property NSString* imgCreatedBy;
@property NSDate*   imgCreatedDate;
@property NSString* imgLastUpdatedBy;
@property NSDate*   imgLastUpdatedDate;

-(id)initWithImageIndex:(NSString*)imageIndex;
-(BOOL)updateImageClasswithShowName:(NSString*)sShowName andwithDescription:(NSString*)sDescription andwithFileName:(NSString*)sFileName andwithPath:(NSString*)sPath andwithCategory:(NSString*)sCategory andwithUpdatedDate:(NSDate*) dateUpdated andwithUpdatedDateby:(NSString*) dateUpdatedby andwithPrompt:(NSString*)sPrompt andwithType:(NSString*)sType andwithIndex:(NSString*)nIndex;
@end
