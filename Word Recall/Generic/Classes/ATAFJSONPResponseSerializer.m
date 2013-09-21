//
//  ATAFJSONPResponseSerializer.m
//  Word Recall
//
//  Created by Adrien Truong on 9/21/13.
//  Copyright (c) 2013 Adrien Truong. All rights reserved.
//

#import "ATAFJSONPResponseSerializer.h"

@implementation ATAFJSONPResponseSerializer

- (id)responseObjectForResponse:(NSURLResponse *)response
                           data:(NSData *)data
                          error:(NSError *__autoreleasing *)error
{
    
    NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSRange begin = [responseString rangeOfString:@"({" options:NSLiteralSearch];
    NSRange end = [responseString rangeOfString:@"}" options:NSBackwardsSearch|NSLiteralSearch];
    
    BOOL parseFail = (begin.location == NSNotFound || end.location == NSNotFound || end.location - begin.location < 2);
    
    if (!parseFail) {
        
        responseString = [responseString substringWithRange:NSMakeRange(begin.location + 1, (end.location - begin.location))];
        
        data = [responseString dataUsingEncoding:NSUTF8StringEncoding];

        return [super responseObjectForResponse:response data:data error:error];
        
    }
    else {
        
        return nil;
        
    }
    
}

@end
