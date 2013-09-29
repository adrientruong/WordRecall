//
//  GOOWordInfoSearch.m
//  Word Recall
//
//  Created by Adrien Truong on 9/21/13.
//  Copyright (c) 2013 Adrien Truong. All rights reserved.
//

#import "GOOWordInfoSearch.h"
#import <AFNetworking.h>
#import "GOOJSONPResponseSerializer.h"
#import "GOOWordInfo.h"
#import "GOOWordDefinition.h"

@interface GOOWordInfoSearch ()

@property (nonatomic, copy, readwrite) NSString *word;

@property (nonatomic, strong) AFHTTPRequestOperation *requestOperation;

@end

@implementation GOOWordInfoSearch

- (instancetype)initWithWord:(NSString *)word
{
    
    self = [super init];
    
    if (self != nil) {
        
        self.word = word;
        
    }
    
    return self;
    
}

#pragma mark - Forming URL

- (NSString *)URLStringForWord:(NSString *)word
{
    
    NSString *templateURLString = @"http://www.google.com/dictionary/json?callback=a&sl=en&tl=en&q=%@";
    
    NSString *URLString = [NSString stringWithFormat:templateURLString, word];
    
    return URLString;
    
}

- (NSURL *)URLForWord:(NSString *)word;
{
    
    NSString *URLString = [self URLStringForWord:word];
    
    NSURL *URL = [NSURL URLWithString:URLString];
    
    return URL;
    
}

#pragma mark - Starting/Stopping Search

- (void)startWithCompletionHandler:(void (^)(GOOWordInfo *, NSError *error))completionHandler
{
    
    if (completionHandler == nil) {
        
        return;
        
    }
    
    NSURL *URL = [self URLForWord:self.word];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    self.requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    self.requestOperation.responseSerializer = [GOOJSONPResponseSerializer serializer];
    
    __weak GOOWordInfoSearch *weakSelf = self;
    
    [self.requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        GOOWordInfo *wordInfo = [[GOOWordInfo alloc] init];
        
        wordInfo.word = weakSelf.word;
        
        NSDictionary *responseDictionary = responseObject;
        
        NSArray *primaries = responseDictionary[@"primaries"];
        
        NSMutableArray *definitions = [NSMutableArray array];
        
        for (NSDictionary *primaryDictionary in primaries) {
            
            GOOWordDefinition *wordDefinition = [[GOOWordDefinition alloc] init];
            
            NSArray *terms = primaryDictionary[@"terms"];
            
            for (NSDictionary *termDictionary in terms) {
                
                GOOWordDefinition *wordDefinition = [[GOOWordDefinition alloc] init];

                NSString *type = termDictionary[@"type"];
                
                if ([type isEqualToString:@"text"]) {
                
                    wordInfo.word = termDictionary[@"text"];
                    
                    NSArray *labels = termDictionary[@"labels"];
                    
                    for (NSDictionary *labelDictionary in labels) {
                        
                        NSString *title = labelDictionary[@"title"];
                        
                        if ([title isEqualToString:@"Part-of-speech"]) {
                            
                            wordDefinition.partOfSpeech = title;
                            
                        }
                        
                        break;
                        
                    }
                    
                }
                
                if ([wordInfo.word length] > 0) {
                    
                    break;
                    
                }
                
            }
            
            NSArray *entries = primaryDictionary[@"entries"];
            
            for (NSDictionary *entry in entries) {
                
                NSString *type = entry[@"type"];
                
                if ([type isEqualToString:@"meaning"]) {
                    
                    NSArray *terms = entry[@"terms"];
                    
                    wordDefinition.definition = terms[0][@"text"];
                    
                    NSArray *innerEntries = entry[@"entries"];
                    
                    NSMutableArray *exampleSentences = [NSMutableArray array];
                    
                    for (NSDictionary *innerEntry in innerEntries) {
                        
                        NSString *innerEntryType = innerEntry[@"type"];
                        
                        if ([innerEntryType isEqualToString:@"example"]) {
                            
                            NSArray *innerEntryTerms = innerEntry[@"terms"];
                            
                            NSDictionary *innerEntryTerm = [innerEntryTerms firstObject];
                            
                            NSString *exampleSentence = innerEntryTerm[@"text"];
                            
                            [exampleSentences addObject:exampleSentence];
                            
                        }
                        
                    }
                    
                    wordDefinition.exampleSentences = exampleSentences;
                    
                    break;
                    
                }
                
            }
            
            [definitions addObject:wordDefinition];
            
        }
        
        wordInfo.definitions = definitions;
        
        completionHandler(wordInfo, nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
        completionHandler(nil, error);
        
    }];
    
    [self.requestOperation start];
    
}

- (void)cancel
{
    
    [self.requestOperation cancel];
    
    self.requestOperation = nil;
    
}

@end
