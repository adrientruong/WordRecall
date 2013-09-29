//
//  WRCQuizWord+Custom.m
//  Word Recall
//
//  Created by Adrien Truong on 9/27/13.
//  Copyright (c) 2013 Adrien Truong. All rights reserved.
//

#import "WRCQuizWord+Custom.h"

@implementation WRCQuizWord (Custom)

#pragma mark - Incrementing Counts

- (void)incrementQuizCount
{
    
    self.quizCount++;
    
}

- (void)incrementMissCount
{
    
    self.missCount++;
    
}

#pragma mark - Percentages

- (float)missPercentage
{
    
    float missPercentage = self.missCount / self.quizCount;
    
    return missPercentage;
    
}

- (float)correctPercentage
{
    
    NSInteger correctCount = self.quizCount - self.missCount;
    
    float correctPercentage = correctCount / self.quizCount;
    
    return correctPercentage;
    
}

#pragma mark - Quiz Definition

- (WRCWordDefinition *)quizDefinition
{
    
    WRCWordDefinition *quizDefinition = self.definitions[self.quizDefinitionIndex];
    
    return quizDefinition;
    
}


@end
