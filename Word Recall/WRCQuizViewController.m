//
//  WRCQuizViewController.m
//  Word Recall
//
//  Created by Adrien Truong on 9/21/13.
//  Copyright (c) 2013 Adrien Truong. All rights reserved.
//

#import "WRCQuizViewController.h"
#import "ATObjectStore.h"
#import "WRCWordDefinitionTableViewPickerView.h"
#import "WRCWordInfo.h"
#import "NSArray+Shuffle.h"
#import "NSArray+RandomObject.h"

@interface WRCQuizViewController ()

@property (nonatomic, strong) WRCWordDefinitionTableViewPickerView *pickerView;
@property (nonatomic, weak) IBOutlet UILabel *wordLabel;

- (IBAction)showCorrectAnswer;

@end

@implementation WRCQuizViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self != nil) {
        
        self.answerChoicesCount = 5;
       
    }
    
    return self;
    
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    self.pickerView = [[WRCWordDefinitionTableViewPickerView alloc] init];
    
    [self.view addSubview:self.pickerView];
    
    self.pickerView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_wordLabel, _pickerView);
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_wordLabel][_pickerView]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_pickerView]|" options:0 metrics:nil views:views]];

    self.pickerView.itemTitleKeyPath = @"definition";
    self.pickerView.minimumNumberOfSelections = 0;
    self.pickerView.maximumNumberOfSelections = -1;
    
    self.pickerView.tableView.rowHeight = 60;
    
    [self.pickerView addTarget:self action:@selector(didSelectDefinition:) forControlEvents:UIControlEventValueChanged];
    
    if (self.wordStore != nil) {
     
        if (self.currentWord == nil) {
            
            [self showNextWord];
            
        }
        else {
            
            [self configureViewForWord:self.currentWord];
            
        }
        
    }
    
}

- (void)didSelectDefinition:(WRCWordDefinitionTableViewPickerView *)pickerView
{
    
    WRCWordInfo *selectedWordInfo = [pickerView lastSelectedItem];
    
    if ([selectedWordInfo isEqualToWordInfo:self.currentWord]) {
        
        [self showNextWord];
        
    }
    
}

- (IBAction)showCorrectAnswer
{
    
    self.pickerView.selectedItems = [self.pickerView.selectedItems arrayByAddingObject:self.currentWord];
    
}

- (void)configureViewForWord:(WRCWordInfo *)word
{
    
    NSMutableArray *answerChoices = [NSMutableArray arrayWithObject:word];
    
    [answerChoices addObjectsFromArray:[self randomWordsNotIncluding:word withCount:self.answerChoicesCount - 1]];
    
    [answerChoices shuffle];
    
    self.pickerView.items = answerChoices;
    self.pickerView.selectedItems = nil;
    
    self.pickerView.correctWordInfo = word;
    
    NSMutableArray *possibleWords = [word.synonyms mutableCopy];
    
    [possibleWords addObject:word.word];
    
    self.wordLabel.text = [possibleWords randomObject];
    
}

- (void)showNextWord
{
    
    self.currentWord = [self randomWordNotWord:self.currentWord];
    
    [self configureViewForWord:self.currentWord];
    
}

- (WRCWordInfo *)randomWord
{
    
    WRCWordInfo *randomWord = [[self.wordStore objects] randomObject];
    
    return randomWord;
    
}

- (WRCWordInfo *)randomWordNotWord:(WRCWordInfo *)word
{
    
    NSArray *array = nil;
    
    if (word != nil) {
        
        array = @[word];
        
    }
    
    return [self randomWordNotContainedInArray:array];
    
}

- (WRCWordInfo *)randomWordNotContainedInArray:(NSArray *)array
{
    
    NSMutableArray *allWords = [[self.wordStore objects] mutableCopy];
    
    [allWords removeObjectsInArray:array];
    
    WRCWordInfo *randomWord = [allWords randomObject];
    
    return randomWord;
    
}

- (NSArray *)randomWordsNotIncluding:(WRCWordInfo *)word withCount:(NSInteger)count
{
    
    NSMutableArray *randomWords = [NSMutableArray arrayWithCapacity:count];
    
    while ([randomWords count] < count) {
        
        NSArray *bannedWords = [randomWords arrayByAddingObject:word];
        
        WRCWordInfo *randomWord = [self randomWordNotContainedInArray:bannedWords];
        
        [randomWords addObject:randomWord];
            
    }
    
    return [randomWords copy];
    
}

- (void)setWordStore:(ATObjectStore *)wordStore
{
    
    _wordStore = wordStore;
    
    if (self.currentWord == nil) {
        
        [self showNextWord];
        
    }
    else {
        
        [self configureViewForWord:self.currentWord];
        
    }
    
}

@end
