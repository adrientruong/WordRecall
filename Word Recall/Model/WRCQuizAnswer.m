//
//  WRCQuizAnswer.m
//  Word Recall
//
//  Created by Adrien Truong on 10/4/13.
//  Copyright (c) 2013 Adrien Truong. All rights reserved.
//

#import "WRCQuizAnswer.h"
#import "WRCWordDefinition.h"
#import "WRCWordDefinitionQuizPerformance.h"


@implementation WRCQuizAnswer

@dynamic date;
@dynamic actualWordDefinition;
@dynamic pickedWordDefinitions;
@dynamic quizPerformance;

- (void)awakeFromInsert
{
    
    [super awakeFromInsert];
    
    [self setPrimitiveValue:[NSDate date] forKey:@"date"];
    
}

@end
