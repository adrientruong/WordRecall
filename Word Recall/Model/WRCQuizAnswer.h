//
//  WRCQuizAnswer.h
//  Word Recall
//
//  Created by Adrien Truong on 10/4/13.
//  Copyright (c) 2013 Adrien Truong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class WRCWordDefinition, WRCWordDefinitionQuizPerformance;

@interface WRCQuizAnswer : NSManagedObject

@property (nonatomic) NSDate *date;
@property (nonatomic, retain) WRCWordDefinition *actualWordDefinition;
@property (nonatomic, retain) NSSet *pickedWordDefinitions;
@property (nonatomic, retain) WRCWordDefinitionQuizPerformance *quizPerformance;
@end

@interface WRCQuizAnswer (CoreDataGeneratedAccessors)

- (void)addPickedWordDefinitionsObject:(WRCWordDefinition *)value;
- (void)removePickedWordDefinitionsObject:(WRCWordDefinition *)value;
- (void)addPickedWordDefinitions:(NSSet *)values;
- (void)removePickedWordDefinitions:(NSSet *)values;

@end
