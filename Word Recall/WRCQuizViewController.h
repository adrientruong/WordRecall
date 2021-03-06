//
//  WRCQuizViewController.h
//  Word Recall
//
//  Created by Adrien Truong on 9/21/13.
//  Copyright (c) 2013 Adrien Truong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WRCWordStore;
@class WRCWordDefinition;

@interface WRCQuizViewController : UIViewController

@property (nonatomic, strong) WRCWordStore *wordStore;

@property (nonatomic, strong) WRCWordDefinition *currentWordDefinition;

@property (nonatomic, assign) NSInteger answerChoicesCount;

@end
