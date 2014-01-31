//
//  ATTableViewPickerView.m
//  Word Recall
//
//  Created by Adrien Truong on 9/21/13.
//  Copyright (c) 2013 Adrien Truong. All rights reserved.
//

#import "ATTableViewPickerView.h"

@interface ATTableViewPickerView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong, readwrite) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *mutableSelectedItems;
@property (nonatomic, strong) id lastDeselectedItem;

@end

@implementation ATTableViewPickerView

#pragma mark - Init

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self != nil) {
        [self commonInit];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self != nil) {
        [self commonInit];
    }
    
    return self;
}

- (void)commonInit
{
    self.tableView = [[UITableView alloc] initWithFrame:self.frame style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self addSubview:self.tableView];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_tableView);
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_tableView]|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_tableView]|" options:0 metrics:nil views:views]];
    
    self.selectedItemsTextColor = self.tintColor;
}

#pragma mark - Items

- (id)lastSelectedItem
{
    return [self.mutableSelectedItems lastObject];
}

- (BOOL)isItemSelected:(id)item
{
    return ([self.mutableSelectedItems indexOfObjectIdenticalTo:item] != NSNotFound);
}

#pragma mark - UITableView

- (id)itemForIndexPath:(NSIndexPath *)indexPath
{
    return self.items[indexPath.row];
}

- (NSIndexPath *)indexPathForItem:(id)item
{
    NSInteger row = [self.items indexOfObject:item];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    
    return indexPath;
}

- (NSString *)cellTextForItem:(id)item
{
    NSString *cellText = nil;
    
    NSAssert(self.itemTitleKeyPath != nil || self.itemTitleBlock != nil, @"\"itemTitleKeyPath\" and \"itemTitleBlock\" are nil. At least one must but non nil");
    
    if (self.itemTitleKeyPath != nil) {
        cellText = [item valueForKeyPath:self.itemTitleKeyPath];
    }
    else if (self.itemTitleBlock != nil) {
        cellText = self.itemTitleBlock(item);
    }
    
    NSAssert([cellText isKindOfClass:[NSString class]] == YES, @"\"itemTitleBlock\" or \"itemTitleKeyPath\" did not return a NSString object");
    
    return cellText;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.items count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id item = [self itemForIndexPath:indexPath];
    NSString *text = [self cellTextForItem:item];
    
    CGFloat width = tableView.frame.size.width - (tableView.separatorInset.left * 2);
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleBody]} context:nil];
    
    return MAX(rect.size.height + 10, tableView.rowHeight);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ItemRowIdentifier = @"Item Row";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ItemRowIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ItemRowIdentifier];
        
        cell.textLabel.numberOfLines = 0;
    }
    
    cell.textLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    
    id item = [self itemForIndexPath:indexPath];
    
    BOOL isSelected = [self isItemSelected:item];
    
    [self configureCell:cell forItem:item selected:isSelected];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell forItem:(id)item selected:(BOOL)isSelected
{
    cell.textLabel.text = [self cellTextForItem:item];
    
    if (isSelected) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.textLabel.textColor = self.selectedItemsTextColor;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.textColor = [UIColor blackColor];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *indexPathsToReload = [[NSMutableArray alloc] init];
    [indexPathsToReload addObject:indexPath];
    
    id item = [self itemForIndexPath:indexPath];
    
    id selectedItem = item;
    id deselectedItem = nil;
    
    if ([self.mutableSelectedItems containsObject:item] == YES) {
        if ([self.mutableSelectedItems count] - 1 >= self.minimumNumberOfSelections && self.minimumNumberOfSelections != -1) {
            [self.mutableSelectedItems removeObject:item];
            
            deselectedItem = item;
            selectedItem = nil;
            
            self.lastDeselectedItem = item;
            
            [self sendActionsForControlEvents:UIControlEventValueChanged];
        }
    }
    else {
        if ([self.mutableSelectedItems count] == self.maximumNumberOfSelections && self.maximumNumberOfSelections != -1) {
            id object = self.mutableSelectedItems[0];
            
            NSIndexPath *indexPathOfRemovedObject = [self indexPathForItem:object];
            [indexPathsToReload addObject:indexPathOfRemovedObject];
            
            deselectedItem = self.mutableSelectedItems[0];
            [self.mutableSelectedItems removeObjectAtIndex:0];
        }
        
        [self.mutableSelectedItems addObject:item];
        
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
    
    [tableView reloadRowsAtIndexPaths:indexPathsToReload withRowAnimation:UITableViewRowAnimationNone];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Setting List of Items

- (void)setItems:(NSArray *)newItems
{
    _items = newItems;
    
    [self.tableView reloadData];
}

#pragma mark - Setting and Retrieving Selected Items

- (void)setSelectedItems:(NSArray *)newSelectedItems
{
    self.mutableSelectedItems = [NSMutableArray arrayWithArray:newSelectedItems];
    
    NSArray *visibleIndexPaths = [self.tableView indexPathsForVisibleRows];
    [self.tableView reloadRowsAtIndexPaths:visibleIndexPaths withRowAnimation:UITableViewRowAnimationNone];
}

- (NSArray *)selectedItems
{
    return [NSArray arrayWithArray:self.mutableSelectedItems];
}

- (NSMutableArray *)mutableSelectedItems
{
    if (_mutableSelectedItems == nil) {
        self.mutableSelectedItems = [NSMutableArray array];
    }
    
    return _mutableSelectedItems;
}

@end
