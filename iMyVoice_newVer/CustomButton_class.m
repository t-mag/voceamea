//
//  CustomButton_class.m
//  iMyVoice_newVer
//
//  Created by Simona Tzalik on 11/11/15.
//  Copyright © 2015 Techno M.A.G. All rights reserved.
//

#import "CustomButton_class.h"

@implementation CustomButton_class
@synthesize userData;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self setFrame:CGRectMake(0, 0, 1, 1)];
    
    
    self.layer.borderWidth = 2.0f;
    self.layer.borderColor = [UIColor blueColor].CGColor;
    self.layer.cornerRadius = 5.0f;
    
    return  self;
}
    /*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
