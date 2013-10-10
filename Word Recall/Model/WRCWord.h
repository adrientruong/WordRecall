//
//  WRCWord.h
//  Word Recall
//
//  Created by Adrien Truong on 10/4/13.
//  Copyright (c) 2013 Adrien Truong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class WRCWordDefinition;

@interface WRCWord : NSManagedObject

@property (nonatomic, retain) NSString * word;
@property (nonatomic, retain) NSString * wordInitial;
@property (nonatomic) int32_t quizDefinitionIndex;
@property (nonatomic, retain) NSOrderedSet *definitions;
@end

@interface WRCWord (CoreDataGeneratedAccessors)

- (void)insertObject:(WRCWordDefinition *)value inDefinitionsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromDefinitionsAtIndex:(NSUInteger)idx;
- (void)insertDefinitions:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeDefinitionsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInDefinitionsAtIndex:(NSUInteger)idx withObject:(WRCWordDefinition *)value;
- (void)replaceDefinitionsAtIndexes:(NSIndexSet *)indexes withDefinitions:(NSArray *)values;
- (void)addDefinitionsObject:(WRCWordDefinition *)value;
- (void)removeDefinitionsObject:(WRCWordDefinition *)value;
- (void)addDefinitions:(NSOrderedSet *)values;
- (void)removeDefinitions:(NSOrderedSet *)values;
@end
