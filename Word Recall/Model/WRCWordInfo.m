//
//  WRCWordInfo.m
//  Word Recall
//
//  Created by Adrien Truong on 9/21/13.
//  Copyright (c) 2013 Adrien Truong. All rights reserved.
//

#import "WRCWordInfo.h"

@implementation WRCWordInfo

- (BOOL)isEqual:(id)object
{
    
    if ([object isKindOfClass:[self class]]) {
        
        WRCWordInfo *otherWord = object;
        
        if ([otherWord.word isEqualToString:self.word]) {
            
            return YES;
            
        }
        
    }
    
    return NO;
    
}

- (NSUInteger)hash
{
    
    return [self.word hash];
    
}

@end
