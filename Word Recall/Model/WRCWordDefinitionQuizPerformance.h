//
//  WRCWordDefinitionQuizPerformance.h
//  Word Recall
//
//  Created by Adrien Truong on 10/4/13.
//  Copyright (c) 2013 Adrien Truong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class WRCQuizAnswer, WRCWordDefinition;

@interface WRCWordDefinitionQuizPerformance : NSManagedObject

@property (nonatomic, retain) NSOrderedSet *answers;
@property (nonatomic, retain) WRCWordDefinition *wordDefinition;
@end

@interface WRCWordDefinitionQuizPerformance (CoreDataGeneratedAccessors)

- (void)insertObject:(WRCQuizAnswer *)value inAnswersAtIndex:(NSUInteger)idx;
- (void)removeObjectFromAnswersAtIndex:(NSUInteger)idx;
- (void)insertAnswers:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeAnswersAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInAnswersAtIndex:(NSUInteger)idx withObject:(WRCQuizAnswer *)value;
- (void)replaceAnswersAtIndexes:(NSIndexSet *)indexes withAnswers:(NSArray *)values;
- (void)addAnswersObject:(WRCQuizAnswer *)value;
- (void)removeAnswersObject:(WRCQuizAnswer *)value;
- (void)addAnswers:(NSOrderedSet *)values;
- (void)removeAnswers:(NSOrderedSet *)values;
@end
