//
//  WRCQuizWordListViewController.h
//  Word Recall
//
//  Created by Adrien Truong on 9/29/13.
//  Copyright (c) 2013 Adrien Truong. All rights reserved.
//

#import "ATObjectListViewController.h"

typedef NS_ENUM(NSUInteger, WRCWordListViewControllerFilterType) {
    
    WRCWordListViewControllerFilterTypeNone = 0,
    WRCWordListViewControllerFilterTypeMissedWords,
    
};

@class WRCWordStore;

@interface WRCWordListViewController : ATObjectListViewController

@property (nonatomic, strong) WRCWordStore *wordStore;

@property (nonatomic, assign) WRCWordListViewControllerFilterType filterType;

@end
