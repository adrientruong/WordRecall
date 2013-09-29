//
//  WRCWordDefinition.h
//  Word Recall
//
//  Created by Adrien Truong on 9/28/13.
//  Copyright (c) 2013 Adrien Truong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class WRCWord, WRCWordDefinition;

@interface WRCWordDefinition : NSManagedObject

@property (nonatomic, retain) NSString * definition;
@property (nonatomic, retain) NSString * exampleSentence;
@property (nonatomic) int16_t partOfSpeech;
@property (nonatomic, retain) WRCWord *word;
@property (nonatomic, retain) NSSet *synonyms;
@end

@interface WRCWordDefinition (CoreDataGeneratedAccessors)

- (void)addSynonymsObject:(WRCWordDefinition *)value;
- (void)removeSynonymsObject:(WRCWordDefinition *)value;
- (void)addSynonyms:(NSSet *)values;
- (void)removeSynonyms:(NSSet *)values;

@end
