//
//  Popover_viewcontroller.h
//  iMyVoice_newVer
//
//  Created by Simona Tzalik on 12/18/15.
//  Copyright © 2015 Techno M.A.G. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Popover_viewcontroller : UIViewController

@property int viewType; // indicates what view it will show and accordely which objects will it load on screen
@property id viewObject; // holds details for the wanted view
@end
