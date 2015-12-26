//
//  NSMutableArray+funcs4Array.m
//  Match Them
//
//  Created by Simona Tzalik on 23/1/15.
//  Copyright (c) 2015 Techno M.A.G. All rights reserved.
//

#import "NSMutableArray+funcs4Array.h"

@implementation NSMutableArray (funcs4Array)

- (void)shuffle_array
{
    NSUInteger count = [self count];
    for (NSUInteger i = 0; i < count; ++i) {
        NSInteger remainingCount = count - i;
        NSInteger exchangeIndex = i + arc4random_uniform((u_int32_t )remainingCount);
        [self exchangeObjectAtIndex:i withObjectAtIndex:exchangeIndex];
    }
}

-(id)check_duplicates
{
    id DuplicateItem=nil;
   // int arrayCount=self.count;
    int cnt;
    
    for (id obj in self)
    {
        cnt=0;
        for (int i=0; i<self.count; i++) {
             if(self[i]==obj)  cnt++;
        }
       if (cnt>1)
        {
            DuplicateItem=obj;
            break;
        }
    }

    return DuplicateItem;
}

-(void)switch_itemsbetweenItemAtIndex:(int)indexA andItemAtIndex:(int)indexB
{
    id obj = self[indexA];
    self[indexA] = self[indexB];
    self[indexB]=obj;
    
}

-(void)sortArraybyNSNumber:(NSArray *)theArray
{
  
  //  NSArray *sortedArray; sortedArray = [anArray sortedArrayUsingFunction:intSort context:NULL];
    
    
//    NSInteger intSort(id num1, id num2, void *context)
//    {
//        int v1 = [num1 intValue];
//        int v2 = [num2 intValue];
//        if (v1 < v2)
//            return NSOrderedAscending;
//        else if (v1 > v2)
//            return NSOrderedDescending;
//        else
//            return NSOrderedSame;
//    }
//    A sorted version of anArray is created in this way:
    
    

}
@end

