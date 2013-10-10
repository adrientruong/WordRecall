//
//  WRCWordDefinition.h
//  Word Recall
//
//  Created by Adrien Truong on 10/5/13.
//  Copyright (c) 2013 Adrien Truong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class WRCQuizAnswer, WRCWord, WRCWordDefinition, WRCWordDefinitionQuizPerformance;

@interface WRCWordDefinition : NSManagedObject

@property (nonatomic, retain) NSString * definition;
@property (nonatomic, retain) NSString * exampleSentence;
@property (nonatomic) int16_t partOfSpeech;
@property (nonatomic, retain) NSString * pronunciationAudioURLString;
@property (nonatomic, retain) NSSet *quizAnswersWithSelfAsActual;
@property (nonatomic, retain) NSSet *quizAnswersWithSelfAsPicked;
@property (nonatomic, retain) WRCWordDefinitionQuizPerformance *quizPerformance;
@property (nonatomic, retain) NSSet *synonyms;
@property (nonatomic, retain) WRCWord *word;
@end

@interface WRCWordDefinition (CoreDataGeneratedAccessors)

- (void)addQuizAnswersWithSelfAsActualObject:(WRCQuizAnswer *)value;
- (void)removeQuizAnswersWithSelfAsActualObject:(WRCQuizAnswer *)value;
- (void)addQuizAnswersWithSelfAsActual:(NSSet *)values;
- (void)removeQuizAnswersWithSelfAsActual:(NSSet *)values;

- (void)addQuizAnswersWithSelfAsPickedObject:(WRCQuizAnswer *)value;
- (void)removeQuizAnswersWithSelfAsPickedObject:(WRCQuizAnswer *)value;
- (void)addQuizAnswersWithSelfAsPicked:(NSSet *)values;
- (void)removeQuizAnswersWithSelfAsPicked:(NSSet *)values;

- (void)addSynonymsObject:(WRCWordDefinition *)value;
- (void)removeSynonymsObject:(WRCWordDefinition *)value;
- (void)addSynonyms:(NSSet *)values;
- (void)removeSynonyms:(NSSet *)values;

@end
