//
//  ATObjectListViewController.h
//  SmartAlarms
//
//  Created by Adrien Truong on 4/27/13.
//  Copyright (c) 2013 Adrien Truong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATObjectListViewControllerRefreshDelegate.h"
#import "ATObjectTableViewProvider.h"
/*
 
 This is an abstract class. It is meant to be subclassed. It provides all the boilerplate code for a UITableView backed by a list of a objects.
 
 */

@interface ATObjectListViewController : UIViewController <ATObjectTableViewProviderDelegate>

@property (nonatomic, strong, readonly) UITableView *tableView;

@property (nonatomic, assign) BOOL showsRefreshControl;
@property (nonatomic, assign) BOOL showsEditButton;
@property (nonatomic, assign) BOOL showsAddButton;

@property (nonatomic, strong, readonly) ATObjectTableViewProvider *tableViewProvider;

@property (nonatomic, strong, readonly) UIRefreshControl *refreshControl;
@property (nonatomic, assign, getter = isRefreshing) BOOL refreshing;
@property (nonatomic, weak) id <ATObjectListViewControllerRefreshDelegate> refreshDelegate;

@property (nonatomic, strong) IBOutlet UIView *noObjectsView; //view to display when no objects are in the list

- (Class)tableViewProviderClass;
- (void)didCreateTableViewProvider;

- (void)reloadTableView;
/*
 
 Calls all data methods again and reloads table view.
 
 */

- (UITableViewStyle)tableViewStyle;

- (UIViewController *)addObjectViewController;
- (UIViewController *)detailViewControllerForObject:(id)object;
- (BOOL)shouldPresentDetailViewControllerModally;

- (void)userDidRefreshTableView:(UIRefreshControl *)refreshControl;
- (void)beginRefreshing;
- (void)endRefreshing;
- (BOOL)dependsOnDelegateForRefreshing;

- (BOOL)shouldPushDetailViewControllerAutomatically;

@end
