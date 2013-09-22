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
#import "ATObjectStore.h"
#import "NSURL+SystemDirectories.h"
#import "WRCWordInfo.h"
#import "WRCQuizViewController.h"

@interface WRCAppDelegate ()

@property (nonatomic, strong) NSMutableArray *wordInfoSearches;

@end

@implementation WRCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];

    WRCQuizViewController *quizViewController = [[WRCQuizViewController alloc] init];
    
    self.window.rootViewController = quizViewController;
    
    __weak WRCAppDelegate *weakSelf = self;
    
    [self addNewWordsIfNeccessaryWithCompletionHandler:^{
        
        quizViewController.wordStore = [weakSelf wordStore];
        
    }];
    
    [self.window makeKeyAndVisible];
    
    return YES;
    
}

- (ATObjectStore *)wordStore
{
    
    NSURL *wordStoreURL = [[NSURL documentsDirectoryURL] URLByAppendingPathComponent:@"WordStore"];

    ATObjectStore *wordStore = [ATObjectStore sharedObjectStoreWithURL:wordStoreURL createAndRegisterIfNeeded:YES];

    return wordStore;
    
}

- (void)addNewWordsIfNeccessaryWithCompletionHandler:(void (^) (void))completionHandler;
{
    
    ATObjectStore *wordStore = [self wordStore];
    
    NSString *wordListPath = [[NSBundle mainBundle] pathForResource:@"WRCWordList" ofType:@"plist"];
    
    NSArray *wordList = [NSArray arrayWithContentsOfFile:wordListPath];
    
    __block NSInteger completions = 0;
    NSInteger neededCompletions = [wordList count];
    
    self.wordInfoSearches = [NSMutableArray array];
    
    for (NSString *word in wordList) {
                
        WRCWordInfo *wordInfo = [[WRCWordInfo alloc] init];
        
        NSMutableArray *words = [[word componentsSeparatedByString:@", "] mutableCopy];
        
        wordInfo.word = words[0];
        
        [words removeObjectAtIndex:0];
        
        wordInfo.synonyms = words;
        
        if ([wordStore containsObject:wordInfo] == NO) {
            
            GOOWordInfoSearch *search = [[GOOWordInfoSearch alloc] initWithWord:wordInfo.word];
            
            [search startWithCompletionHandler:^(GOOWordInfo *googleWordInfo, NSError *error) {
                
                wordInfo.definition = googleWordInfo.definition;
                
                if ([wordInfo.definition length] == 0) {
                    
                    NSLog(@"Cannot find definition for word:%@", wordInfo.word);
                    
                }
                else {
                    
                    [wordStore addObject:wordInfo];

                }
                
                completions++;
                
                if (completions == neededCompletions) {
                    
                    self.wordInfoSearches = nil;

                    completionHandler();
                    
                }
                
            }];
            
            [self.wordInfoSearches addObject:search];
            
        }
        else {
            
            completions++;
            
            if (completions == neededCompletions) {
                
                self.wordInfoSearches = nil;

                completionHandler();
                
            }
            
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
