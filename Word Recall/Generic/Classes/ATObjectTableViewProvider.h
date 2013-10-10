//
//  ATObjectTableViewDataSource.h
//  Word Recall
//
//  Created by Adrien Truong on 9/28/13.
//  Copyright (c) 2013 Adrien Truong. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ATObjectTableViewProviderDelegate;

@interface ATObjectTableViewProvider : NSObject <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) id <ATObjectTableViewProviderDelegate> delegate;
@property (nonatomic, copy) NSString *cellReuseIdentifier;

@property (nonatomic, copy) NSString *cellTextLabelTextFormat;
@property (nonatomic, copy) NSString *cellDetailTextLabelTextFormat;
@property (nonatomic, copy) NSArray *cellTextLabelTextFormatKeyPaths;
@property (nonatomic, copy) NSArray *cellDetailTextLabelTextFormatKeyPaths;

//subclasses MUST override
- (NSInteger)numberOfSections;
- (NSInteger)numberOfObjectsForSection:(NSInteger)section;

- (id)objectForIndexPath:(NSIndexPath *)indexPath;
- (NSIndexPath *)indexPathForObject:(id)object;

//subclasses may override
- (NSString *)defaultHeaderTextForSectionContainingObject:(id)object;
- (NSString *)defaultFooterTextForSectionContainingObject:(id)object;

@end

@protocol ATObjectTableViewProviderDelegate <NSObject>

@optional
- (UIView *)tableViewProvider:(ATObjectTableViewProvider *)dataSource newSectionHeaderViewWithReuseIdentifier:(NSString *)identifier;
- (UIView *)tableViewProvider:(ATObjectTableViewProvider *)dataSource newSectionFooterViewWithReuseIdentifier:(NSString *)identifier;

- (NSString *)tableViewProvider:(ATObjectTableViewProvider *)dataSource headerTextForSectionContainingObject:(id)object;
- (NSString *)tableViewProvider:(ATObjectTableViewProvider *)dataSource footerTextForSectionContainingObject:(id)object;

- (NSString *)tableViewProvider:(ATObjectTableViewProvider *)dataSource cellReuseIdentifierForObject:(id)object atIndexPath:(NSIndexPath *)indexPath;
- (UITableViewCell *)tableViewProvider:(ATObjectTableViewProvider *)dataSource newCellWithReuseIdentifier:(NSString *)identifier;
- (void)tableViewProvider:(ATObjectTableViewProvider *)dataSource configureCell:(UITableViewCell *)cell forObject:(id)object;

- (UITableViewCellEditingStyle)tableViewProvider:(ATObjectTableViewProvider *)dataSource editingStyleForCellForObject:(id)object;
- (void)tableViewProvider:(ATObjectTableViewProvider *)dataSource willDeleteObject:(id)object;

- (void)tableViewProvider:(ATObjectTableViewProvider *)dataSource didSelectObject:(id)object;

@end