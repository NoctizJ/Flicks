//
//  MovieData.m
//  Flicks
//
//  Created by Yuning Jin on 9/13/16.
//  Copyright © 2016 Yuning Jin. All rights reserved.
//

#import "MovieData.h"

@implementation MovieData

- (instancetype)initWithEndpoint:(NSString *)endpoint title:(NSString *)title overview:(NSString *)overview
{
    self = [super init];
    
    if (self != nil)
    {
        _endpoint = endpoint;
        _title = title;
        _overview = overview;
    }
    
    return self;
}

@end
