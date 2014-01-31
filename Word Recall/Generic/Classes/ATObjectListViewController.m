//
//  ATObjectListViewController.m
//  SmartAlarms
//
//  Created by Adrien Truong on 4/27/13.
//  Copyright (c) 2013 Adrien Truong. All rights reserved.
//

#import "ATObjectListViewController.h"
#import "ATObjectTableViewProvider.h"

@interface ATObjectListViewController ()

@property (nonatomic, strong) UITableViewController *tableViewController;

@property (nonatomic, strong, readwrite) UITableView *tableView;

@property (nonatomic, strong, readwrite) ATObjectTableViewProvider *tableViewProvider;

@end

@implementation ATObjectListViewController

#pragma mark - Init

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self != nil) {
        
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
    
    self.tableViewProvider = [[[self tableViewProviderClass] alloc] init];
    self.tableViewProvider.delegate = self;
    
    [self didCreateTableViewProvider];
    
    self.tableView.dataSource = self.tableViewProvider;
    self.tableView.delegate = self.tableViewProvider;
    
    if (self.showsRefreshControl) {
        self.tableViewController.refreshControl = [[UIRefreshControl alloc] init];
        [self.tableViewController.refreshControl addTarget:self action:@selector(userDidRefreshTableView:) forControlEvents:UIControlEventValueChanged];
    }
    
    [self addChildViewController:self.tableViewController];
    [self.view addSubview:self.tableView];
    
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    
    id <UILayoutSupport> topLayoutGuide = self.topLayoutGuide;
    id <UILayoutSupport> bottomLayoutGuide = self.bottomLayoutGuide;
    NSDictionary *views = NSDictionaryOfVariableBindings(_tableView, topLayoutGuide, bottomLayoutGuide);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_tableView]|" options:0 metrics:nil views:views]];

    if (self.navigationController == nil || self.navigationController.navigationBarHidden) {
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[topLayoutGuide][_tableView][bottomLayoutGuide]" options:0 metrics:nil views:views]];
    }
    else {
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_tableView]|" options:0 metrics:nil views:views]];
    }
        
    if (self.isRefreshing) {
        [self beginRefreshing];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:animated];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if (self.navigationController != nil && self.navigationController.navigationBarHidden == NO) {
        id <UILayoutSupport> topLayoutGuide = self.topLayoutGuide;
        id <UILayoutSupport> bottomLayoutGuide = self.bottomLayoutGuide;
        
        self.tableView.contentInset = UIEdgeInsetsMake([topLayoutGuide length], 0, [bottomLayoutGuide length], 0);
    }
}

#pragma mark - ATTableViewDataSource

- (Class)tableViewProviderClass
{
    return [ATObjectTableViewProvider class];
}

- (void)didCreateTableViewProvider
{
    
}

- (void)tableViewProvider:(ATObjectTableViewProvider *)dataSource configureCell:(UITableViewCell *)cell forObject:(id)object
{
    
}

- (void)tableViewProvider:(ATObjectTableViewProvider *)dataSource didSelectObject:(id)object
{
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
    [self.tableView reloadData];
    
    if ([self.tableViewProvider numberOfSections] == 0) {
        [self addNoObjectViewIfNeeded];
    }
    else {
        [self.noObjectsView removeFromSuperview];
    }
}

- (void)addNoObjectViewIfNeeded
{
    if (self.noObjectsView != nil && self.isRefreshing == NO && self.noObjectsView.superview != self.view) {
        [self.view addSubview:self.noObjectsView];
        
        self.noObjectsView.translatesAutoresizingMaskIntoConstraints = NO;
        NSDictionary *views = NSDictionaryOfVariableBindings(_noObjectsView);
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_noObjectsView]|" options:0 metrics:nil views:views]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_noObjectsView]|" options:0 metrics:nil views:views]];
    }
}

- (UITableViewStyle)tableViewStyle
{
    return UITableViewStylePlain;
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
    [self.noObjectsView removeFromSuperview];
    
    _noObjectsView = noObjectsView;
    
    if (self.isViewLoaded && [self.tableViewProvider numberOfSections] == 0) {
        [self addNoObjectViewIfNeeded];
    }
}

@end
