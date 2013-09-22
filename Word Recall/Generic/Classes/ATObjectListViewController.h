//
//  ATObjectListViewController.h
//  SmartAlarms
//
//  Created by Adrien Truong on 4/27/13.
//  Copyright (c) 2013 Adrien Truong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATObjectListViewControllerRefreshDelegate.h"

/*
 
 This is an abstract class. It is meant to be subclassed. It provides all the boilerplate code for a UITableView backed by a list of a objects.
 
 */

@interface ATObjectListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong, readonly) UITableView *tableView;
@property (nonatomic, strong) NSSet *objects; //setting objects calls reloadTableView

@property (nonatomic, assign) BOOL showsRefreshControl;
@property (nonatomic, assign) BOOL showsEditButton;
@property (nonatomic, assign) BOOL showsAddButton;

@property (nonatomic, strong, readonly) UIRefreshControl *refreshControl;
@property (nonatomic, assign, getter = isRefreshing) BOOL refreshing;
@property (nonatomic, weak) id <ATObjectListViewControllerRefreshDelegate> refreshDelegate;

@property (nonatomic, strong) IBOutlet UIView *noObjectsView; //view to display when no objects are in the list

- (void)reloadTableView;
/*
 
 Calls all data methods again and reloads table view.
 
 */

- (UITableViewStyle)tableViewStyle;

- (NSArray *)sortObjectsIntoSections:(NSSet *)objects;
/*
 
 Returned array must contain ordered and sorted NSArrays for each table view section.
 
 EX:
 ------------------------------------------
 objects: [Daniel, Dave, Albert, Adrien]
 
 Returned array if sorted alphabetically and in ascending order: [ [Adrien, Albert], [Daniel, Dave] ]
 
 */

- (UIView *)newSectionHeaderViewWithReuseIdentifier:(NSString *)identifier;
- (UIView *)newSectionFooterViewWithReuseIdentifier:(NSString *)identifier;

- (NSString *)headerTextForSectionContainingObject:(id)object;
- (NSString *)footerTextForSectionContainingObject:(id)object;

- (NSString *)cellReuseIdentifierForObject:(id)object atIndexPath:(NSIndexPath *)indexPath;
- (UITableViewCell *)newCellWithReuseIdentifier:(NSString *)identifier;
- (void)configureCell:(UITableViewCell *)cell forObject:(id)object;

- (void)tableViewDidSelectObject:(id)object;

- (void)tableViewWillDeleteObject:(id)object;
/*
 
 You should remove the object from your data store in this method.
 
 */

- (UITableViewCellEditingStyle)editingStyleForCellContainingObject:(id)object;

- (UIViewController *)addObjectViewController;
- (UIViewController *)detailViewControllerForObject:(id)object;
- (BOOL)shouldPresentDetailViewControllerModally;

- (id)objectForIndexPath:(NSIndexPath *)indexPath;
- (NSIndexPath *)indexPathForObject:(id)object;

- (void)userDidRefreshTableView:(UIRefreshControl *)refreshControl;
- (void)beginRefreshing;
- (void)endRefreshing;
- (BOOL)dependsOnDelegateForRefreshing;

- (BOOL)shouldPushDetailViewControllerAutomatically;

@end
