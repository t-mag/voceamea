//
//  EditCell_viewcontroller.h
//  iMyVoice_newVer
//
//  Created by Simona Tzalik on 11/6/15.
//  Copyright © 2015 Techno M.A.G. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditCell_viewcontroller : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *btnSelectImage;

@property (weak, nonatomic) IBOutlet UILabel *lblText;
@property (weak, nonatomic) IBOutlet UITextField *txtTextInCell;
@property (weak, nonatomic) IBOutlet UILabel *lblMessage;
@property (weak, nonatomic) IBOutlet UITextField *txtMsgInCell;
@property (weak, nonatomic) IBOutlet UILabel *lblTextPlace;
@property (weak, nonatomic) IBOutlet UISwitch *swtTextPlace;
@property (strong, nonatomic) IBOutlet UIView *lblHideCell;
@property (weak, nonatomic) IBOutlet UISwitch *swtHideCell;

@property UIColor* currentFontColor;
@property UIColor* currentBackColor;
@property UIColor* currentFrameColor;
@property UIFont* currentFont;

@end
