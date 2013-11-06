//
//  WRCWordDefinitionQuizPeformance+Custom.m
//  Word Recall
//
//  Created by Adrien Truong on 10/4/13.
//  Copyright (c) 2013 Adrien Truong. All rights reserved.
//

#import "WRCWordDefinitionQuizPerformance+Custom.h"
#import "WRCQuizAnswer.h"
#import "WRCQuizAnswer+Custom.h"

@implementation WRCWordDefinitionQuizPerformance (Custom)

#pragma mark - Getting Correct/Incorrect Answers

- (NSOrderedSet *)incorrectAnswers
{
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isCorrectOnFirstAttempt == NO"];
    
    NSOrderedSet *incorrectAnswers = [self.answers filteredOrderedSetUsingPredicate:predicate];

    return incorrectAnswers;
    
}

- (NSOrderedSet *)correctAnswers
{
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isCorrectOnFirstAttempt == YES"];
    
    NSOrderedSet *correctAnswers = [self.answers filteredOrderedSetUsingPredicate:predicate];
    
    return correctAnswers;
    
}

#pragma mark - Counts

- (NSInteger)incorrectAnswerCount
{
    
    NSOrderedSet *incorrectAnswers = [self incorrectAnswers];
    
    NSInteger incorrectAnswerCount = [incorrectAnswers count];
    
    return incorrectAnswerCount;
    
}

- (NSInteger)correctAnswerCount
{
    
    NSOrderedSet *correctAnswers = [self correctAnswers];
    
    NSInteger correctAnswerCount = [correctAnswers count];
    
    return correctAnswerCount;
    
}

- (NSInteger)totalAnswerCount
{
    
    return [self.answers count];
    
}

- (NSInteger)correctAnswerStreakCount
{
    
    NSInteger correctAnswerStreakCount = 0;
    
    for (NSInteger i = [self.answers count] - 1; i >= 0; i--) {
        
        WRCQuizAnswer *answer = self.answers[i];
        
        if ([answer isCorrectOnFirstAttempt]) {
            
            correctAnswerStreakCount++;
            
        }
        else {
            
            break;
            
        }
        
    }
    
    return correctAnswerStreakCount;
    
}

#pragma mark - Percentages

- (float)missPercentage
{
    
    float missPercentage = [self incorrectAnswerCount] / [self totalAnswerCount];
    
    return missPercentage;
    
}

- (float)correctPercentage
{
    
    float correctPercentage = [self correctAnswerCount] / [self totalAnswerCount];
    
    return correctPercentage;
    
}

#pragma mark - Incorrect Word Associations

- (NSArray *)incorrectWordDefinitionAssociations
{
    
    NSOrderedSet *incorrectAnswers = [self incorrectAnswers];
    
    NSMutableSet *incorrectWordDefinitionAssociations = [NSMutableSet set];
    
    for (WRCQuizAnswer *answer in incorrectAnswers) {
        
        NSMutableSet *pickedDefinitions = [answer.pickedWordDefinitions mutableCopy];
        
        [pickedDefinitions removeObject:self.wordDefinition];
        
        [incorrectWordDefinitionAssociations addObjectsFromArray:[pickedDefinitions allObjects]];
        
    }
    
    return [incorrectWordDefinitionAssociations allObjects];
    
}

#pragma mark - Last Answer Date

- (NSDate *)lastAnswerDate
{
    
    WRCQuizAnswer *lastAnswer = [self.answers lastObject];
    
    return lastAnswer.date;
    
}

@end
