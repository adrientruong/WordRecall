//
//  WRCWordDefinitionTableViewPickerView.h
//  Word Recall
//
//  Created by Adrien Truong on 9/21/13.
//  Copyright (c) 2013 Adrien Truong. All rights reserved.
//

#import "ATTableViewPickerView.h"

@class WRCQuizWord;

@interface WRCWordDefinitionTableViewPickerView : ATTableViewPickerView

@property (nonatomic, strong) WRCQuizWord *correctWord;

@end
