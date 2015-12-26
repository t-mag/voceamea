//
//  Text2Speech.h
//  iMyVoice_newVer
//
//  Created by Simona Tzalik on 25/6/15.
//  Copyright (c) 2015 Techno M.A.G. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Text2Speech : NSObject




-(NSString*)getUtteranceLanguageCode:(NSString*)sLanguage;
-(NSString*)getGuessedUtteranceLanguageCode:(NSString *)sString;
@end
