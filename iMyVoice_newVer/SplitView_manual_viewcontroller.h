//
//  SplitView_manual_viewcontroller.h
//  iMyVoice_newVer
//
//  Created by Simona Tzalik on 11/13/15.
//  Copyright © 2015 Techno M.A.G. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Cell_class.h"

@interface SplitView_manual_viewcontroller : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tblMenu;

@property Cell_class* cellEditProperties; //contains data of the current cell from outside
@property Cell_class* tempCellProperties; //contains changed data but not yet saved


@end
