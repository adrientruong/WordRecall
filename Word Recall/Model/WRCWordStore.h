//
//  WRCWordStore.h
//  Word Recall
//
//  Created by Adrien Truong on 9/27/13.
//  Copyright (c) 2013 Adrien Truong. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WRCWordDefinition;
@class WRCWord;
@class WRCQuizWord;

@interface WRCWordStore : NSObject

@property (nonatomic, copy, readonly) NSURL *URL;

- (instancetype)initWithURL:(NSURL *)URL;

- (WRCWord *)insertWord;
- (WRCQuizWord *)insertQuizWord;
- (WRCWordDefinition *)insertWordDefinition;

- (WRCWord *)wordWithWordString:(NSString *)word;

- (NSArray *)wordsMatchingPredicate:(NSPredicate *)predicate;
- (NSArray *)wordsNotSynonymOfWordWithDefinition:(WRCWordDefinition *)definition;
- (NSUInteger)countForWordsMatchingPredicate:(NSPredicate *)predicate;

- (WRCWord *)randomWordMatchingPredicate:(NSPredicate *)predicate;
- (WRCWord *)randomWordNotWord:(WRCWord *)word;
- (WRCWord *)randomWordNotContainedInArray:(NSArray *)words;
- (NSArray *)randomWordsMatchingPredicate:(NSPredicate *)predicate count:(NSInteger)count;
- (NSArray *)randomWordsNotIncludingWord:(WRCWord *)word count:(NSInteger)count;

- (BOOL)containsWord:(NSString *)word;

- (BOOL)save;
- (BOOL)save:(NSError **)error;

@end
