//
//  EasyAlertView.h
//  iMyVoice_newVer
//
//  Created by Simona Tzalik on 10/8/15.
//  Copyright (c) 2015 Techno M.A.G. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIKit/UIKit.h"

typedef void (^AlertBlock)(NSUInteger,NSMutableArray*);

/** A less-unwieldly specialization of UIAlertView that allows a Block to be used as the dismissal handler.
 This is more flexible and compact than the delegate based approach. It allows all the logic to
 be centralized within the launching method and eliminates confusion and object lifetime issues that arise
 when using multiple alerts in the same class bound to a single delegate. */

@interface EasyAlertView : UIAlertView <UIAlertViewDelegate>
{
    AlertBlock _block;
    
}



+ (id)showWithTitle:(NSString *)title
            message:(NSString *)message
         alertStyle:(UIAlertViewStyle)alertViewstyle
         usingBlock:(void (^)(NSUInteger,NSMutableArray*))block
  cancelButtonTitle:(NSString *)cancelButtonTitle
  otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;



@end
