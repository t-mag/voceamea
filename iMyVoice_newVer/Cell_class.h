//
//  Cell_class.h
//  iMyVoice_newVer
//
//  Created by Simona Tzalik on 16/4/15.
//  Copyright (c) 2015 Techno M.A.G. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Cell_class : NSObject

@property int       cellIndex; // indicates the place of the cell in the array of cells
@property int       cellBoardID;
@property NSString* cellImageID; // connects to class Images
@property int       cellImageRow;
@property int       cellImageCol;
@property NSString* cellText;
@property BOOL      cellTextOnTop; 
@property BOOL      cellHidden; 
@property UIFont*   cellFont;
@property UIColor*  cellFontColor;
@property float     cellFontSize;
@property int       cellFontType; // 0-regular,1-bold,2-italic
@property UIColor*  cellBackgroundColor;
@property UIColor*  cellBorderColor;
@property float     cellBorderWidth; 
@property NSString* cellMessage; 
@property NSString* cellSoundFilename;
@property NSString* cellSoundPath;
@property NSString* cellMP3Path;
@property NSString* cellVIDEOPath;
@property NSString* cellWEBPath;
@property int       cellBoardLink;
@property NSString* cellCreatedBy;
@property NSDate*   cellCreatedDate;
@property NSString* cellLastUpdatedBy;
@property NSDate*   cellLastUpdateDate;
@property BOOL      cellBtnPlayIsEnabled;



@property CGSize            size;
@property CGPoint           coordinates;
@property BOOL              selected; //YES - design mode - indicates that the cell was selected
@property NSDictionary*     tag;
@property NSMutableArray*   collection; // contains the coordinates of cells creating the current cell
@property BOOL              mark; // used for spliting cells
@property BOOL              mark4show; //default set to: NO. Is set to YES for each cell that is added to _arrayOfCells. this array is used as the array the collectionview is showing


-(id)init;
-(id)copyWithZone: (NSZone *) zone;

@end
