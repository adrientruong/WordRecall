//
//  ATObjectArrayBackedTableViewDataSource.h
//  Word Recall
//
//  Created by Adrien Truong on 9/28/13.
//  Copyright (c) 2013 Adrien Truong. All rights reserved.
//

#import "ATObjectTableViewProvider.h"

@interface ATObjectArrayTableViewProvider : ATObjectTableViewProvider

@property (nonatomic, strong) NSArray *array;

@end
