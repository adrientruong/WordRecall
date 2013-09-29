//
//  GOOWordDefinition.h
//  Word Recall
//
//  Created by Adrien Truong on 9/28/13.
//  Copyright (c) 2013 Adrien Truong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GOOWordDefinition : NSObject

@property (nonatomic, copy) NSString *partOfSpeech;
@property (nonatomic, copy) NSString *definition;
@property (nonatomic, strong) NSArray *exampleSentences;

@end
