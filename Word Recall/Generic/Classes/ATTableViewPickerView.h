//
//  ATTableViewPickerView.h
//  Word Recall
//
//  Created by Adrien Truong on 9/21/13.
//  Copyright (c) 2013 Adrien Truong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ATTableViewPickerView : UIControl

- (void)configureCell:(UITableViewCell *)cell forItem:(id)item selected:(BOOL)isSelected;
- (id)lastSelectedItem;

@property (nonatomic, strong, readonly) UITableView *tableView;

@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) NSArray *selectedItems;
/*
 
 The controller calls containsObject: on this array to determine whether an item is selected. Therefore, objects should implement isEqual:.
 
 */

@property (nonatomic, strong) UIColor *selectedItemsTextColor;
/*
 
 This UIColor object is not created until needed.
 
 Default value is [UIColor colorWithRed:81.0/255.0 green:102.0/255.0 blue:145.0/255.0 alpha:1.0];
 
 */

@property (nonatomic, copy) NSString * (^itemTitleBlock)(id item);
/*
 
 This block has one parameter, item. The responsiblity of this block is to return a string suitable for display for this item.
 
 If both itemTitleBlock and itemTitleKeyPath are implemented, the controller will use itemTitleKeyPath.
 
 
 */
@property (nonatomic, copy) NSString *itemTitleKeyPath;

/*
 
 The controller will call valueForKeyPath: on each item passing in 'itemTitleKeyPath' to get a NSString object to display.
 
 If both itemTitleBlock and itemTitleKeyPath are implemented, the controller will use itemTitleKeyPath.
 
 */


@property (nonatomic, assign) NSInteger minimumNumberOfSelections;
/*
 
 A value of -1 means there is no minimum.
 
 Default value is -1
 
 */

@property (nonatomic, assign) NSInteger maximumNumberOfSelections;
/*
 
 A value of -1 means there is no maximum.
 
 Default value is -1.
 
 */

@end
