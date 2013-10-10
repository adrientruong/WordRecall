//
//  WRCWordDefinitionQuizPerformance+Custom.h
//  Word Recall
//
//  Created by Adrien Truong on 10/4/13.
//  Copyright (c) 2013 Adrien Truong. All rights reserved.
//

#import "WRCWordDefinitionQuizPerformance.h"

@interface WRCWordDefinitionQuizPerformance (Custom)

- (NSOrderedSet *)incorrectAnswers;
- (NSOrderedSet *)correctAnswers;

- (float)missPercentage;
- (float)correctPercentage;

- (NSUInteger)incorrectAnswerCount;
- (NSUInteger)correctAnswerCount;
- (NSUInteger)totalAnswerCount;
- (NSUInteger)correctAnswerStreakCount;

- (NSArray *)incorrectWordDefinitionAssociations;

- (NSDate *)lastAnswerDate;

@end
