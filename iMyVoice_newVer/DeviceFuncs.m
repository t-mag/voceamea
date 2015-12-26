//
//  DeviceFuncs.m
//  iMyVoice_newVer
//
//  Created by Simona Tzalik on 16/4/15.
//  Copyright (c) 2015 Techno M.A.G. All rights reserved.
//

#import "DeviceFuncs.h"


@implementation DeviceFuncs

-(CGSize)DeviceSize;
{
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    return screenSize;
   
}

-(NSString*)DeviceType
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        // iPhone device
        UIDevice* myDevice = [[UIDevice alloc]init];
        
        return [NSString stringWithFormat:@"%@",myDevice.name];
        
    }
    else if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        // iPad device
        UIDevice* myDevice = [[UIDevice alloc]init];
        
        return [NSString stringWithFormat:@"%@",myDevice.name];
    }
    else {
        // Other device i.e. iPod
        return @"Other";
    }
    
}

-(UIDeviceOrientation*)DeviceCurrentOrientation
{
    int deviceO=[[UIDevice currentDevice] orientation];
    
    switch (deviceO) {
        case 0:
            return UIInterfaceOrientationLandscapeLeft;
            break;
//        case 0:
//            <#statements#>
//            break;
//        case 0:
//            <#statements#>
//            break;
//        case 0:
//            <#statements#>
//            break;
     
        default:
            break;
    }
    
    return [[UIDevice currentDevice] orientation];
    
}

@end
