//
//  WRCQuizViewController.m
//  Word Recall
//
//  Created by Adrien Truong on 9/21/13.
//  Copyright (c) 2013 Adrien Truong. All rights reserved.
//

#import "WRCQuizViewController.h"
#import "WRCWordDefinitionTableViewPickerView.h"
#import "WRCWordDefinition.h"
#import "WRCQuizWord.h"
#import "WRCQuizWord+Custom.h"
#import "NSArray+Shuffle.h"
#import "NSArray+RandomObject.h"
#import "WRCWordStore.h"

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

    self.pickerView.itemTitleKeyPath = @"quizDefinition.definition";
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
    
    WRCQuizWord *selectedWord = [pickerView lastSelectedItem];
    WRCQuizWord *deselectedWord = [pickerView lastDeselectedItem];
    
    if ([selectedWord isEqual:self.currentWord] || [deselectedWord isEqual:self.currentWord]) {
        
        if ([pickerView.selectedItems count] == 1 && [pickerView.selectedItems firstObject] == self.currentWord) {
            
            [self.currentWord incrementQuizCount];
            
        }
        
        [self showNextWord];
        
    }
    else {
        
        if ([pickerView.selectedItems count] == 1) {
            
            [self.currentWord incrementMissCount];
            [self.currentWord incrementQuizCount];
            
        }
        
        [self.currentWord addIncorrectWordAssociationsObject:selectedWord];
        
    }
    
}

- (IBAction)showCorrectAnswer
{
    
    self.pickerView.selectedItems = [self.pickerView.selectedItems arrayByAddingObject:self.currentWord];
    
    [self.currentWord incrementMissCount];
    [self.currentWord incrementQuizCount];

}

- (void)configureViewForWord:(WRCQuizWord *)word
{
    
    NSMutableArray *answerChoices = [NSMutableArray arrayWithObject:word];
    
    [answerChoices addObjectsFromArray:[self.wordStore randomWordsNotIncludingWord:word count:self.answerChoicesCount - 1]];
    [answerChoices shuffle];
    
    self.pickerView.items = answerChoices;
    self.pickerView.selectedItems = nil;
    
    self.pickerView.correctWord = word;
    
    NSMutableArray *possibleWords = [[[[word quizDefinition] synonyms] allObjects] mutableCopy];
    
    [possibleWords addObject:word.word];
    
    self.wordLabel.text = [possibleWords randomObject];
    
}

- (void)showNextWord
{
    
    self.currentWord = (WRCQuizWord *)[self.wordStore randomWordNotWord:self.currentWord];
    
    [self configureViewForWord:self.currentWord];
    
    [self.currentWord incrementQuizCount];
    
}

- (WRCQuizWord *)randomWord
{
    
    return nil;
    
}

- (void)setWordStore:(WRCWordStore *)wordStore
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
