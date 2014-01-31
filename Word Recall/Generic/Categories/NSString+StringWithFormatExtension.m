//
//  NSString+StringWithFormatExtension.m
//  Word Recall
//
//  Created by Adrien Truong on 10/9/13.
//  Copyright (c) 2013 Adrien Truong. All rights reserved.
//

#import "NSString+StringWithFormatExtension.h"

@implementation NSString (StringWithFormatExtension)

+ (instancetype)stringWithFormat:(NSString *)format argumentsArray:(NSArray *)arguments
{
    NSRange range = NSMakeRange(0, [arguments count]);
    NSMutableData* data = [NSMutableData dataWithLength:sizeof(id) * [arguments count]];
    
    [arguments getObjects:(__unsafe_unretained id *)data.mutableBytes range:range];
    
    NSString *result = [[NSString alloc] initWithFormat:format arguments:data.mutableBytes];
    
    return result;
}

@end
