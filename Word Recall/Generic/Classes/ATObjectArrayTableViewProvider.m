//
//  ATObjectArrayBackedTableViewDataSource.m
//  Word Recall
//
//  Created by Adrien Truong on 9/28/13.
//  Copyright (c) 2013 Adrien Truong. All rights reserved.
//

#import "ATObjectArrayTableViewProvider.h"

@interface ATObjectArrayTableViewProvider ()

@property (nonatomic, strong) NSArray *sectionedArray;

@end

@implementation ATObjectArrayTableViewProvider

- (void)setArray:(NSArray *)array
{
    if (array == _array) {
        return;
    }
    
    _array = array;
    
    id firstObject = [self.array firstObject];
    BOOL containsMultipleSections = [firstObject isKindOfClass:[NSArray class]];
    
    if (containsMultipleSections) {
        self.sectionedArray = self.array;
    }
    else {
        self.sectionedArray = @[self.array];
    }
}

- (NSArray *)objectsForSection:(NSInteger)section
{
    NSArray *objects = self.sectionedArray[section];
    
    return objects;
}

- (NSInteger)numberOfSections
{
    return [self.sectionedArray count];
}

- (NSInteger)numberOfObjectsForSection:(NSInteger)section
{
    NSArray *sectionArray = self.array[section];
    
    return [sectionArray count];
}

- (id)objectForIndexPath:(NSIndexPath *)indexPath
{
    NSArray *objectsForSection = [self objectsForSection:indexPath.section];
    id object = objectsForSection[indexPath.row];
    
    return object;
}

- (NSIndexPath *)indexPathForObject:(id)object
{
    NSIndexPath *indexPath = nil;
    
    for (NSInteger sectionNumber = 0; sectionNumber < [self numberOfSections]; sectionNumber++) {
        NSArray *objectsInSection = [self objectsForSection:sectionNumber];
        NSInteger rowNumber = [objectsInSection indexOfObject:object];
        if (rowNumber != NSNotFound) {
            indexPath = [NSIndexPath indexPathForRow:rowNumber inSection:sectionNumber];
            break;
        }
    }
    
    return indexPath;
}

@end
