//
//  GOOWordInfoSearch.h
//  Word Recall
//
//  Created by Adrien Truong on 9/21/13.
//  Copyright (c) 2013 Adrien Truong. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GOOWordInfo;

@interface GOOWordInfoSearch : NSObject

- (instancetype)initWithWord:(NSString *)word;

- (void)startWithCompletionHandler:(void (^) (GOOWordInfo *, NSError *error))completionHandler;

- (void)cancel;

@property (nonatomic, copy, readonly) NSString *word;

@property (nonatomic, assign, getter = isSearching) BOOL searching;

@end
