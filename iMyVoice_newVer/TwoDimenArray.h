//
//  TwoDimenArray.h
//  iMyVoice_newVer
//
//  Created by Simona Tzalik on 9/9/15.
//  Copyright (c) 2015 Techno M.A.G. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TwoDimenArray : NSObject
{
    @private
    
    NSArray* matrix;
    size_t numRows;
    size_t numCols;
}

-(id) initWithRows:(size_t) rows Cols:(size_t)cols Values:(NSArray*)arrayWithValues;
-(id) objectAtRow:(size_t) row Col:(size_t)col;
-(id) updateWithRows:(size_t) rows Cols:(size_t)cols Values:(NSArray*)arrayWithValues;

@end
