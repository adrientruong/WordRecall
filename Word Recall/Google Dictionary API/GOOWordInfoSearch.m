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
        
        NSArray *entries = responseDictionary[@"primaries"][0][@"entries"];
        
        for (NSDictionary *entry in entries) {
            
            NSLog(@"keys:%@", [entry allKeys]);
            
            NSString *type = entry[@"type"];
            
            if ([type isEqualToString:@"meaning"]) {
                
                NSArray *terms = entry[@"terms"];
                
                wordInfo.definition = terms[0][@"text"];
                
                break;
                
            }
            
        }
        
        completionHandler(wordInfo, nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
        NSLog(@"error:%@", error);
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
