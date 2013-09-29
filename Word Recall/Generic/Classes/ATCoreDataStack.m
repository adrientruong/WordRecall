//
//  ATCoreDataStack.m
//  Word Recall
//
//  Created by Adrien Truong on 9/27/13.
//  Copyright (c) 2013 Adrien Truong. All rights reserved.
//

#import "ATCoreDataStack.h"

@interface ATCoreDataStack ()

@property (nonatomic, strong, readwrite) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong, readwrite) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong, readwrite) NSManagedObjectModel *managedObjectModel;

@property (nonatomic, strong, readwrite) NSURL *storeURL;

@end

@implementation ATCoreDataStack

- (instancetype)initWithManagedObjectModelURL:(NSURL *)managedObjectModelURL storeURL:(NSURL *)storeURL
{
    
    self = [super init];
    
    if (self != nil) {
        
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:managedObjectModelURL];
        
        NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                                 [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption,
                                 nil];
        
        NSError *error = nil;
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_managedObjectModel];
        
        NSPersistentStore *persistentStore = [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error];
        
        if (persistentStore == nil) {
            
            NSLog(@"Something went wrong creating persistent store coordinator. Erro:%@", [error userInfo]);
            
        }
        
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        _managedObjectContext.persistentStoreCoordinator = _persistentStoreCoordinator;
        
        _managedObjectContext.undoManager = [[NSUndoManager alloc] init];
        
    }
    
    return self;
    
}

- (NSManagedObject *)insertNewObjectForEntityName:(NSString *)entityName;
{
    
    return [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:self.managedObjectContext];
    
}


@end
