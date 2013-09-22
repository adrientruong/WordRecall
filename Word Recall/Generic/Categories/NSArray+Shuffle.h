//
//  NSArray+Shuffle.h
//  Word Recall
//
//  Created by Adrien Truong on 9/21/13.
//  Copyright (c) 2013 Adrien Truong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Shuffle)

- (instancetype)arrayByShuffling;

@end

@interface NSMutableArray (Shuffle)

- (void)shuffle;

@end
