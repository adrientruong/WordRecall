//
//  WRCWordInfo.m
//  Word Recall
//
//  Created by Adrien Truong on 9/21/13.
//  Copyright (c) 2013 Adrien Truong. All rights reserved.
//

#import "WRCWordInfo.h"

@implementation WRCWordInfo
@synthesize progress;

- (id)init
{
    
    self = [super init];
    
    if (self != nil) {
        
        
    }
    
    return self;
    
}

- (BOOL)isEqual:(id)object
{
    
    if ([object isKindOfClass:[self class]]) {
        
        WRCWordInfo *otherWord = object;
        
        if ([otherWord isEqualToWordInfo:self]) {
            
            return YES;
            
        }
        
    }
    
    return NO;
    
}

- (BOOL)isEqualToWordInfo:(WRCWordInfo *)wordInfo
{
    
    return [wordInfo.word isEqualToString:self.word];
    
}

- (NSUInteger)hash
{
    
    return [self.word hash];
    
}

@end
