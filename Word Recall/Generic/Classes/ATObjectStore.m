//
//  ATObjectStore.m
//  DoTA2
//
//  Created by Adrien Truong on 7/4/13.
//  Copyright (c) 2013 Adrien Truong. All rights reserved.
//

#import "ATObjectStore.h"

NSString * const ATObjectStoreDidAddObjectNotification = @"ATObjectStoreDidAddObjectNotification";
NSString * const ATObjectStoreDidRemoveObjectNotification = @"ATObjectStoreDidRemoveObjectNotification";
NSString * const ATObjectStoreObjectKey = @"ATObjectStoreObjectKey";

@interface ATObjectStore ()

@property (nonatomic, copy, readwrite) NSURL *URL;

@property (nonatomic, strong) NSMutableArray *mutableObjects;

@end

@implementation ATObjectStore

#pragma mark - Shared Object Stores

+ (void)registerSharedObjectStore:(ATObjectStore *)objectStore
{
    [[self sharedObjectStores] setObject:objectStore forKey:objectStore.URL];
}

+ (instancetype)sharedObjectStoreWithURL:(NSURL *)URL createAndRegisterIfNeeded:(BOOL)createAndRegisterIfNeeded
{
    ATObjectStore *sharedStore = [[self sharedObjectStores] objectForKey:URL];
    if (sharedStore == nil && createAndRegisterIfNeeded == YES) {
        sharedStore = [[ATObjectStore alloc] initWithURL:URL];
        [self registerSharedObjectStore:sharedStore];
    }
    
    return sharedStore;
}

+ (instancetype)sharedObjectStoreWithURL:(NSURL *)URL
{
    return [self sharedObjectStoreWithURL:URL createAndRegisterIfNeeded:NO];
}

+ (NSMutableDictionary *)sharedObjectStores
{
    static NSMutableDictionary *sharedObjectStores = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedObjectStores = [NSMutableDictionary dictionary];
    });
    
    return sharedObjectStores;
}

#pragma mark - Init

- (instancetype)initWithURL:(NSURL *)URL
{
    self = [super init];
    
    if (self != nil) {
        self.URL = URL;
        self.autoSaves = YES;
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:[self.URL path]]) {
            NSData *data = [NSData dataWithContentsOfURL:self.URL];
            _mutableObjects = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        }
        else {
            _mutableObjects = [NSMutableArray array];
        }
    }
    
    return self;
}

#pragma mark - Saving

- (BOOL)save:(NSError * __autoreleasing *)error
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.mutableObjects];
    BOOL success = [data writeToURL:self.URL options:NSDataWritingAtomic error:error];
    
    if (success == NO) {
        NSLog(@"ATObjectStore: Error occurred saving:%@", [*error userInfo]);
    }
    
    return success;
}

- (BOOL)save
{
    return [self save:nil];
}

- (void)autoSaveIfNeceessary
{
    if (self.autoSaves) {
        [self save];
    }
}

#pragma mark - Getting Objects in Store

- (NSArray *)objects
{
    return self.mutableObjects;
}

#pragma mark - Adding/Removing Objects

- (void)addObject:(id<NSCoding>)object
{
    [self.mutableObjects addObject:object];
    [self autoSaveIfNeceessary];
    
    NSDictionary *userInfo = @{ATObjectStoreObjectKey : object};
    [[NSNotificationCenter defaultCenter] postNotificationName:ATObjectStoreDidAddObjectNotification object:self userInfo:userInfo];
}

- (void)removeObject:(id<NSCoding>)object
{
    NSInteger index = [self.mutableObjects indexOfObject:object];
    [self removeObjectAtIndex:index];
}

- (void)removeObjectAtIndex:(NSInteger)index
{
    id object = [self.mutableObjects objectAtIndex:index];
    [self.mutableObjects removeObjectAtIndex:index];
    
    [self autoSaveIfNeceessary];
    
    NSDictionary *userInfo = @{ATObjectStoreObjectKey : object};
    [[NSNotificationCenter defaultCenter] postNotificationName:ATObjectStoreDidRemoveObjectNotification object:self userInfo:userInfo];
}

#pragma mark - Checking if Store Contains Object

- (BOOL)containsObject:(id)object
{
    return [[self objects] containsObject:object];
}

@end
