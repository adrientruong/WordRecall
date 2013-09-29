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
#import "WRCQuizWord.h"
#import "WRCQuizViewController.h"
#import "WRCWordStore.h"
#import "WRCWordDefinition.h"

@interface WRCAppDelegate ()

@property (nonatomic, strong) NSMutableArray *wordInfoSearches;

@property (nonatomic, strong) WRCWordStore *wordStore;

@end

@implementation WRCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];

    WRCQuizViewController *quizViewController = [[WRCQuizViewController alloc] init];
    
    self.window.rootViewController = quizViewController;
    
    [self setupWordStore];
    
    __weak WRCAppDelegate *weakSelf = self;
    
    [self addNewWordsIfNeccessaryWithCompletionHandler:^{
        
        quizViewController.wordStore = [weakSelf wordStore];
        
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
        
        BOOL wordAlreadyInStore = NO;
        
        for (NSString *wordString in wordStrings) {
            
            wordAlreadyInStore = [self.wordStore containsWord:wordString];
            
            if (wordAlreadyInStore) {
                
                break;
                
            }
            
            WRCQuizWord *word = [self.wordStore insertQuizWord];
            
            word.word = wordString;
            
            [words addObject:word];
            
        }
        
        if (wordAlreadyInStore) {
            
            completions += [wordStrings count];
            
            if (completions == neededCompletions) {
                
                completionBlock();
                
            }

            continue;
            
        }
        else {
            
            [insertedCombinedWordStrings addObject:combinedWordString];
            
        }
        
        for (NSInteger i = 0; i < [wordStrings count]; i++) {
            
            WRCQuizWord *word = words[i];
            
            GOOWordInfoSearch *search = [[GOOWordInfoSearch alloc] initWithWord:word.word];
            
            [search startWithCompletionHandler:^(GOOWordInfo *googleWordInfo, NSError *error) {
              
                for (GOOWordDefinition *googleWordDefinition in googleWordInfo.definitions) {
                    
                    WRCWordDefinition *wordDefinition = [self.wordStore insertWordDefinition];
                    
                    wordDefinition.word = word;
                    
                    wordDefinition.definition = googleWordDefinition.definition;
                    wordDefinition.exampleSentence = [googleWordDefinition.exampleSentences firstObject];
                    
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
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
