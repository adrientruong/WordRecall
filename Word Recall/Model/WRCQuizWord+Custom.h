//
//  WRCQuizWord+Custom.h
//  Word Recall
//
//  Created by Adrien Truong on 9/27/13.
//  Copyright (c) 2013 Adrien Truong. All rights reserved.
//

#import "WRCQuizWord.h"

@class WRCWordDefinition;

@interface WRCQuizWord (Custom)

- (void)incrementQuizCount;
- (void)incrementMissCount;

- (float)missPercentage;
- (float)correctPercentage;

- (WRCWordDefinition *)quizDefinition;

@end
