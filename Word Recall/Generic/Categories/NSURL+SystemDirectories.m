//
//  NSURL+SystemDirectories.m
//  Workout Hero
//
//  Created by Adrien Truong on 11/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSURL+SystemDirectories.h"

@implementation NSURL (SystemDirectories)

+ (NSURL *)cacheDirectoryURL
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths objectAtIndex:0];
    NSURL *cacheURL = [NSURL fileURLWithPath:cachePath];
    
    return cacheURL;
    
}

+ (NSURL *)documentsDirectoryURL
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}



@end
