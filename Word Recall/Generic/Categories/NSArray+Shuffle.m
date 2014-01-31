//
//  NSArray+Shuffle.m
//  Word Recall
//
//  Created by Adrien Truong on 9/21/13.
//  Copyright (c) 2013 Adrien Truong. All rights reserved.
//

#import "NSArray+Shuffle.h"

@implementation NSArray (Shuffle)

- (instancetype)arrayByShuffling
{
    NSMutableArray *mutableArray = [self mutableCopy];
    [mutableArray shuffle];
    
    return [mutableArray copy];
}

@end

@implementation NSMutableArray (Shuffle)

- (void)shuffle
{
    NSUInteger count = [self count];
    for (NSUInteger i = 0; i < count; ++i) {
        NSInteger numberOfElements = count - i;
        NSInteger randomIndex = arc4random_uniform(numberOfElements) + i;
        [self exchangeObjectAtIndex:i withObjectAtIndex:randomIndex];
        
    }
}

@end