//
//  NSString+StringWithFormatExtension.h
//  Word Recall
//
//  Created by Adrien Truong on 10/9/13.
//  Copyright (c) 2013 Adrien Truong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (StringWithFormatExtension)

+ (instancetype)stringWithFormat:(NSString *)format argumentsArray:(NSArray *)arguments;

@end
