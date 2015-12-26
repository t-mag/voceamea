//
//  ImageSoundListViewDelegate.h
//  MyVoice
//
//  Created by Lion User on 21/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum {
    MTVoice,
    MTImage,
    MTVideo,
    MTMusic
}MediaTypes;
@protocol ImageSoundListViewDelegate <NSObject>
@optional
- (void)changeTileImage:(NSString *) imageName fromPackage:(NSNumber*)isPackage;
- (void)changeTileSound:(NSString *) soundName;
- (void)itemSelected:(NSString *) itemName mediaType:(MediaTypes)mediaType;
@end
