//
//  NSArray+RandomObject.m
//  Word Recall
//
//  Created by Adrien Truong on 9/21/13.
//  Copyright (c) 2013 Adrien Truong. All rights reserved.
//

#import "NSArray+RandomObject.h"

@implementation NSArray (RandomObject)

- (id)randomObject
{
    NSInteger randomIndex = arc4random_uniform([self count]);
    id randomObject = self[randomIndex];
    
    return randomObject;
}

@end
