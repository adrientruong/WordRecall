//
//  WRCWordStore.m
//  Word Recall
//
//  Created by Adrien Truong on 9/27/13.
//  Copyright (c) 2013 Adrien Truong. All rights reserved.
//

#import "WRCWordStore.h"
#import "ATCoreDataStack.h"
#import <CoreData/CoreData.h>
#import "WRCWord.h"
#import "WRCWordDefinition.h"
#import "NSManagedObjectContext+RandomObject.h"
#import "WRCWordDefinitionQuizPerformance.h"
#import "WRCQuizAnswer.h"
#import "WRCWordDefinitionQuizPerformance+Custom.h"
#import "WRCWord+Custom.h"

@interface WRCWordStore ()

@property (nonatomic, strong) ATCoreDataStack *coreDataStack;
@property (nonatomic, strong) NSCalendar *calendar;

- (WRCWordDefinitionQuizPerformance *)insertWordDefinitionQuizPerformance;

@end

@implementation WRCWordStore

#pragma mark - Init

- (instancetype)initWithURL:(NSURL *)URL
{
    self = [super init];
    
    if (self != nil) {
        _URL = [URL copy];
        
        NSURL *managedObjectModelURL = [[NSBundle mainBundle] URLForResource:@"WRCWordRecallModel" withExtension:@"momd"];
        _coreDataStack = [[ATCoreDataStack alloc] initWithManagedObjectModelURL:managedObjectModelURL storeURL:_URL];
    }
    
    return self;
}

#pragma mark - Calendar

- (NSCalendar *)calendar
{
    if (_calendar == nil) {
        self.calendar = [NSCalendar currentCalendar];
    }
    
    return _calendar;
}

#pragma mark - Inserting

- (NSManagedObject *)insertObjectWithEntityName:(NSString *)entityName
{
    return [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:self.coreDataStack.managedObjectContext];
}

- (WRCWord *)insertWord
{
    return (WRCWord *)[self insertObjectWithEntityName:NSStringFromClass([WRCWord class])];
}

- (WRCWordDefinition *)insertWordDefinition
{
    WRCWordDefinition *definition = (WRCWordDefinition *)[self insertObjectWithEntityName:NSStringFromClass([WRCWordDefinition class])];
    WRCWordDefinitionQuizPerformance *quizPerformance = [self insertWordDefinitionQuizPerformance];
    
    definition.quizPerformance = quizPerformance;
    
    return definition;
}

#pragma mark - Removing

- (void)removeWord:(WRCWord *)word
{
    [self.coreDataStack.managedObjectContext deleteObject:word];
}

- (WRCWordDefinitionQuizPerformance *)insertWordDefinitionQuizPerformance
{
    return (WRCWordDefinitionQuizPerformance *)[self insertObjectWithEntityName:NSStringFromClass([WRCWordDefinitionQuizPerformance class])];
}

- (WRCQuizAnswer *)insertQuizAnswerWithActualWordDefinition:(WRCWordDefinition *)actualWordDefinition pickedWordDefinitions:(NSSet *)pickedWordDefinitions
{
    WRCQuizAnswer *quizAnswer = (WRCQuizAnswer *)[self insertObjectWithEntityName:NSStringFromClass([WRCQuizAnswer class])];
    
    quizAnswer.actualWordDefinition = actualWordDefinition;
    quizAnswer.pickedWordDefinitions = pickedWordDefinitions;
    quizAnswer.quizPerformance = actualWordDefinition.quizPerformance;
    
    return quizAnswer;
}

#pragma mark - Fetch Requests

- (NSArray *)objectsForFetchRequest:(NSFetchRequest *)fetchRequest
{
    NSError *error = nil;
    NSArray *objects = [self.coreDataStack.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if (objects == nil) {
        NSLog(@"Error executing fetch request. Error:%@", [error userInfo]);
    }
    
    return objects;
}

#pragma mark - Finding Words

- (WRCWord *)wordWithWordString:(NSString *)wordString
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"word == %@", wordString];
    NSArray *words = [self wordsMatchingPredicate:predicate];
    WRCWord *word = [words firstObject];
    
    return word;
}

- (NSArray *)wordsMatchingPredicate:(NSPredicate *)predicate
{
    NSFetchRequest *fetchRequest = [self wordFetchRequest];
    [fetchRequest setPredicate:predicate];
    NSError *error = nil;
    NSArray *matchingWords = [self.coreDataStack.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if (matchingWords == nil) {
        NSLog(@"Error finding words matching predicate. Error:%@", [error userInfo]);
    }
    
    return matchingWords;
}

- (NSUInteger)countForWordsMatchingPredicate:(NSPredicate *)predicate;
{
    NSFetchRequest *fetchRequest = [self wordFetchRequest];
    [fetchRequest setPredicate:predicate];
    NSError *error = nil;
    NSUInteger count = [self.coreDataStack.managedObjectContext countForFetchRequest:fetchRequest error:&error];
    
    if (count == NSNotFound) {
        NSLog(@"Error counting objects:%@", [error userInfo]);
    }
    
    return count;
}

- (NSArray *)wordsNotSynonymOfWordWithDefinition:(WRCWordDefinition *)definition
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"NOT (definitions.synonyms CONTAINS %@)", definition];
    NSArray *matches = [self wordsMatchingPredicate:predicate];
    
    return matches;
}

- (BOOL)containsWord:(NSString *)word
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"word LIKE %@", word];
    NSUInteger count = [self countForWordsMatchingPredicate:predicate];
    
    return (count != 0);
}

- (WRCWord *)randomWordMatchingPredicate:(NSPredicate *)predicate
{
    return (WRCWord *)[self.coreDataStack.managedObjectContext randomObjectWithEntityName:NSStringFromClass([WRCWord class]) matchingPredicate:predicate];
}

- (WRCWord *)randomWordNotWord:(WRCWord *)word
{
    NSArray *array = nil;
    if (word != nil) {
        array = @[word];
    }
    
    return (WRCWord *)[self randomWordNotContainedInArray:array];
}

- (WRCWord *)randomWordNotContainedInArray:(NSArray *)words
{
    if (words == nil) {
        words = @[ ];
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"NOT (self IN %@)", words];
    
    return (WRCWord *)[self randomWordMatchingPredicate:predicate];
}

- (NSArray *)randomWordsMatchingPredicate:(NSPredicate *)predicate count:(NSInteger)count
{
    NSMutableArray *randomWords = [NSMutableArray arrayWithCapacity:count];
    NSPredicate *compoundPredicate = predicate;
    
    while ([randomWords count] < count) {
        WRCWord *randomWord = [self randomWordMatchingPredicate:compoundPredicate];
        [randomWords addObject:randomWord];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"NOT (self == %@)", randomWord];
        compoundPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[compoundPredicate, predicate]];
    }
    
    return [randomWords copy];
}

- (NSArray *)randomWordsNotIncludingWord:(WRCWord *)word count:(NSInteger)count
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"NOT (self == %@)", word];
    
    return [self randomWordsMatchingPredicate:predicate count:count];
}

- (WRCWordDefinition *)wordDefinitionDueForQuizzing
{
    return [[self wordDefinitionsDueForQuizzingWithMaxCount:1] firstObject];
}

- (NSArray *)wordDefinitionsDueForQuizzingWithMaxCount:(NSUInteger)count
{
    NSMutableArray *wordDefinitionsDueForQuizzing = [NSMutableArray array];
    NSFetchRequest *wordDefinitionFetchRequest = [self wordDefinitionFetchRequest];
    wordDefinitionFetchRequest.fetchBatchSize = 100;
    NSArray *wordDefinitions = [self objectsForFetchRequest:wordDefinitionFetchRequest];
    
    NSDate *currentDate = [NSDate date];
    
    for (WRCWordDefinition *definition in wordDefinitions) {
        if ([definition.word quizDefinition] != definition) {
            continue;
        }
        
        WRCWordDefinitionQuizPerformance *quizPerformance = definition.quizPerformance;
        NSDate *lastAnswerDate = [quizPerformance lastAnswerDate];
        
        if (lastAnswerDate == nil) {
            [wordDefinitionsDueForQuizzing addObject:definition];
            
            if ([wordDefinitionsDueForQuizzing count] == count) {
                return wordDefinitionsDueForQuizzing;
            }
            
            continue;
        }
        
        NSDate *nextQuizDate = [self nextQuizDateForWordDefinition:definition];
        
        if ([nextQuizDate earlierDate:currentDate] == nextQuizDate) {
            [wordDefinitionsDueForQuizzing addObject:definition];
            if ([wordDefinitionsDueForQuizzing count] == count) {
                return wordDefinitionsDueForQuizzing;
            }
        }
    }
    
    return wordDefinitionsDueForQuizzing;
}

- (NSDate *)nextQuizDateForWordDefinition:(WRCWordDefinition *)wordDefinition
{
    //days until next quiz = 5^(streak - 1)
    NSInteger hoursUntilNextQuiz = lroundf(pow(5, [wordDefinition.quizPerformance correctAnswerStreakCount] - 1) * 24);

    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.hour = hoursUntilNextQuiz;
    
    NSDate *nextQuizDate = [self.calendar dateByAddingComponents:dateComponents toDate:[wordDefinition.quizPerformance lastAnswerDate] options:0];
    
    return nextQuizDate;
}

- (WRCWordDefinition *)wordDefinitionWithEarliestQuizDateInFuture
{
    NSFetchRequest *wordDefinitionFetchRequest = [self wordDefinitionFetchRequest];
    wordDefinitionFetchRequest.fetchBatchSize = 100;
    NSArray *wordDefinitions = [self objectsForFetchRequest:wordDefinitionFetchRequest];
    NSDate *currentDate = [NSDate date];
    NSMutableArray *wordDefinitionsWithFutureQuizDates = [NSMutableArray array];
    
    for (WRCWordDefinition *definition in wordDefinitions) {
        if ([definition.word quizDefinition] != definition) {
            continue;
        }
        
        WRCWordDefinitionQuizPerformance *quizPerformance = definition.quizPerformance;
        NSDate *lastAnswerDate = [quizPerformance lastAnswerDate];
        
        if (lastAnswerDate == nil) {
            continue;
        }
        
        NSDate *nextQuizDate = [self nextQuizDateForWordDefinition:definition];
        if ([nextQuizDate laterDate:currentDate] == nextQuizDate) {
            [wordDefinitionsWithFutureQuizDates addObject:currentDate];
        }
    }
    
    [wordDefinitionsWithFutureQuizDates sortUsingComparator:^ NSComparisonResult(WRCWordDefinition *definition1, WRCWordDefinition *definition2) {
        NSDate *quizDate1 = [self nextQuizDateForWordDefinition:definition1];
        NSDate *quizDate2 = [self nextQuizDateForWordDefinition:definition2];
        
        return [quizDate1 compare:quizDate2];
    }];
    
    return [wordDefinitionsWithFutureQuizDates firstObject];
}

#pragma mark - NSFetchedResultsController

- (NSFetchedResultsController *)fetchedResultsControllerWithFetchRequest:(NSFetchRequest *)fetchRequest
                                                      sectionNameKeyPath:(NSString *)sectionNameKeyPath
                                                               cacheName:(NSString *)cacheName
{
    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.coreDataStack.managedObjectContext sectionNameKeyPath:sectionNameKeyPath cacheName:cacheName];
    
    return fetchedResultsController;
}

#pragma mark - Fetch Requests

- (NSFetchRequest *)wordFetchRequest
{
    return [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([WRCWord class])];
}


- (NSFetchRequest *)wordDefinitionFetchRequest
{
    return [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([WRCWordDefinition class])];
}

- (NSFetchRequest *)quizAnswerFetchRequest
{
    return [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([WRCQuizAnswer class])];
}

#pragma mark - Predicates

- (NSPredicate *)lastMissedQuizAnswersPredicate
{
    NSPredicate *missedWordDefinitionsPredicate = [NSPredicate predicateWithFormat:@"SUBQUERY(quizPerformance.answers, $x, $x.date > date AND $x != SELF).@count == 0 AND SUBQUERY(pickedWordDefinitions, $x, $x != actualWordDefinition).@count > 0"];
    
    return missedWordDefinitionsPredicate;
}

#pragma mark - Saving

- (BOOL)save
{
    NSError *error = nil;
    BOOL success = [self save:&error];
    if (success == NO) {
        NSLog(@"Error saving word store:%@", [error userInfo]);
    }
    
    return success;
}

- (BOOL)save:(NSError *__autoreleasing *)error
{
    return [self.coreDataStack.managedObjectContext save:error];
}

@end