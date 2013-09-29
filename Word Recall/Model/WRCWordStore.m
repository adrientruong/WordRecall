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
#import "WRCQuizWord.h"
#import "WRCWordDefinition.h"
#import "NSManagedObjectContext+RandomObject.h"

@interface WRCWordStore ()

@property (nonatomic, strong) ATCoreDataStack *coreDataStack;

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

#pragma mark - Inserting

- (NSManagedObject *)insertObjectWithEntityName:(NSString *)entityName
{
    
    return [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:self.coreDataStack.managedObjectContext];
    
}

- (WRCWord *)insertWord
{
    
    return (WRCWord *)[self insertObjectWithEntityName:NSStringFromClass([WRCWord class])];
    
}

- (WRCQuizWord *)insertQuizWord
{
 
    return (WRCQuizWord *)[self insertObjectWithEntityName:NSStringFromClass([WRCQuizWord class])];
    
}

- (WRCWordDefinition *)insertWordDefinition
{
    
    return (WRCWordDefinition *)[self insertObjectWithEntityName:NSStringFromClass([WRCWordDefinition class])];
    
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
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([WRCWord class])];
    
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
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([WRCWord class])];
    
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
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"NOT (self == %@)", randomWord];
        
        compoundPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[compoundPredicate, predicate]];
        
        [randomWords addObject:randomWord];
        
    }
    
    return [randomWords copy];
    
}

- (NSArray *)randomWordsNotIncludingWord:(WRCWord *)word count:(NSInteger)count
{
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"NOT (self == %@)", word];
    
    return [self randomWordsMatchingPredicate:predicate count:count];
    
}

#pragma mark - Saving

- (BOOL)save
{
    
    return [self save:nil];
    
}

- (BOOL)save:(NSError *__autoreleasing *)error
{
    
    return [self.coreDataStack.managedObjectContext save:error];
    
}

@end
