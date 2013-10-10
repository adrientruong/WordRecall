//
//  WRCQuizAnswer+Custom.m
//  Word Recall
//
//  Created by Adrien Truong on 10/4/13.
//  Copyright (c) 2013 Adrien Truong. All rights reserved.
//

#import "WRCQuizAnswer+Custom.h"
#import "WRCWordDefinition.h"

@implementation WRCQuizAnswer (Custom)

- (BOOL)isCorrectOnFirstAttempt;
{
    
    return ([[self.pickedWordDefinitions anyObject] isEqual:self.actualWordDefinition] && [self.pickedWordDefinitions count] == 1);
    
}

@end
