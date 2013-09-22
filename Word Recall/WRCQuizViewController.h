//
//  WRCQuizViewController.h
//  Word Recall
//
//  Created by Adrien Truong on 9/21/13.
//  Copyright (c) 2013 Adrien Truong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ATObjectStore;
@class WRCWordInfo;

@interface WRCQuizViewController : UIViewController

@property (nonatomic, strong) ATObjectStore *wordStore;

@property (nonatomic, strong) WRCWordInfo *currentWord;

@property (nonatomic, assign) NSInteger answerChoicesCount;

@end
