//
//  ATCoreDataBackedTableViewDataSource.h
//  Word Recall
//
//  Created by Adrien Truong on 9/28/13.
//  Copyright (c) 2013 Adrien Truong. All rights reserved.
//

#import "ATObjectTableViewProvider.h"
#import <CoreData/CoreData.h>

@interface ATFetchedResultsControllerTableViewProvider : ATObjectTableViewProvider <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, weak) UITableView *tableView;

@end
