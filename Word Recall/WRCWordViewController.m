//
//  WRCWordViewController.m
//  Word Recall
//
//  Created by Adrien Truong on 10/20/13.
//  Copyright (c) 2013 Adrien Truong. All rights reserved.
//

#import "WRCWordViewController.h"
#import "WRCWord.h"
#import "WRCWord+Custom.h"
#import "WRCWordStore.h"
#import "ATTableViewPickerView.h"

@interface WRCWordViewController ()

@property (nonatomic, weak) IBOutlet UILabel *nextQuizDateLabel;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, weak) IBOutlet UILabel *wordLabel;
@property (nonatomic, weak) IBOutlet ATTableViewPickerView *tableViewPickerView;

- (IBAction)tableViewPickerViewValueDidChange:(ATTableViewPickerView *)pickerView;

@end

@implementation WRCWordViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self != nil) {
        
    }
    
    return self;
}

- (void)updateViewForWord:(WRCWord *)word
{
    self.wordLabel.text = word.word;
    self.nextQuizDateLabel.text = [self.dateFormatter stringFromDate:[self.wordStore nextQuizDateForWordDefinition:[self.word quizDefinition]]];
    
    self.tableViewPickerView.items = [self.word.definitions array];
    self.tableViewPickerView.selectedItems = @[[self.word quizDefinition]];
    self.tableViewPickerView.maximumNumberOfSelections = 1;
    self.tableViewPickerView.minimumNumberOfSelections = 1;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableViewPickerView.itemTitleKeyPath = @"definition";
    
    [self updateViewForWord:self.word];
}

- (IBAction)tableViewPickerViewValueDidChange:(ATTableViewPickerView *)pickerView
{
    self.word.quizDefinitionIndex = [self.word.definitions indexOfObject:[pickerView.selectedItems firstObject]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSDateFormatter *)dateFormatter
{
    if (_dateFormatter == nil) {
        self.dateFormatter = [[NSDateFormatter alloc] init];
        
        _dateFormatter.dateStyle = NSDateFormatterShortStyle;
        _dateFormatter.timeStyle = NSDateFormatterShortStyle;
    }
    
    return _dateFormatter;
}

- (void)setWord:(WRCWord *)word
{
    _word = word;
    
    if (self.isViewLoaded) {
        [self updateViewForWord:self.word];
    }
}

@end