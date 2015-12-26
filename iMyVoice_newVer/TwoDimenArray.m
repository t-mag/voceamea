//
//  TwoDimenArray.m
//  iMyVoice_newVer
//
//  Created by Simona Tzalik on 9/9/15.
//  Copyright (c) 2015 Techno M.A.G. All rights reserved.
//

#import "TwoDimenArray.h"

@implementation TwoDimenArray



-(id) initWithRows:(size_t) rows Cols:(size_t)cols Values:(NSArray*)arrayWithValues
{
    self=[super init];
    if (self != nil) {
        if (rows * cols != [arrayWithValues count]) {
            return nil;
        }
        numRows = rows;
        numCols = cols;
        matrix = [arrayWithValues copy];
        
    }
    return self;
}
-(id) objectAtRow:(size_t) row Col:(size_t)col
{
    if (col >= numCols) {
        return nil;
    }
    if (row==0 && col == 0) {
        return [matrix objectAtIndex:0];
    }
    int resIndex = [[NSNumber numberWithUnsignedLong:((row-1) * numCols) + (col-1)] intValue];
    return [matrix objectAtIndex:resIndex+1];
}

-(id) updateWithRows:(size_t) rows Cols:(size_t)cols Values:(NSArray*)arrayWithValues
{
    if (rows * cols != [arrayWithValues count]) {
        return nil;
    }
    numRows = rows;
    numCols = cols;
    matrix = [arrayWithValues copy];
    return self;
}

@end
