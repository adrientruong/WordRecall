//
//  ATObjectListViewController.m
//  SmartAlarms
//
//  Created by Adrien Truong on 4/27/13.
//  Copyright (c) 2013 Adrien Truong. All rights reserved.
//

#import "ATObjectListViewController.h"

@interface ATObjectListViewController ()

@property (nonatomic, strong) UITableViewController *tableViewController;

@property (nonatomic, strong, readwrite) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *objectsSortedBySection;

@end

@implementation ATObjectListViewController

#pragma mark - Init

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self != nil) {
        
        _objects = [NSSet set];
        
    }
    
    return self;
    
}

#pragma mark - View Life Cycle

- (void)viewDidLoad
{
    
    [super viewDidLoad];
        
    UITableViewStyle tableViewStyle = [self tableViewStyle];
    
    self.tableViewController = [[UITableViewController alloc] initWithStyle:tableViewStyle];
    
    self.tableView = self.tableViewController.tableView;
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    if (self.showsRefreshControl) {
        
        self.tableViewController.refreshControl = [[UIRefreshControl alloc] init];
        
        [self.tableViewController.refreshControl addTarget:self action:@selector(userDidRefreshTableView:) forControlEvents:UIControlEventValueChanged];
        
    }
    
    [self addChildViewController:self.tableViewController];
    
    [self.view addSubview:self.tableView];
    
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_tableView);
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_tableView]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_tableView]|" options:0 metrics:nil views:views]];
    
    if (self.isRefreshing) {
        
        [self beginRefreshing];
        
    }
        
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:animated];
    
}

#pragma mark - Actions

- (void)addButtonWasTapped
{
    
    UIViewController *addController = [self addObjectViewController];
    
    UINavigationController *addNavigationController = [[UINavigationController alloc] initWithRootViewController:addController];
    
    [self presentViewController:addNavigationController animated:YES completion:nil];
    
}

#pragma mark - Controllers for Detail and Add

- (UIViewController *)addObjectViewController
{
    
    return nil;
    
}

- (UIViewController *)detailViewControllerForObject:(id)object
{
    
    return nil;
    
}

- (BOOL)shouldPresentDetailViewControllerModally
{
    
    return NO;
    
}

- (BOOL)shouldPushDetailViewControllerAutomatically
{
    
    return YES;
    
}

#pragma mark - Editing

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    
    [super setEditing:editing animated:animated];
    
    [self.tableView setEditing:editing animated:animated];
    
}

#pragma mark - UITableView Logic

- (void)reloadTableView
{
    
    self.objectsSortedBySection = [NSMutableArray array];

    if ([self.objects count] > 0) {
        
        [self.noObjectsView removeFromSuperview];
    
        NSArray *sortedObjects = [self sortObjectsIntoSections:self.objects];
        
        for (NSArray *array in sortedObjects) {
            
            NSMutableArray *mutableArray = [array mutableCopy];
            
            [self.objectsSortedBySection addObject:mutableArray];
            
        }
        
    }
    
    [self addNoObjectViewIfNeeded];
    
    [self.tableView reloadData];
    
}

- (void)addNoObjectViewIfNeeded
{
    
    if (self.noObjectsView != nil && self.isRefreshing == NO) {
        
        [self.view addSubview:self.noObjectsView];
        
        self.noObjectsView.translatesAutoresizingMaskIntoConstraints = NO;
        
        NSDictionary *views = NSDictionaryOfVariableBindings(_noObjectsView);
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_noObjectsView]|" options:0 metrics:nil views:views]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_noObjectsView]|" options:0 metrics:nil views:views]];
        
    }
    
}

- (NSArray *)sortObjectsIntoSections:(NSSet *)objects
{
    
    return @[[objects allObjects]];
    
}

- (NSMutableArray *)objectsForSection:(NSInteger)section
{
    
    return [self.objectsSortedBySection objectAtIndex:section];
    
}

- (id)objectForIndexPath:(NSIndexPath *)indexPath
{
    
    NSArray *objects = [self objectsForSection:indexPath.section];
    
    if ([objects count] >= indexPath.row + 1) {

        return [objects objectAtIndex:indexPath.row];
        
    }
    else {
        
        return nil;
        
    }
    
}

- (NSIndexPath *)indexPathForObject:(id)object
{
    
    NSIndexPath *indexPath = nil;
    
    for (int sectionNumber = 0; sectionNumber < [self.tableView numberOfSections]; sectionNumber++) {
        
        NSArray *objectsInSection = [self objectsForSection:sectionNumber];
        
        int rowNumber = [objectsInSection indexOfObject:object];
        
        if (rowNumber != NSNotFound) {
            
            indexPath = [NSIndexPath indexPathForRow:rowNumber inSection:sectionNumber];
            
            break;
            
        }
        
    }
    
    return indexPath;
    
}

- (UITableViewStyle)tableViewStyle
{
    
    return UITableViewStylePlain;
    
}

- (UIView *)newSectionHeaderViewWithReuseIdentifier:(NSString *)identifier
{
    
    return nil;
    
}

- (UIView *)newSectionFooterViewWithReuseIdentifier:(NSString *)identifier
{
    
    return nil;
    
}

- (NSString *)headerTextForSectionContainingObject:(id)object
{
    
    return nil;
    
}

- (NSString *)footerTextForSectionContainingObject:(id)object
{
    
    return nil;
    
}

- (UITableViewCell *)newCellWithReuseIdentifier:(NSString *)identifier
{
    
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    
}

- (void)configureCell:(UITableViewCell *)cell forObject:(id)object
{
    
    
    
}

- (void)tableViewDidSelectObject:(id)object
{
    
    
    
}

- (void)tableViewWillDeleteObject:(id)object
{
    
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return [self.objectsSortedBySection count];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSArray *objectsForSection = [self objectsForSection:section];
    
    return [objectsForSection count];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if ([self tableView:tableView titleForHeaderInSection:section]) {
        
        return UITableViewAutomaticDimension;
        
    }
    
    return 0;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    if ([self tableView:tableView titleForFooterInSection:section]) {
        
        return UITableViewAutomaticDimension;
        
    }
    
    return 0;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    static NSString *HeaderViewIdentifier = @"HeaderView";
    
    UIView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HeaderViewIdentifier];
    
    if (headerView == nil) {
        
        headerView = [self newSectionHeaderViewWithReuseIdentifier:HeaderViewIdentifier];
        
    }
    
    return headerView;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    static NSString *HeaderViewIdentifier = @"FooterView";
    
    UIView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HeaderViewIdentifier];
    
    if (footerView == nil) {
        
        footerView = [self newSectionFooterViewWithReuseIdentifier:HeaderViewIdentifier];
        
    }
    
    return footerView;

}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    id object = [self objectForIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
    
    return [self headerTextForSectionContainingObject:object];
    
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    
    id object = [self objectForIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
    
    return [self footerTextForSectionContainingObject:object];
    
}

- (NSString *)cellReuseIdentifierForObject:(id)object atIndexPath:(NSIndexPath *)indexPath
{
    
    return @"Object";
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    id object = [self objectForIndexPath:indexPath];

    NSString *cellReuseIdentifier = [self cellReuseIdentifierForObject:object atIndexPath:indexPath];
        
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier];
    
    if (cell == nil) {
        
        cell = [self newCellWithReuseIdentifier:cellReuseIdentifier];
        
    }
        
    [self configureCell:cell forObject:object];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    id object = [self objectForIndexPath:indexPath];
    
    [self tableViewDidSelectObject:object];
    
    if ([self shouldPushDetailViewControllerAutomatically]) {
        
        UIViewController *detailController = [self detailViewControllerForObject:object];
        
        if ([self shouldPresentDetailViewControllerModally]) {
            
            UINavigationController *detailNavigationController = [[UINavigationController alloc] initWithRootViewController:detailController];
            
            [self presentViewController:detailNavigationController animated:YES completion:nil];
            
        }
        else {
            
            [self.navigationController pushViewController:detailController animated:YES];
            
        }

    }
    
}

- (UITableViewCellEditingStyle)editingStyleForCellContainingObject:(id)object
{
    
    return UITableViewCellEditingStyleNone;
    
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    id object = [self objectForIndexPath:indexPath];
    
    return [self editingStyleForCellContainingObject:object];
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        id object = [self objectForIndexPath:indexPath];
        
        [self tableViewWillDeleteObject:object];
        
        NSMutableArray *objectsForSection = [self objectsForSection:indexPath.section];
        
        [objectsForSection removeObjectAtIndex:indexPath.row];
        
        if ([objectsForSection count] == 0) {
            
            [self.objectsSortedBySection removeObjectAtIndex:indexPath.section];
            
            [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
            
        }
        else {
            
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];

        }
        
    }
    
}

#pragma mark - Setting Objects

- (void)setObjects:(NSSet *)objects
{
    
    _objects = objects;
    
    if (_objects == nil) {
        
        _objects = [NSSet set];
        
    }
    
    [self reloadTableView];
    
}

#pragma mark - Refresh Control

- (void)setShowsRefreshControl:(BOOL)showsRefreshControl
{
    
    _showsRefreshControl = showsRefreshControl;
    
    if (self.showsRefreshControl) {
        
        self.tableViewController.refreshControl = [[UIRefreshControl alloc] init];
                
        [self.tableViewController.refreshControl addTarget:self action:@selector(userDidRefreshTableView:) forControlEvents:UIControlEventValueChanged];
                
    }
    else {
        
        self.tableViewController.refreshControl = nil;
                
    }
    
}

- (void)userDidRefreshTableView:(UIRefreshControl *)refreshControl
{
    
    if ([self dependsOnDelegateForRefreshing]) {
        
        [self.refreshDelegate objectListViewControllerDidInitiateRefresh:self];
        
    }
    
}

- (BOOL)dependsOnDelegateForRefreshing
{
    
    return NO;
    
}

- (void)beginRefreshing
{
     
    [self.refreshControl beginRefreshing];
    
    self.refreshing = YES;
    
}

- (void)endRefreshing
{
        
    [self.refreshControl endRefreshing];
    
    self.refreshing = NO;
    
    [self addNoObjectViewIfNeeded];
    
}

- (UIRefreshControl *)refreshControl
{
    
    return self.tableViewController.refreshControl;
    
}

#pragma mark - Navigation Buttons

- (void)setShowsEditButton:(BOOL)showsEditButton
{
    
    _showsEditButton = showsEditButton;
    
    if (self.showsEditButton) {
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem;

    }
    else {
        
        self.navigationItem.leftBarButtonItem = nil;
        
    }
    
}

- (void)setShowsAddButton:(BOOL)showsAddButton
{
    
    _showsAddButton = showsAddButton;
    
    if (self.showsAddButton) {
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonWasTapped)];
        
    }
    else {
        
        self.navigationItem.rightBarButtonItem = nil;
        
    }
    
}

#pragma mark - No Objects View

- (void)setNoObjectsView:(UIView *)noObjectsView
{
    
    _noObjectsView = noObjectsView;
    
    if (self.isViewLoaded) {
        
        [self addNoObjectViewIfNeeded];
        
    }
    
}

@end
