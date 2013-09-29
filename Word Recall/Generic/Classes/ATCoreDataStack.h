//
//  ATCoreDataStack.h
//  Word Recall
//
//  Created by Adrien Truong on 9/27/13.
//  Copyright (c) 2013 Adrien Truong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface ATCoreDataStack : NSObject

@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong, readonly) NSManagedObjectModel *managedObjectModel;

- (instancetype)initWithManagedObjectModelURL:(NSURL *)managedObjectModelURL storeURL:(NSURL *)storeURL;

- (NSManagedObject *)insertNewObjectForEntityName:(NSString *)entityName;

@end