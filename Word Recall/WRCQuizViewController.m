//
//  WRCQuizViewController.m
//  Word Recall
//
//  Created by Adrien Truong on 9/21/13.
//  Copyright (c) 2013 Adrien Truong. All rights reserved.
//

#import "WRCQuizViewController.h"
#import "WRCAnswerTableViewPickerView.h"
#import "WRCWordDefinition.h"
#import "WRCWord.h"
#import "NSArray+Shuffle.h"
#import "NSArray+RandomObject.h"
#import "WRCWordStore.h"
#import "WRCWord+Custom.h"
#import "WRCWordDefinitionQuizPerformance+Custom.h"
#import "WRCQuizAnswer.h"
#import <AVFoundation/AVFoundation.h>
#import "WRCWordDefinition+Custom.h"

@interface WRCQuizViewController ()

@property (nonatomic, strong) WRCAnswerTableViewPickerView *pickerView;
@property (nonatomic, weak) IBOutlet UILabel *wordLabel;
@property (nonatomic, strong) IBOutlet UIView *noWordsToQuizView;
@property (nonatomic, weak) IBOutlet UILabel *remainingWordCountLabel;
@property (nonatomic, strong) IBOutlet UILabel *timeUntilNextQuizLabel;
@property (nonatomic, strong) AVPlayer *player;

- (IBAction)showCorrectAnswer;
- (IBAction)refreshButtonWasTapped;
- (IBAction)longPressGestureRecognizerDidRecognize:(UILongPressGestureRecognizer *)gestureRecognizer;

@end

@implementation WRCQuizViewController

#pragma mark - Init

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self != nil) {
        
        self.answerChoicesCount = 5;
        
        self.title = NSLocalizedString(@"Quiz", @"");
       
    }
    
    return self;
    
}

#pragma mark - View Life Cycle

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    [self.remainingWordCountLabel removeFromSuperview]; //clear constraints
    [self.view addSubview:self.remainingWordCountLabel];
    
    id bottomLayoutGuide = self.bottomLayoutGuide;
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_remainingWordCountLabel, bottomLayoutGuide);

    //should be using V:[_remainingWordCountLabel]-8-[bottomLayoutGuide] but bottomLayoutGuide is bugged so we use a hard coded 8 + 49 (tab bar height)
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_remainingWordCountLabel]-57-|" options:0 metrics:nil views:views]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.remainingWordCountLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    
    self.pickerView = [[WRCAnswerTableViewPickerView alloc] init];
    
    [self.view insertSubview:self.pickerView belowSubview:self.remainingWordCountLabel];
    
    self.pickerView.translatesAutoresizingMaskIntoConstraints = NO;
    
    views = NSDictionaryOfVariableBindings(_wordLabel, _pickerView);
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_wordLabel][_pickerView]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_pickerView]|" options:0 metrics:nil views:views]];

    self.pickerView.itemTitleKeyPath = @"definition";
    self.pickerView.minimumNumberOfSelections = 0;
    self.pickerView.maximumNumberOfSelections = -1;
    
    self.pickerView.tableView.rowHeight = 60;
    
    [self.pickerView addTarget:self action:@selector(didSelectDefinition:) forControlEvents:UIControlEventValueChanged];
    
    if (self.wordStore != nil) {
     
        if (self.currentWordDefinition == nil) {
            
            [self showNextWordDefinition];
            
        }
        else {
            
            [self configureViewForWordDefinition:self.currentWordDefinition];
            
        }
        
    }
    
}

#pragma mark - Actions

- (void)didSelectDefinition:(WRCAnswerTableViewPickerView *)pickerView
{
    
    WRCWord *selectedWordDefinition = [pickerView lastSelectedItem];
    WRCWord *deselectedWordDefinition = [pickerView lastDeselectedItem];
    
    if ([selectedWordDefinition isEqual:self.currentWordDefinition] || [deselectedWordDefinition isEqual:self.currentWordDefinition]) {
        
        [self.wordStore insertQuizAnswerWithActualWordDefinition:self.currentWordDefinition pickedWordDefinitions:[NSSet setWithArray:pickerView.selectedItems]];
        
        [self.wordStore save];

        [self showNextWordDefinition];
        
    }

}

- (IBAction)showCorrectAnswer
{
    
    self.pickerView.selectedItems = [self.pickerView.selectedItems arrayByAddingObject:self.currentWordDefinition];
    
}

- (IBAction)refreshButtonWasTapped
{
    
    if (self.currentWordDefinition == nil) {
        
        [self showNextWordDefinition];
        
    }
    
}

- (IBAction)longPressGestureRecognizerDidRecognize:(UILongPressGestureRecognizer *)gestureRecognizer
{
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        
        [self playPronunciationAudio];
        
    }
    
}

#pragma mark - Pronunciation Audio

- (void)playPronunciationAudio
{
    
    if (self.player.rate != 0) {
        
        return;
        
    }
    
    NSURL *currentURL = nil;
    
    AVURLAsset *currentAsset = (AVURLAsset *)self.player.currentItem.asset;
    
    if ([currentAsset isKindOfClass:[AVURLAsset class]]) {
     
        currentURL = currentAsset.URL;
        
    }
    
    if ([currentURL isEqual:[self.currentWordDefinition pronunciationAudioURL]]) {
        
        [self.player seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
            
            if (finished) {
             
                [self.player play];
                
            }
            else {
                
                NSLog(@"Something went wrong seeking to beginning.");
                
            }
            
        }];
        
    }
    else {
        
        self.player = [AVPlayer playerWithURL:[self.currentWordDefinition pronunciationAudioURL]];
        
        [self.player play];
        
    }
    
}

#pragma mark - Update UI

- (void)configureViewForWordDefinition:(WRCWordDefinition *)wordDefinition
{
    
    NSMutableArray *answerChoices = [NSMutableArray arrayWithObject:wordDefinition];
    
    [answerChoices addObjectsFromArray:wordDefinition.quizPerformance.incorrectWordDefinitionAssociations];
    
    NSUInteger remainingNeededAnswerChoicesCount = self.answerChoicesCount - [answerChoices count];
    NSArray *remainingNeededAnswerChoices = [[self.wordStore randomWordsNotIncludingWord:wordDefinition.word count:remainingNeededAnswerChoicesCount] valueForKey:@"quizDefinition"];
    [answerChoices addObjectsFromArray:remainingNeededAnswerChoices];
    
    [answerChoices shuffle];
    
    self.pickerView.items =  answerChoices;
    self.pickerView.selectedItems = nil;
    
    self.pickerView.correctAnswer = wordDefinition;
    
    self.wordLabel.text = wordDefinition.word.word;
    
}

- (void)updateRemainingWordCountLabel
{
    
    NSArray *wordsDueForQuizzing = [self.wordStore wordDefinitionsDueForQuizzingWithMaxCount:NSUIntegerMax];
    
    NSString *localizedFormat = NSLocalizedString(@"%i left", @"");
    
    self.remainingWordCountLabel.text = [NSString stringWithFormat:localizedFormat, [wordsDueForQuizzing count]];
    
}

- (void)showNextWordDefinition
{
    
    self.currentWordDefinition = [self.wordStore wordDefinitionDueForQuizzing];
    
}

- (void)showNoWordsToQuizView
{
    
    if (self.noWordsToQuizView.superview == self.view) {
        
        return;
        
    }
    
    [self.view addSubview:self.noWordsToQuizView];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_noWordsToQuizView);
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_noWordsToQuizView]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_noWordsToQuizView]|" options:0 metrics:nil views:views]];
    
}

- (void)hideNoWordsToQuizView
{
    
    [self.noWordsToQuizView removeFromSuperview];
    
}

#pragma mark - Setting Word Store

- (void)setWordStore:(WRCWordStore *)wordStore
{
    
    if (_wordStore == wordStore) {
        
        return;
        
    }
    
    _wordStore = wordStore;
    
    [self showNextWordDefinition];
    
}

- (void)setCurrentWordDefinition:(WRCWordDefinition *)currentWordDefinition
{
    
    if (_currentWordDefinition == currentWordDefinition) {
        
        return;
        
    }
    
    _currentWordDefinition = currentWordDefinition;
    
    if (self.isViewLoaded) {
    
        if (self.currentWordDefinition == nil) {
            
            [self showNoWordsToQuizView];
            
        }
        else {
            
            [self hideNoWordsToQuizView];
            
            [self configureViewForWordDefinition:self.currentWordDefinition];
            [self updateRemainingWordCountLabel];
            
        }
        
    }
    
}

@end
