//
//  WRCAppDelegate.m
//  Word Recall
//
//  Created by Adrien Truong on 9/21/13.
//  Copyright (c) 2013 Adrien Truong. All rights reserved.
//

#import "WRCAppDelegate.h"
#import "GOOWordInfoSearch.h"
#import "GOOWordInfo.h"
#import "GOOWordDefinition.h"
#import "ATObjectStore.h"
#import "NSURL+SystemDirectories.h"
#import "WRCWord.h"
#import "WRCQuizViewController.h"
#import "WRCWordStore.h"
#import "WRCWordDefinition.h"
#import "WRCWordListViewController.h"
#import "WRCWordDefinition+Custom.h"

@interface WRCAppDelegate ()

@property (nonatomic, strong) NSMutableArray *wordInfoSearches;
@property (nonatomic, strong) WRCWordStore *wordStore;

@end

@implementation WRCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];

    UIStoryboard *quizStoryboard = [UIStoryboard storyboardWithName:@"WRCQuizStoryboard" bundle:nil];
    WRCQuizViewController *quizViewController = [quizStoryboard instantiateInitialViewController];
    
    UIStoryboard *wordListStoryboard = [UIStoryboard storyboardWithName:@"WRCWordListStoryboard" bundle:nil];
    UINavigationController *quizWordListNavigationController = [wordListStoryboard instantiateInitialViewController];
    WRCWordListViewController *quizWordListViewController = (WRCWordListViewController *)quizWordListNavigationController.topViewController;
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    [tabBarController setViewControllers:@[quizViewController, quizWordListNavigationController]];
    
    self.window.rootViewController = tabBarController;
    
    [self setupWordStore];
    __weak WRCAppDelegate *weakSelf = self;
    [self addNewWordsIfNeccessaryWithCompletionHandler:^{
        
        quizViewController.wordStore = [weakSelf wordStore];
        quizWordListViewController.wordStore = [weakSelf wordStore];
        
    }];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)setupWordStore
{
    NSURL *wordStoreURL = [[NSURL documentsDirectoryURL] URLByAppendingPathComponent:@"WordStore.sqlite"];
    self.wordStore = [[WRCWordStore alloc] initWithURL:wordStoreURL];
}

- (void)addNewWordsIfNeccessaryWithCompletionHandler:(void (^) (void))completionHandler;
{
    NSString *wordListPath = [[NSBundle mainBundle] pathForResource:@"WRCWordList" ofType:@"plist"];
    NSArray *wordList = [NSArray arrayWithContentsOfFile:wordListPath];
    
    __block NSInteger completions = 0;
    NSInteger neededCompletions = 0;
    
    for (NSString *combinedWordString in wordList) {
        NSMutableArray *wordStrings = [[combinedWordString componentsSeparatedByString:@", "] mutableCopy];

        neededCompletions += [wordStrings count];
    }
    
    self.wordInfoSearches = [NSMutableArray array];
    NSMutableArray *insertedCombinedWordStrings = [NSMutableArray array];
    
    void (^completionBlock)() = ^{
        self.wordInfoSearches = nil;
        
        for (NSString *combinedWordString in insertedCombinedWordStrings) {
            NSMutableArray *wordStrings = [[combinedWordString componentsSeparatedByString:@", "] mutableCopy];
            NSMutableArray *words = [NSMutableArray array];
            for (NSString *wordString in wordStrings) {
                WRCWord *word = [self.wordStore wordWithWordString:wordString];
                [words addObject:word];
            }
            
            NSMutableArray *wordDefinitionOrderedSets = [[words valueForKey:@"definitions"] mutableCopy];
            for (NSInteger i = 0; i < [words count]; i++) {
                WRCWord *word = words[i];
                [wordDefinitionOrderedSets removeObject:[word.definitions firstObject]];
                NSMutableArray *wordDefinitions = [NSMutableArray arrayWithCapacity:[wordDefinitionOrderedSets count]];
                for (NSOrderedSet *definitionsOrderdSet in wordDefinitionOrderedSets) {
                    WRCWordDefinition *definition = [definitionsOrderdSet firstObject];
                    if (definition != nil) {
                        [wordDefinitions addObject:definition];
                    }
                }
                
                WRCWordDefinition *definition = [word.definitions firstObject];
                definition.synonyms = [NSSet setWithArray:wordDefinitions];
            }
        }
        
        [self.wordStore save];
        completionHandler();
    };

    for (NSString *combinedWordString in wordList) {
        NSMutableArray *wordStrings = [[combinedWordString componentsSeparatedByString:@", "] mutableCopy];
        NSMutableArray *words = [NSMutableArray array];
        BOOL wordAlreadyInStore = [self.wordStore containsWord:[wordStrings firstObject]];
        if (wordAlreadyInStore) {
            completions += [wordStrings count];
            
            if (completions == neededCompletions) {
                completionBlock();
            }

            continue;
        }
        else {
            for (NSString *wordString in wordStrings) {
                WRCWord *word = [self.wordStore insertWord];
                word.word = wordString;
                
                [words addObject:word];
            }
            
            [insertedCombinedWordStrings addObject:combinedWordString];
        }
        
        NSDictionary *partOfSpeechConversion = @{GOOPartOfSpeechAdjective : @(WRCWordPartOfSpeechAdjective), GOOPartOfSpeechNoun : @(WRCWordPartOfSpeechNoun), GOOPartOfSpeechVerb : @(WRCWordPartOfSpeechVerb)};
        for (NSInteger i = 0; i < [wordStrings count]; i++) {
            WRCWord *word = words[i];
            GOOWordInfoSearch *search = [[GOOWordInfoSearch alloc] initWithWord:word.word];
            
            [search startWithCompletionHandler:^(GOOWordInfo *googleWordInfo, NSError *error) {
                if (googleWordInfo == nil) {
                    NSLog(@"Error occured:%@ for word:%@", [error userInfo], word.word);
                }
                
                for (GOOWordDefinition *googleWordDefinition in googleWordInfo.definitions) {
                    WRCWordDefinition *wordDefinition = [self.wordStore insertWordDefinition];
                    
                    wordDefinition.word = word;
                    wordDefinition.definition = googleWordDefinition.definition;
                    wordDefinition.exampleSentence = [googleWordDefinition.exampleSentences firstObject];
                    wordDefinition.partOfSpeech = [partOfSpeechConversion[googleWordDefinition.partOfSpeech] integerValue];
                    wordDefinition.pronunciationAudioURLString = [googleWordDefinition.pronunciationAudioURL absoluteString];
                }
                
                if ([googleWordInfo.definitions count] == 0) {
                    NSLog(@"Missing definition for word:%@", word.word);
                    
                    [self.wordStore removeWord:word];
                    [insertedCombinedWordStrings removeObject:combinedWordString];
                }
                                
                completions++;
                
                if (completions == neededCompletions) {
                    completionBlock();
                }
            }];
            
            [self.wordInfoSearches addObject:search];
        }
    }
}

@end