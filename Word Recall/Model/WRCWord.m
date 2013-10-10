//
//  WRCWord.m
//  Word Recall
//
//  Created by Adrien Truong on 10/4/13.
//  Copyright (c) 2013 Adrien Truong. All rights reserved.
//

#import "WRCWord.h"
#import "WRCWordDefinition.h"


@implementation WRCWord

@dynamic word;
@dynamic wordInitial;
@dynamic quizDefinitionIndex;
@dynamic definitions;

- (NSString *)wordInitial
{
    
    [self willAccessValueForKey:@"wordInitial"];
    
    NSString *initial = [self.word substringToIndex:1];
    
    [self didAccessValueForKey:@"wordInitial"];
    
    return initial;
    
}

@end
