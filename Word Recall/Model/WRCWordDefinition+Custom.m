//
//  WRCWordDefinition+Custom.m
//  Word Recall
//
//  Created by Adrien Truong on 9/27/13.
//  Copyright (c) 2013 Adrien Truong. All rights reserved.
//

#import "WRCWordDefinition+Custom.h"

@implementation WRCWordDefinition (Custom)

- (NSURL *)pronunciationAudioURL
{
    
    NSURL *URL = [NSURL URLWithString:self.pronunciationAudioURLString];
    
    return URL;
    
}

@end
