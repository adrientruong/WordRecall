//
//  NSObject+KeyPaths.h
//  Word Recall
//
//  Created by Adrien Truong on 10/9/13.
//  Copyright (c) 2013 Adrien Truong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (KeyPaths)

- (void)setValuesForKeyPathsWithDictionary:(NSDictionary *)keyedValues;
- (NSDictionary *)dictionaryWithValuesForKeyPaths:(NSArray *)keyPaths;
- (NSArray *)arrayWithValuesForKeyPaths:(NSArray *)keyPaths;

@end
