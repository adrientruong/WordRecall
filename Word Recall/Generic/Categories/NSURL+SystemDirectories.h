//
//  NSURL+SystemDirectories.h
//  Workout Hero
//
//  Created by Adrien Truong on 11/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (SystemDirectories)

+ (NSURL *)cacheDirectoryURL;
+ (NSURL *)documentsDirectoryURL;

@end
