//
//  NSMutableArray+funcs4Array.h
//  Match Them
//
//  Created by Simona Tzalik on 23/1/15.
//  Copyright (c) 2015 Techno M.A.G. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (funcs4Array)

-(void)shuffle_array;
-(id)check_duplicates;
-(void)switch_itemsbetweenItemAtIndex:(int)indexA andItemAtIndex:(int)indexB;
-(void)sortArraybyNSNumber:(NSArray*)theArray;
@end
