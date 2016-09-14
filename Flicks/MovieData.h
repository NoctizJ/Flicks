//
//  MovieData.h
//  Flicks
//
//  Created by Yuning Jin on 9/13/16.
//  Copyright © 2016 Yuning Jin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MovieData : NSObject

@property (nonatomic, strong) NSString *endpoint;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *overview;

- (instancetype) initWithEndpoint:(NSString *) endpoint
                            title:(NSString *) title
                         overview:(NSString *) overview;

@end
