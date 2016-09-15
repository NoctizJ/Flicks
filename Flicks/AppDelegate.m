//
//  AppDelegate.m
//  Flicks
//
//  Created by Yuning Jin on 9/13/16.
//  Copyright © 2016 Yuning Jin. All rights reserved.
//

#import "AppDelegate.h"
#import "MovieViewController.h"

//static CGFloat iconSize = 22;

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *nowPlayingNavigationController = [storyboard instantiateViewControllerWithIdentifier:@"MoviesNavigationController"];
    MovieViewController *NowPlayingVC = (MovieViewController *)[nowPlayingNavigationController topViewController];
    NowPlayingVC.endpoint = @"now_playing";
    nowPlayingNavigationController.tabBarItem.image = [UIImage imageNamed:@"nowPlayingIcon"];
    nowPlayingNavigationController.tabBarItem.title = @"Now Playing";
    
    UINavigationController *topRatedNavigationController = [storyboard instantiateViewControllerWithIdentifier:@"MoviesNavigationController"];
    MovieViewController *topRatedVC = (MovieViewController *)[topRatedNavigationController topViewController];
    topRatedVC.endpoint = @"top_rated";
    topRatedNavigationController.tabBarItem.image = [UIImage imageNamed:@"topRatedIcon"];
    topRatedNavigationController.tabBarItem.title = @"Top Rated";
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    tabBarController.viewControllers = @[nowPlayingNavigationController, topRatedNavigationController];
    
    self.window.rootViewController = tabBarController;
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
