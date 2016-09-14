//
//  MovieService.m
//  Flicks
//
//  Created by Yuning Jin on 9/13/16.
//  Copyright © 2016 Yuning Jin. All rights reserved.
//

#import "MovieService.h"
#import "MovieData.h"

@interface MovieService () {
    NSMutableArray *_movieList;
}

@end

@implementation MovieService

- (instancetype)initWithEndpoint:(NSString *)endpoint
{
    self = [super init];
    
    if (self != nil)
    {
        _endpoint = endpoint;
        _movieList = [NSMutableArray array];
    }
    
    return self;
}

- (NSArray *) movies {
    return [_movieList copy];
}

- (void) getAssets:(NSString *)endpoint withCompletionHandler:(void (^)(void))completionHandler
{
    NSString *apiKey = @"bb016c41fa9429bde5c54bedc18b3b47";
    NSString *urlString = [NSString stringWithFormat:@"https://api.themoviedb.org/3/movie/%@?api_key=%@", endpoint, apiKey];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    NSURLSession *session =
    [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                  delegate:nil
                             delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                completionHandler:^(NSData * _Nullable data,
                                    NSURLResponse * _Nullable response,
                                    NSError * _Nullable error) {
        if (!error) {
            NSError *jsonError = nil;
            NSDictionary *responseDictionary =
            [NSJSONSerialization JSONObjectWithData:data
                                            options:kNilOptions
                                              error:&jsonError];
            
            for (NSDictionary *dict in responseDictionary[@"results"]) {
                MovieData *movie = [[MovieData alloc] initWithEndpoint:self.endpoint title:dict[@"title"] overview:dict[@"overview"]];
                [_movieList addObject:movie];
            }
            
            completionHandler();
            
            NSLog(@"Response: %@", responseDictionary);
        } else {
            NSLog(@"An error occurred: %@", error.description);
        }
    }];
    [task resume];

}

@end
