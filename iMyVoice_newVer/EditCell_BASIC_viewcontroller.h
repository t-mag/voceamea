//
//  EditCell_BASIC_viewcontroller.h
//  iMyVoice_newVer
//
//  Created by Simona Tzalik on 11/13/15.
//  Copyright © 2015 Techno M.A.G. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditCell_BASIC_viewcontroller : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *lblTextInCell;
@property (weak, nonatomic) IBOutlet UITextField *txtTextInCell;
@property (weak, nonatomic) IBOutlet UIButton *btnImageInCell;
@property (weak, nonatomic) IBOutlet UILabel *lblMessageInCell;
@property (weak, nonatomic) IBOutlet UITextField *txtMessageInCell;
@property (weak, nonatomic) IBOutlet UILabel *lblHideCell;
@property (weak, nonatomic) IBOutlet UISwitch *swtHideCell;
@property (weak, nonatomic) IBOutlet UILabel *lblTextOnTop;
@property (weak, nonatomic) IBOutlet UISwitch *swtTextOnTop;

//values from outside
@property float myParentWidth;
@property float myParentHeight;

@end
