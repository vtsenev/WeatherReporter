//
//  AppDelegate.m
//  WeatherReporter
//
//  Created by Vladimir Tsenev on 6/8/12.
//  Copyright (c) 2012 MentorMate. All rights reserved.
//

#import "AppDelegate.h"
#import "WeatherTableViewController.h"
#import "ProfileViewController.h"
#import "LoginViewController.h"
#import "DataManager.h"

@implementation AppDelegate

@synthesize window = _window;

- (void)dealloc {
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    
    WeatherTableViewController *weatherTableViewController = [[WeatherTableViewController alloc] initWithStyle:UITableViewStylePlain];
    UINavigationController *weatherNavigationController = [[UINavigationController alloc] initWithRootViewController:weatherTableViewController];

    [weatherNavigationController setTitle:@"Weather"];
    
    UIViewController *profileViewController = [[ProfileViewController alloc] initWithNibName:@"ProfileViewController" bundle:nil];
    UINavigationController *profileNavigationController = [[UINavigationController alloc] initWithRootViewController:profileViewController];
    [profileViewController release];
    [profileNavigationController setTitle:@"Profile"];
    
    [tabBarController setViewControllers:[NSArray arrayWithObjects:weatherNavigationController, profileNavigationController, nil]];
    [weatherNavigationController release];
    [profileNavigationController release];
    
    [self.window setRootViewController:tabBarController];
    [tabBarController release];
    
    [self.window makeKeyAndVisible];
    
    LoginViewController *loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    loginViewController.delegate = weatherTableViewController;
    [weatherTableViewController release];
    
    UINavigationController *loginNavigationController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
    [loginViewController release];
    
    [self.window.rootViewController presentModalViewController:loginNavigationController animated:NO];
    [loginNavigationController release];
    
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[DataManager defaultDataManager] saveChanges];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[DataManager defaultDataManager] saveChanges];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

@end
