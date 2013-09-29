//
//  NSManagedObjectContext+RandomObject.h
//  Word Recall
//
//  Created by Adrien Truong on 9/27/13.
//  Copyright (c) 2013 Adrien Truong. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObjectContext (RandomObject)

- (NSManagedObject *)randomObjectWithEntityName:(NSString *)entityName matchingPredicate:(NSPredicate *)predicate;

@end
