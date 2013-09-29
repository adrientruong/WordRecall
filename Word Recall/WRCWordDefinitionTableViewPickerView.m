//
//  WRCWordDefinitionTableViewPickerView.m
//  Word Recall
//
//  Created by Adrien Truong on 9/21/13.
//  Copyright (c) 2013 Adrien Truong. All rights reserved.
//

#import "WRCWordDefinitionTableViewPickerView.h"
#import "WRCQuizWord.h"

@implementation WRCWordDefinitionTableViewPickerView

- (void)configureCell:(UITableViewCell *)cell forItem:(id)item selected:(BOOL)isSelected
{
    
    [super configureCell:cell forItem:item selected:isSelected];
    
    if (isSelected) {
        
        WRCWord *word = item;
        
        if ([word isEqual:self.correctWord] == NO) {
            
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
