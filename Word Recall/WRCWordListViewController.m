//
//  WRCQuizWordListViewController.m
//  Word Recall
//
//  Created by Adrien Truong on 9/29/13.
//  Copyright (c) 2013 Adrien Truong. All rights reserved.
//

#import "WRCWordListViewController.h"
#import "ATFetchedResultsControllerTableViewProvider.h"
#import "WRCWordStore.h"
#import <CoreData/CoreData.h>
#import "WRCWordDefinition.h"
#import "WRCWord.h"
#import "WRCWord+Custom.h"
#import "WRCQuizAnswer.h"
#import "WRCWordViewController.h"

@interface WRCWordListViewController ()

@end

@implementation WRCWordListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self != nil) {
        
        self.title = NSLocalizedString(@"Words", @"");
        
        self.showsAddButton = YES;
        
    }
    
    return self;
    
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    NSString *allFilterTitle = NSLocalizedString(@"All", @"");
    NSString *missedWordsFilterTitle = NSLocalizedString(@"Missed", @"");
    
    UISegmentedControl *filterSegmentedControl = [[UISegmentedControl alloc] initWithItems:@[allFilterTitle, missedWordsFilterTitle]];
    
    filterSegmentedControl.selectedSegmentIndex = self.filterType;
    
    self.navigationItem.titleView = filterSegmentedControl;
    
    [filterSegmentedControl addTarget:self action:@selector(filterSegmentedControlValueDidChange:) forControlEvents:UIControlEventValueChanged];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    [self reloadTableView];
    
}

- (void)filterSegmentedControlValueDidChange:(UISegmentedControl *)segmentedControl
{
    
    self.filterType = segmentedControl.selectedSegmentIndex;
    
}

- (Class)tableViewProviderClass
{
    
    return [ATFetchedResultsControllerTableViewProvider class];
    
}

- (void)didCreateTableViewProvider
{
    
    [self configureTableViewProvider];
    
    ((ATFetchedResultsControllerTableViewProvider *)self.tableViewProvider).tableView = self.tableView;
    
}

- (void)configureTableViewProvider
{
    
    ATFetchedResultsControllerTableViewProvider *tableViewProvider = (ATFetchedResultsControllerTableViewProvider *)self.tableViewProvider;
    
    NSFetchRequest *fetchRequest = nil;
    NSString *sectionNameKeyPath = nil;
    
    if (self.filterType == WRCWordListViewControllerFilterTypeNone) {
        
        fetchRequest = [self.wordStore wordFetchRequest];

        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"word" ascending:YES];
        
        [fetchRequest setSortDescriptors:@[sortDescriptor]];
        
        sectionNameKeyPath = @"wordInitial";
        
    }
    else {
        
        fetchRequest = [self.wordStore quizAnswerFetchRequest];
        
        NSPredicate *predicate = [self.wordStore lastMissedQuizAnswersPredicate];
            
        [fetchRequest setPredicate:predicate];
        
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"actualWordDefinition.word.word" ascending:YES];
        
        [fetchRequest setSortDescriptors:@[sortDescriptor]];
        
        sectionNameKeyPath = @"actualWordDefinition.word.wordInitial";
        
    }
    
    [fetchRequest setFetchBatchSize:20];
    
    tableViewProvider.fetchedResultsController = [self.wordStore fetchedResultsControllerWithFetchRequest:fetchRequest sectionNameKeyPath:sectionNameKeyPath cacheName:@"WRCQuizWordListViewControllerCache"];
    
}

- (void)setWordStore:(WRCWordStore *)wordStore
{
    
    _wordStore = wordStore;
    
    [self configureTableViewProvider];
    
    if (self.isViewLoaded) {
        
        [self reloadTableView];
        
    }
    
}

- (UITableViewCell *)tableViewProvider:(ATObjectTableViewProvider *)dataSource newCellWithReuseIdentifier:(NSString *)identifier
{
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    
    return cell;
    
}

- (void)tableViewProvider:(ATObjectTableViewProvider *)provider configureCell:(UITableViewCell *)cell forObject:(id)object
{
    
    [super tableViewProvider:provider configureCell:cell forObject:object];
    
    WRCWord *word = object;

    if ([object isKindOfClass:[WRCQuizAnswer class]]) {
        
        WRCQuizAnswer *quizAnswer = object;
        
        word = quizAnswer.actualWordDefinition.word;
        
    }
    
    cell.textLabel.text = word.word;
    
    cell.detailTextLabel.text = [word quizDefinition].definition;
    
}

- (UIViewController *)detailViewControllerForObject:(id)object
{
    
    WRCWordViewController *wordViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"WRCWordViewController"];
    
    wordViewController.wordStore = self.wordStore;
    wordViewController.word = object;
    
    return wordViewController;
    
}

- (void)setFilterType:(WRCWordListViewControllerFilterType)filterType
{
    
    if (_filterType == filterType) {
        
        return;
        
    }
    
    _filterType = filterType;
    
    [self configureTableViewProvider];
    
    if (self.isViewLoaded) {
    
        [self reloadTableView];
        
    }
    
}

@end
