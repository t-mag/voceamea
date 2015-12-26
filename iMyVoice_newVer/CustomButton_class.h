//
//  CustomButton_class.h
//  iMyVoice_newVer
//
//  Created by Simona Tzalik on 11/11/15.
//  Copyright © 2015 Techno M.A.G. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomButton_class : UIButton
{
id userData;
}

@property (nonatomic, readwrite, retain) id userData;

- (id)initWithFrame:(CGRect)frame;
@end
