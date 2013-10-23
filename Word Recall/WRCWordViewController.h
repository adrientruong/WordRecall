//
//  WRCWordViewController.h
//  Word Recall
//
//  Created by Adrien Truong on 10/20/13.
//  Copyright (c) 2013 Adrien Truong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WRCWord;
@class WRCWordStore;

@interface WRCWordViewController : UIViewController

@property (nonatomic, strong) WRCWord *word;
@property (nonatomic, strong) WRCWordStore *wordStore;

@end
