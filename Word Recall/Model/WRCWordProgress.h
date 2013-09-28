//
//  WRCWordProgress.h
//  Word Recall
//
//  Created by Adrien Truong on 9/22/13.
//  Copyright (c) 2013 Adrien Truong. All rights reserved.
//

#import "ATArchivableObject.h"

@class WRCWordInfo;

@interface WRCWordProgress : ATArchivableObject

@property (nonatomic, strong) WRCWordInfo *wordInfo;

- (void)incrementQuizCountForWord:(NSString *)word;
- (NSInteger)quizCountForWord:(NSString *)word;

- (void)incrementMissCountForWord:(NSString *)word;
- (NSInteger)missCountForWord:(NSString *)word;

- (float)missPercentageForWord:(NSString *)word;

- (NSArray *)wordsWithMissPercentageEqualToOrAbove:(float)percentage;

@end
