//
//  EditBoardCell_collectionviewcell.h
//  iMyVoice_newVer
//
//  Created by Simona Tzalik on 16/4/15.
//  Copyright (c) 2015 Techno M.A.G. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EditBoardCell_collectionviewcell; // Forward declare Custom Cell for the property

@protocol EditBoardCellDelegate <NSObject>

@optional
-(void)MergeAction:(id)sender; //menu related
-(void)SplitAction:(id)sender; //menu related
-(void)didClickEditCell:(EditBoardCell_collectionviewcell *)cell; //click on btnEditCell
-(void)didDoubleTapInCell:(EditBoardCell_collectionviewcell *)cell; //open ChangeTextInCell dialog
-(void)didPlayMessageInCell:(EditBoardCell_collectionviewcell *)cell; //click on PlayMesageinCell
-(void)showRightClickMenu:(EditBoardCell_collectionviewcell*)cell;
-(void)didTapOnceInCell:(EditBoardCell_collectionviewcell*)cel;

@end

@interface EditBoardCell_collectionviewcell : UICollectionViewCell

@property id<EditBoardCellDelegate> delegate;

//@property (weak, nonatomic) IBOutlet UIImageView *imgSemel;

@property (weak, nonatomic) IBOutlet UILabel *lblTextBottom;
@property (weak, nonatomic) IBOutlet UILabel *lblTextTop;
@property (weak, nonatomic) IBOutlet UIButton *btnEditCell;
@property (weak, nonatomic) IBOutlet UIButton *btnPlayMSG;
@property (weak, nonatomic) IBOutlet UIImageView *imgSymbolCell;


@property double pressTimeDelay;


@end
