//
//  WRCWordDefinitionTableViewPickerView.h
//  Word Recall
//
//  Created by Adrien Truong on 9/21/13.
//  Copyright (c) 2013 Adrien Truong. All rights reserved.
//

#import "ATTableViewPickerView.h"

@class WRCWordInfo;

@interface WRCWordDefinitionTableViewPickerView : ATTableViewPickerView

@property (nonatomic, strong) WRCWordInfo *correctWordInfo;

@end
