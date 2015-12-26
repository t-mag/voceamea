//
//  User_class.m
//  iMyVoice_newVer
//
//  Created by Simona Tzalik on 8/6/15.
//  Copyright (c) 2015 Techno M.A.G. All rights reserved.
//

#import "User_class.h"

@implementation User_class
@synthesize userCreatedBy,userCreatedDate,userFont,userFontColor,userFontSize,userFontType,userID,userLastUpdateDate,userLastUpdatedBy,userMainBoardID,userName,userNationalIndex,userScanFrameColor,userScanFrameWidth,userScanType,userShowSentenceLine,userTextPosition,userBoards;



-(id)init
{
    [super self];
    
    userBoards = [[NSMutableArray alloc]init];
    return self;
}
@end
