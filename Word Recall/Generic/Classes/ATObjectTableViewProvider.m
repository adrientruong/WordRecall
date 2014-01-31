//
//  ATObjectTableViewProvider.m
//  Word Recall
//
//  Created by Adrien Truong on 9/28/13.
//  Copyright (c) 2013 Adrien Truong. All rights reserved.
//

#import "ATObjectTableViewProvider.h"
#import "NSObject+KeyPaths.h"
#import "NSString+StringWithFormatExtension.h"

@implementation ATObjectTableViewProvider

#pragma mark - Subclass Methods

- (NSInteger)numberOfSections
{
    return 0;
}

- (NSInteger)numberOfObjectsForSection:(NSInteger)section
{
    return 0;
}

- (id)objectForIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (NSIndexPath *)indexPathForObject:(id)object
{
    return nil;
}

#pragma mark - Internal Methods

- (UIView *)newSectionHeaderViewWithReuseIdentifier:(NSString *)identifier
{
    if ([self.delegate respondsToSelector:@selector(tableViewProvider:newSectionHeaderViewWithReuseIdentifier:)]) {
        return [self.delegate tableViewProvider:self newSectionHeaderViewWithReuseIdentifier:identifier];
    }
    else {
        return nil;
    }
}

- (UIView *)newSectionFooterViewWithReuseIdentifier:(NSString *)identifier
{
    if ([self.delegate respondsToSelector:@selector(tableViewProvider:newSectionFooterViewWithReuseIdentifier:)]) {
        return [self.delegate tableViewProvider:self newSectionFooterViewWithReuseIdentifier:identifier];
    }
    else {
        return nil;
    }
}

- (NSString *)defaultHeaderTextForSectionContainingObject:(id)object
{
    return nil;
}

- (NSString *)defaultFooterTextForSectionContainingObject:(id)object
{
    return nil;
}

- (NSString *)headerTextForSectionContainingObject:(id)object
{
    if ([self.delegate respondsToSelector:@selector(tableViewProvider:headerTextForSectionContainingObject:)]) {
        return [self.delegate tableViewProvider:self headerTextForSectionContainingObject:object];
    }
    else {
        return [self defaultHeaderTextForSectionContainingObject:object];
    }
}

- (NSString *)footerTextForSectionContainingObject:(id)object
{
    if ([self.delegate respondsToSelector:@selector(tableViewProvider:footerTextForSectionContainingObject:)]) {
        return [self.delegate tableViewProvider:self footerTextForSectionContainingObject:object];
    }
    else {
        return [self defaultFooterTextForSectionContainingObject:object];
    }
}

- (NSString *)cellReuseIdentifierForObject:(id)object atIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(tableViewProvider:cellReuseIdentifierForObject:atIndexPath:)]) {
        return [self.delegate tableViewProvider:self cellReuseIdentifierForObject:object atIndexPath:indexPath];
    }
    else if ([self.cellReuseIdentifier length] > 0) {
        return self.cellReuseIdentifier;
    }
    else {
        return @"ATTableViewProviderDefaultTableViewCellIdentifier";
    }
}

- (UITableViewCell *)newCellWithReuseIdentifier:(NSString *)identifier
{
    if ([self.delegate respondsToSelector:@selector(tableViewProvider:newCellWithReuseIdentifier:)]) {
        return [self.delegate tableViewProvider:self newCellWithReuseIdentifier:identifier];
    }
    else {
        return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
}

- (UITableViewCellEditingStyle)editingStyleForCellContainingObject:(id)object
{
    if ([self.delegate respondsToSelector:@selector(tableViewProvider:editingStyleForCellForObject:)]) {
        return [self.delegate tableViewProvider:self editingStyleForCellForObject:object];
    }
    else {
        return UITableViewCellEditingStyleNone;
    }
    
}

- (NSString *)stringFromFormat:(NSString *)format withObjectKeyPaths:(NSArray *)keyPaths object:(id)object
{
    NSArray *values = [object arrayWithValuesForKeyPaths:keyPaths];
    NSMutableArray *nonNullValues = [NSMutableArray arrayWithCapacity:[values count]];
    
    for (id value in values) {
        id nonNullValue = value;
        if (value == [NSNull null]) {
            nonNullValue = @"";
        }
        
        [nonNullValues addObject:nonNullValue];
    }
    
    NSString *text = [NSString stringWithFormat:format argumentsArray:nonNullValues];
    
    return text;
}


#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self numberOfObjectsForSection:section];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id object = [self objectForIndexPath:indexPath];
    
    NSString *cellReuseIdentifier = [self cellReuseIdentifierForObject:object atIndexPath:indexPath];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier];
    
    if (cell == nil) {
        cell = [self newCellWithReuseIdentifier:cellReuseIdentifier];
    }
    
    if ([self.cellTextLabelTextFormat length] > 0) {
        cell.textLabel.text = [self stringFromFormat:self.cellTextLabelTextFormat withObjectKeyPaths:self.cellTextLabelTextFormatKeyPaths object:object];
    }
    
    if ([self.cellDetailTextLabelTextFormat length] > 0) {
        cell.detailTextLabel.text = [self stringFromFormat:self.cellDetailTextLabelTextFormat withObjectKeyPaths:self.cellDetailTextLabelTextFormatKeyPaths object:object];
    }
    
    [self.delegate tableViewProvider:self configureCell:cell forObject:object];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id object = [self objectForIndexPath:indexPath];
    
    if ([self.delegate respondsToSelector:@selector(tableViewProvider:didSelectObject:)]) {
        [self.delegate tableViewProvider:self didSelectObject:object];
    }
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
        
        [self.delegate tableViewProvider:self willDeleteObject:object];
        
        NSInteger objectsInSectionCount = [self numberOfObjectsForSection:indexPath.section];
        if (objectsInSectionCount == 0) {
            [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        else {
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
}

@end
