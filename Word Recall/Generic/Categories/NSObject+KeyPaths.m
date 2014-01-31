//
//  NSObject+KeyPaths.m
//  Word Recall
//
//  Created by Adrien Truong on 10/9/13.
//  Copyright (c) 2013 Adrien Truong. All rights reserved.
//

#import "NSObject+KeyPaths.h"

@implementation NSObject (KeyPaths)

- (void)setValuesForKeyPathsWithDictionary:(NSDictionary *)keyedValues
{
    for (NSString *keyPath in keyedValues) {
        id value = [keyedValues objectForKey:keyPath];
        [self setValue:value forKeyPath:keyPath];
    }
}

- (NSDictionary *)dictionaryWithValuesForKeyPaths:(NSArray *)keyPaths
{
    NSMutableDictionary *mutableValuesForKeyPathsDictionary = [NSMutableDictionary dictionaryWithCapacity:[keyPaths count]];
    
    for (NSString *keyPath in keyPaths) {
        id value = [self valueForKeyPath:keyPath];
        mutableValuesForKeyPathsDictionary[keyPath] = value;
    }
    
    NSDictionary *valuesForKeyPathsDictionary = [mutableValuesForKeyPathsDictionary copy];
    
    return valuesForKeyPathsDictionary;
}

- (NSArray *)arrayWithValuesForKeyPaths:(NSArray *)keyPaths
{
    NSMutableArray *mutableValuesArrays = [NSMutableArray arrayWithCapacity:[keyPaths count]];
    
    for (NSString *keyPath in keyPaths) {
        id value = [self valueForKeyPath:keyPath];
        
        if (value == nil) {
            value = [NSNull null];
        }
        
        [mutableValuesArrays addObject:value];
    }
    
    NSArray *valuesArray = [mutableValuesArrays copy];
    
    return valuesArray;
}

@end
