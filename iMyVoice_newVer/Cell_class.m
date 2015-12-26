//
//  Cell_class.m
//  iMyVoice_newVer
//
//  Created by Simona Tzalik on 16/4/15.
//  Copyright (c) 2015 Techno M.A.G. All rights reserved.
//

#import "Cell_class.h"
#import "Globals.h"

@implementation Cell_class

@synthesize cellBackgroundColor,cellBoardID,cellBoardLink,cellBorderColor,cellCreatedBy,cellCreatedDate,cellImageCol,cellImageID,cellImageRow,cellIndex,cellLastUpdateDate,cellLastUpdatedBy,cellMP3Path,cellSoundFilename,cellSoundPath,cellText,cellVIDEOPath,cellWEBPath,size,coordinates,selected,tag,cellBtnPlayIsEnabled,collection,mark,mark4show,cellFontColor,cellFontSize,cellMessage,cellFont,cellFontType,cellBorderWidth,cellHidden,cellTextOnTop;


-(id)init
{
    self = [super init];
    self.cellBtnPlayIsEnabled=YES;
    self.collection = [[NSMutableArray alloc]init];
    self.mark = YES;
    self.mark4show = NO;
    self.cellBackgroundColor = CELLDEFAULTBACKGROUNDCOLOR;
    self.cellBorderColor = CELLDEFAULTFRAMECOLOR;
    self.cellBorderWidth = CELLDEFAULTFRAMEWIDTH;
    self.cellBoardLink = -1;
    self.cellCreatedBy = @"none";
    self.cellCreatedDate = [NSDate date];
    self.cellImageCol = -1;
    self.cellImageID = @"";
    self.cellImageRow = -1;
    self.cellIndex=-1;
    self.cellLastUpdateDate = [NSDate date];
    self.cellLastUpdatedBy = @"none";
    self.cellMP3Path = @"";
    self.cellSoundFilename = @"";
    self.cellSoundPath = @"";
    self.cellMessage = @"";
    self.cellText=@"";
    self.cellTextOnTop = FALSE;
    self.cellHidden = FALSE;
    self.cellFont=CELLDEFAULTFONT;
    self.cellFontColor = CELLDEFAULTFONTCOLOR;
    self.cellFontSize = CELLDEFAULTFONTSIZE;
    self.cellFontType = CELLDEFAULTFONTTYPE;
    self.cellVIDEOPath = @"";
    self.cellWEBPath = @"";
    
    return self;
}


-(id)copyWithZone:(NSZone *) zone
{
    
    
    Cell_class *cellCopy = [[Cell_class allocWithZone: zone] init];
    
    cellCopy.cellIndex = self.cellIndex;
    cellCopy.cellBackgroundColor = self.cellBackgroundColor;
    cellCopy.cellBoardID = self.cellBoardID;
    cellCopy.cellBoardLink = self.cellBoardLink;
    cellCopy.cellBorderColor = self.cellBorderColor;
    cellCopy.cellBorderWidth = self.cellBorderWidth;
    cellCopy.cellCreatedBy = self.cellCreatedBy;
    cellCopy.cellCreatedDate = self.cellCreatedDate;
    cellCopy.cellImageCol = self.cellImageCol;
    cellCopy.cellImageID = self.cellImageID;
    cellCopy.cellImageRow = self.cellImageRow;
    cellCopy.cellLastUpdateDate = self.cellLastUpdateDate;
    cellCopy.cellLastUpdatedBy = self.cellLastUpdatedBy;
    cellCopy.cellMP3Path =self.cellMP3Path;
    cellCopy.cellSoundFilename = self.cellSoundFilename;
    cellCopy.cellSoundPath = self.cellSoundPath;
    cellCopy.cellMessage = self.cellMessage;
    cellCopy.cellText = self.cellText;
    cellCopy.cellTextOnTop = self.cellTextOnTop;
    cellCopy.cellHidden = self.cellHidden;
    cellCopy.cellFont = self.cellFont;
    cellCopy.cellFontColor = self.cellFontColor;
    cellCopy.cellFontSize = self.cellFontSize;
    cellCopy.cellFontType = self.cellFontType;
    
    cellCopy.cellVIDEOPath =self.cellVIDEOPath;
    cellCopy.cellWEBPath =self.cellWEBPath;
    
    cellCopy.coordinates = self.coordinates;
    cellCopy.size = self.size;
    cellCopy.selected = self.selected;
    cellCopy.tag = self.tag;
    cellCopy.collection = self.collection;
    cellCopy.mark = self.mark;
    cellCopy.mark4show = self.mark4show;
    
    return cellCopy;
}

//- (NSComparisonResult)compare:(Cell_class *)cellX {
//    
//    self.cellIndex com
//    
//    return [[self cellIndex] compare:cellX.cellIndex] ];
//}

@end
