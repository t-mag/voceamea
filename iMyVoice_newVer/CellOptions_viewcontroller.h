//
//  CellOptions_viewcontroller.h
//  iMyVoice_newVer
//
//  Created by Simona Tzalik on 25/4/15.
//  Copyright (c) 2015 Techno M.A.G. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBWebViewController.h"
#import "PBSafariActivity.h"

// this setting needs to be done so
//@class CellOptions_viewcontroller;
//
//@protocol CellOptionsViewControllerDelegate
////- (void)popupmenuViewControllerDidFinish:(PopupMenu_viewcontroller *)popupmenuVC;
////- (void)ExitPopoverFromCellOptions:(NSString *)yourDataToTransfer;
//
//-(void)CellOptionsDidReturnWithImage:(UIImage*)image;
//
//@end


@interface CellOptions_viewcontroller : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *imgCamera;
@property (weak, nonatomic) IBOutlet UIButton *btnCamera;
@property (weak, nonatomic) IBOutlet UIButton *btnOK;

@property (weak, nonatomic) IBOutlet PBWebViewController *webBrowser;

//@property (weak, nonatomic) IBOutlet UITableView *tblImageList;

//@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

//@property id <CellOptionsViewControllerDelegate> delegate;

@property NSString* strPurpose; // indicates what should the viewcontroller show:
                             // List of images
                             // Camera
                             // Photoes
                             // Web

@end
