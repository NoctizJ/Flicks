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
@property (nonatomic, strong) NSString *poster;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *length;

- (instancetype) initWithEndpoint:(NSString *) endpoint
                            title:(NSString *) title
                         overview:(NSString *) overview
                           poster:(NSString *) poster
                             time:(NSString *)time;
@end
