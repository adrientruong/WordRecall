//
//  WRCWordDefinitionTableViewPickerView.m
//  Word Recall
//
//  Created by Adrien Truong on 9/21/13.
//  Copyright (c) 2013 Adrien Truong. All rights reserved.
//

#import "WRCWordDefinitionTableViewPickerView.h"
#import "WRCWordInfo.h" 

@implementation WRCWordDefinitionTableViewPickerView

- (void)configureCell:(UITableViewCell *)cell forItem:(id)item selected:(BOOL)isSelected
{
    
    [super configureCell:cell forItem:item selected:isSelected];
    
    if (isSelected) {
        
        WRCWordInfo *wordInfo = item;
        
        if ([wordInfo isEqualToWordInfo:self.correctWordInfo] == NO) {
            
            cell.textLabel.textColor = [UIColor redColor];
            
            cell.detailTextLabel.text = @"X";
            cell.detailTextLabel.textColor = [UIColor redColor];
            
            cell.accessoryType = UITableViewCellAccessoryNone;
            
        }
        else {
            
            cell.detailTextLabel.text = nil;

        }
        
    }
    else {
        
        cell.detailTextLabel.text = nil;

    }
    
}

@end
