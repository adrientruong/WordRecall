//
//  GOOWordDefinition.h
//  Word Recall
//
//  Created by Adrien Truong on 9/28/13.
//  Copyright (c) 2013 Adrien Truong. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const GOOPartOfSpeechAdjective;
extern NSString *const GOOPartOfSpeechNoun;
extern NSString *const GOOPartOfSpeechVerb;

@interface GOOWordDefinition : NSObject

@property (nonatomic, copy) NSString *partOfSpeech;
@property (nonatomic, copy) NSString *definition;
@property (nonatomic, strong) NSArray *exampleSentences;
@property (nonatomic, copy) NSURL *pronunciationAudioURL;

@end
