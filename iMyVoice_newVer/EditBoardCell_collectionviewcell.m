//
//  EditBoardCell_collectionviewcell.m
//  iMyVoice_newVer
//
//  Created by Simona Tzalik on 16/4/15.
//  Copyright (c) 2015 Techno M.A.G. All rights reserved.
//

#import "EditBoardCell_collectionviewcell.h"
//#import "CellPopUpMenu_viewcontroller.h"

@implementation EditBoardCell_collectionviewcell

@synthesize lblTextBottom,lblTextTop,imgSymbolCell,pressTimeDelay;


// Call our ViewController to do the work, since it has knowledge of the data model, not this view.
// On iOS 7.0, you'll have to implement this method to make the custom menu appear with a UICollectionViewController
//- (void)MergeAction:(id)sender forCell:(GridCollectionViewCell *)cell {

- (void)MergeAction:(id)sender {
    
//    NSLog(@"MergeAction in GridCollectionViewCell");
//    
//    //  if([self.delegate respondsToSelector:@selector(MergeAction:forCell:)]) {
//    if([self.delegate respondsToSelector:@selector(MergeAction:)]) {
//        // [self.delegate MergeAction:sender forCell:self];
//        [self.delegate MergeAction:sender];
//        
//    }
    
}
//
- (void)SplitAction:(id)sender {
//    
//    NSLog(@"SplitAction in GridCollectionViewCell");
//    
//    if([self.delegate respondsToSelector:@selector(SplitAction:)]) {
//        // [self.delegate SplitCell:sender forCell:self];
//        [self.delegate SplitAction:self];
//        
//    }
}



//#pragma mark - UIMenuController required methods (Might not be needed on iOS 7)
- (BOOL)canBecomeFirstResponder {
    // NOTE: This menu item will not show if this is not YES!
    return YES;
}



- (IBAction)btnEditCell:(UIButton *)sender {
    
    [[self delegate] didClickEditCell:self];
    
}

- (IBAction)btnPlayMSG:(UIButton *)sender {
    
    [[self delegate] didPlayMessageInCell:self];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    
  
//    //add double-tap gesture to each cell
//    UITapGestureRecognizer *tapPressGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userDidTapOnCell:)];
//    tapPressGesture.numberOfTapsRequired=1;
//    tapPressGesture.delegate=self;
//    [self addGestureRecognizer:tapPressGesture];
//    
    
    
    UITouch *touch = [touches anyObject];
    if(touch.tapCount == 2)
    {
        [[self delegate] didDoubleTapInCell:self];
    }
    else if (touch.tapCount == 1)
    {

        [[self delegate] didTapOnceInCell:self];
    }
}
@end
