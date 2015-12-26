//
//  DeviceFuncs.h
//  iMyVoice_newVer
//
//  Created by Simona Tzalik on 16/4/15.
//  Copyright (c) 2015 Techno M.A.G. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeviceFuncs : NSObject

-(CGSize)DeviceSize;
-(NSString*)DeviceType;
-(UIDeviceOrientation*)DeviceCurrentOrientation;

@end
