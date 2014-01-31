//
//  ATArchivableObject.m
//  USAlliance
//
//  Created by Adrien Truong on 4/7/13.
//  Copyright (c) 2013 Adrien Truong. All rights reserved.
//

#import "ATArchivableObject.h"
#import <objc/runtime.h>

#define kDictionaryCoderKey @"Dictionary"

@implementation ATArchivableObject

#pragma mark - Properties

//based on https://github.com/greenisus/NSObject-NSCoding/blob/master/NSObject%2BNSCoding.m
- (NSArray *)propertyNamesForClass:(Class)class
{
    NSMutableArray *propertyNames = [NSMutableArray array];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList(class, &outCount);
    
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSString *propertyName = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        [propertyNames addObject:propertyName];
    }
    
    free(properties);
    
    if ([class superclass] != [NSObject class]) {
        [propertyNames addObjectsFromArray:[self propertyNamesForClass:[class superclass]]];
    }
    
    return propertyNames;
}

#pragma mark - NSCoder

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [self init];
    
    if (self != nil) {
        NSDictionary *dictionary = [aDecoder decodeObjectForKey:kDictionaryCoderKey];
        [self setValuesForKeysWithDictionary:dictionary];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    NSArray *propertyNames = [self propertyNamesForClass:[self class]];
    NSDictionary *values = [self dictionaryWithValuesForKeys:propertyNames];
    [aCoder encodeObject:values forKey:kDictionaryCoderKey];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    ATArchivableObject *copy = [[self class] allocWithZone:zone];
    
    NSArray *keys = [self propertyNamesForClass:[self class]];
    NSDictionary *values = [self dictionaryWithValuesForKeys:keys];
    [copy setValuesForKeysWithDictionary:values];
    
    return copy;
}

#pragma mark - Is Equal

- (BOOL)isEqual:(id)object
{
    if ([object isKindOfClass:[self class]] == NO) {
        return NO;
    }
    
    NSArray *keys = [self propertyNamesForClass:[self class]];
    
    for (NSString *key in keys) {
        id value1 = [self valueForKey:key];
        id value2 = [object valueForKey:key];
        
        if (value1 == nil && value2 == nil) {
            continue;
        }
        
        if ([value1 isEqual:value2] == NO) {
            return NO;
        }
    }
    
    return YES;
}

@end
