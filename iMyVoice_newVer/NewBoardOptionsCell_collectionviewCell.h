//
//  NewBoardOptionsCell_collectionviewCell.h
//  iMyVoice_newVer
//
//  Created by Simona Tzalik on 16/4/15.
//  Copyright (c) 2015 Techno M.A.G. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NewBoardOptionsCell_collectionviewCell : UICollectionViewCell <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imgNewBoard;
@property (weak, nonatomic) IBOutlet UITextField *txtBoardName;
@end
