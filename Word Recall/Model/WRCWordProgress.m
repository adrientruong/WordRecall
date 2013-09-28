//
//  WRCWordProgress.m
//  Word Recall
//
//  Created by Adrien Truong on 9/22/13.
//  Copyright (c) 2013 Adrien Truong. All rights reserved.
//

#import "WRCWordProgress.h"
#import "WRCWordInfo.h"

@interface WRCWordProgress ()

@property (nonatomic, strong) NSMutableDictionary *quizCounts;
@property (nonatomic, strong) NSMutableDictionary *missCounts;

@end

@implementation WRCWordProgress

#pragma mark - Quiz Counts

- (void)incrementQuizCountForWord:(NSString *)word
{
    
    NSInteger quizCount = [self quizCountForWord:word];
    
    quizCount++;
    
    self.quizCounts[word] = @(quizCount);
    
}

- (NSInteger)quizCountForWord:(NSString *)word
{
    
    NSNumber *quizCountNumber = self.quizCounts[word];
    
    NSInteger quizCount = [quizCountNumber integerValue];
    
    return quizCount;
    
}

#pragma mark - Miss Counts

- (void)incrementMissCountForWord:(NSString *)word
{
    
    NSInteger missCount = [self missCountForWord:word];
    
    missCount++;
    
    self.missCounts[word] = @(missCount);
    
}

- (NSInteger)missCountForWord:(NSString *)word
{
    
    NSNumber *missCountNumber = self.missCounts[word];
    
    NSInteger missCount = [missCountNumber integerValue];
    
    return missCount;
    
}

- (float)missPercentageForWord:(NSString *)word
{
    
    NSInteger missCount = [self missCountForWord:word];
    
    NSInteger quizCount = [self quizCountForWord:word];
    
    float missPercentage = missCount/quizCount;
    
    return missPercentage;
    
}

- (NSArray *)wordsWithMissPercentageEqualToOrAbove:(float)percentage
{
    
    NSMutableArray *words = [NSMutableArray array];
    
    NSArray *wordsToTest = [self.wordInfo.synonyms arrayByAddingObject:self.wordInfo.word];
    
    for (NSString *word in wordsToTest) {
        
        float missPercentage = [self missPercentageForWord:word];
        
        if (missPercentage >= percentage) {
            
            [words addObject:word];
            
        }
        
    }
    
    return words;
    
}

@end
