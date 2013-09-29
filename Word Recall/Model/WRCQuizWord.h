//
//  WRCQuizWord.h
//  Word Recall
//
//  Created by Adrien Truong on 9/28/13.
//  Copyright (c) 2013 Adrien Truong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "WRCWord.h"

@class WRCQuizWord;

@interface WRCQuizWord : WRCWord

@property (nonatomic) int32_t missCount;
@property (nonatomic) int32_t quizCount;
@property (nonatomic) int32_t quizDefinitionIndex;
@property (nonatomic, retain) NSSet *incorrectWordAssociations;
@end

@interface WRCQuizWord (CoreDataGeneratedAccessors)

- (void)addIncorrectWordAssociationsObject:(WRCQuizWord *)value;
- (void)removeIncorrectWordAssociationsObject:(WRCQuizWord *)value;
- (void)addIncorrectWordAssociations:(NSSet *)values;
- (void)removeIncorrectWordAssociations:(NSSet *)values;

@end
