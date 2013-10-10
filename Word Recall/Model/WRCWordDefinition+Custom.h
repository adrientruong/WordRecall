//
//  WRCWordDefinition+Custom.h
//  Word Recall
//
//  Created by Adrien Truong on 9/27/13.
//  Copyright (c) 2013 Adrien Truong. All rights reserved.
//

#import "WRCWordDefinition.h"

typedef NS_ENUM(NSInteger, WRCWordPartOfSpeech) {
    
    WRCWordPartOfSpeechNoun = 0,
    WRCWordPartOfSpeechVerb,
    WRCWordPartOfSpeechAdjective,
    
};

@interface WRCWordDefinition (Custom)

- (NSURL *)pronunciationAudioURL;

@end
