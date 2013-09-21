//
//  GOOJSONPResponseSerializer.m
//  Word Recall
//
//  Created by Adrien Truong on 9/21/13.
//  Copyright (c) 2013 Adrien Truong. All rights reserved.
//

#import "GOOJSONPResponseSerializer.h"

@implementation GOOJSONPResponseSerializer

- (id)responseObjectForResponse:(NSURLResponse *)response
                           data:(NSData *)data
                          error:(NSError *__autoreleasing *)error
{
    
    NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    responseString = [responseString stringByReplacingOccurrencesOfString:@"\\x" withString:@"\\u00"];
    
    data = [responseString dataUsingEncoding:NSUTF8StringEncoding];
    
    return [super responseObjectForResponse:response data:data error:error];
    
}


@end
