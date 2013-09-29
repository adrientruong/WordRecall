//
//  NSManagedObjectContext+RandomObject.m
//  Word Recall
//
//  Created by Adrien Truong on 9/27/13.
//  Copyright (c) 2013 Adrien Truong. All rights reserved.
//

#import "NSManagedObjectContext+RandomObject.h"

@implementation NSManagedObjectContext (RandomObject)

- (NSManagedObject *)randomObjectWithEntityName:(NSString *)entityName matchingPredicate:(NSPredicate *)predicate;
{
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:entityName inManagedObjectContext:self];
    
    [fetchRequest setEntity:entityDescription];
    
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    
    NSUInteger entityCount = [self countForFetchRequest:fetchRequest error:&error];
    NSUInteger offset = entityCount - arc4random_uniform((u_int32_t)entityCount);
    
    [fetchRequest setFetchOffset:offset];
    [fetchRequest setFetchLimit:1];
    
    NSArray *objects = [self executeFetchRequest:fetchRequest error:&error];
    
    id randomObject = [objects firstObject];
    
    return randomObject;
    
}

@end
