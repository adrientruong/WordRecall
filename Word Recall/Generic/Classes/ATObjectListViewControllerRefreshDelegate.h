//
//  ATObjectListViewControllerRefreshDelegate.h
//  DoTA2
//
//  Created by Adrien Truong on 7/24/13.
//  Copyright (c) 2013 Adrien Truong. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ATObjectListViewController;

@protocol ATObjectListViewControllerRefreshDelegate <NSObject>

- (void)objectListViewControllerDidInitiateRefresh:(ATObjectListViewController *)objectListViewController;
/*
 
 If ATObjectListViewController depends on another object for refreshing its data, this other object needs to implement this delegate method and then call endRefreshing after setting its objects property.
 
 */

@end
