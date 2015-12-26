//
//  PopupMenu_viewcontroller.h
//  iMyVoice_newVer
//
//  Created by Simona Tzalik on 22/4/15.
//  Copyright (c) 2015 Techno M.A.G. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STCollapseTableView.h"


//@protocol PopupMenuPopoverDelegate
//- (void) dismissPopover;//:(UIViewController*)myVC; //:(NSObject *)yourDataToTransfer;
//@end

//@interface PopupMenu_viewcontroller : UIViewController
//{
//    id<PopupMenuPopoverDelegate> delegate;
//}
//@property id<PopupMenuPopoverDelegate> delegate;

@property (weak, nonatomic) IBOutlet STCollapseTableView *tblPopupMenu;

@property int iTypeOfPopup; //indicates what items will be showed in the table according to the type of menu user requsted;
// = 1 -> Cell menu
// = 2 -> Board menu
// = 3 -> General Menu


@end
