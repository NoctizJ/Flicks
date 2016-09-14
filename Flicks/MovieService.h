//
//  MovieService.h
//  Flicks
//
//  Created by Yuning Jin on 9/13/16.
//  Copyright © 2016 Yuning Jin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MovieService : NSObject

@property (nonatomic, strong) NSString *endpoint;

@property (nonatomic, strong, readonly) NSArray *movies;


- (instancetype) initWithEndpoint:(NSString *)endpoint;
- (void) getAssets:(NSString *)endpoint;
@end
