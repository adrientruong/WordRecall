//
//  WRCWord+Custom.m
//  Word Recall
//
//  Created by Adrien Truong on 10/4/13.
//  Copyright (c) 2013 Adrien Truong. All rights reserved.
//

#import "WRCWord+Custom.h"

@implementation WRCWord (Custom)

- (WRCWordDefinition *)quizDefinition
{
    
    if ((NSInteger)[self.definitions count] - 1 < self.quizDefinitionIndex) {
        
        return nil;
        
    }
    
    return self.definitions[self.quizDefinitionIndex];
    
}

@end
