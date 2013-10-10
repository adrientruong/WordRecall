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
@class WRCQuizAnswer;
@class NSFetchedResultsController;
@class NSFetchRequest;

@interface WRCWordStore : NSObject

@property (nonatomic, copy, readonly) NSURL *URL;

- (instancetype)initWithURL:(NSURL *)URL;

- (WRCWord *)insertWord;
- (WRCWordDefinition *)insertWordDefinition;
- (WRCQuizAnswer *)insertQuizAnswerWithActualWordDefinition:(WRCWordDefinition *)actualWordDefinition pickedWordDefinitions:(NSSet *)pickedWordDefinitions;

- (void)removeWord:(WRCWord *)word;

- (WRCWord *)wordWithWordString:(NSString *)word;

- (NSArray *)objectsForFetchRequest:(NSFetchRequest *)fetchRequest;
- (NSArray *)wordsMatchingPredicate:(NSPredicate *)predicate;
- (NSArray *)wordsNotSynonymOfWordWithDefinition:(WRCWordDefinition *)definition;
- (NSUInteger)countForWordsMatchingPredicate:(NSPredicate *)predicate;

- (WRCWord *)randomWordMatchingPredicate:(NSPredicate *)predicate;
- (WRCWord *)randomWordNotWord:(WRCWord *)word;
- (WRCWord *)randomWordNotContainedInArray:(NSArray *)words;
- (NSArray *)randomWordsMatchingPredicate:(NSPredicate *)predicate count:(NSInteger)count;
- (NSArray *)randomWordsNotIncludingWord:(WRCWord *)word count:(NSInteger)count;

- (BOOL)containsWord:(NSString *)word;

- (NSFetchedResultsController *)fetchedResultsControllerWithFetchRequest:(NSFetchRequest *)fetchRequest
                                                      sectionNameKeyPath:(NSString *)sectionNameKeyPath
                                                               cacheName:(NSString *)cacheName;

- (NSFetchRequest *)wordFetchRequest;
- (NSFetchRequest *)wordDefinitionFetchRequest;
- (NSFetchRequest *)quizAnswerFetchRequest;

- (NSPredicate *)lastMissedQuizAnswersPredicate;

- (WRCWordDefinition *)wordDefinitionDueForQuizzing;
- (NSArray *)wordDefinitionsDueForQuizzingWithMaxCount:(NSUInteger)count;
- (NSDate *)nextQuizDateForWordDefinition:(WRCWordDefinition *)wordDefinition;
- (WRCWordDefinition *)wordDefinitionWithEarliestQuizDateInFuture;

- (BOOL)save;
- (BOOL)save:(NSError **)error;

@end
