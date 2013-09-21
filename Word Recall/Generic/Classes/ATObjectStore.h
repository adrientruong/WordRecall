//
//  ATObjectStore.h
//  DoTA2
//
//  Created by Adrien Truong on 7/4/13.
//  Copyright (c) 2013 Adrien Truong. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const ATObjectStoreDidAddObjectNotification;
extern NSString * const ATObjectStoreDidRemoveObjectNotification;

extern NSString * const ATObjectStoreObjectKey;

@interface ATObjectStore : NSObject

@property (nonatomic, copy, readonly) NSURL *URL;

@property (nonatomic, assign) BOOL autoSaves;

+ (void)registerSharedObjectStore:(ATObjectStore *)objectStore;
+ (instancetype)sharedObjectStoreWithURL:(NSURL *)URL;
+ (instancetype)sharedObjectStoreWithURL:(NSURL *)URL createAndRegisterIfNeeded:(BOOL)createAndRegisterIfNeeded;

- (instancetype)initWithURL:(NSURL *)URL;

- (void)addObject:(id <NSCoding>)object;

- (void)removeObject:(id)object;
- (void)removeObjectAtIndex:(NSInteger)index;

- (BOOL)containsObject:(id)object;

- (BOOL)save;
- (BOOL)save:(NSError * __autoreleasing *)error;

- (NSArray *)objects;

@end
