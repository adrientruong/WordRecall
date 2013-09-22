//
//  WRCWordInfo.h
//  Word Recall
//
//  Created by Adrien Truong on 9/21/13.
//  Copyright (c) 2013 Adrien Truong. All rights reserved.
//

#import "ATArchivableObject.h"

@interface WRCWordInfo : ATArchivableObject

@property (nonatomic, copy) NSString *word;
@property (nonatomic, copy) NSString *definition;
@property (nonatomic, strong) NSMutableArray *synonyms;

- (BOOL)isEqualToWordInfo:(WRCWordInfo *)wordInfo;

@end
