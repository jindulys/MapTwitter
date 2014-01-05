//
//  UWBEAppDelegate.m
//  mapTwitter
//
//  Created by Li Yansong on 13-12-28.
//  Copyright (c) 2013年 Liyansong. All rights reserved.
//

#import "UWBEAppDelegate.h"
#import "SearchHistoryVC.h"
#import "MTGoogleMapAPIKey.h"
#import <GoogleMaps/GoogleMaps.h>
#import "TwitterAPI.h"
#import "PersistentStack.h"

@implementation UWBEAppDelegate

+ (instancetype)sharedDelegate {
    return [UIApplication sharedApplication].delegate;
}

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self customizeAppearance];
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    CGRect bounds = [[UIScreen mainScreen] bounds];
    self.window = [[UIWindow alloc] initWithFrame:bounds];
    
    self.window.backgroundColor = [UIColor whiteColor];
    SearchHistoryVC *searchHVC = [[SearchHistoryVC alloc] init];
    UINavigationController *nv = [[UINavigationController alloc] initWithRootViewController:searchHVC];
    nv.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    self.window.rootViewController = nv;
    [self.window makeKeyAndVisible];
    
    [GMSServices provideAPIKey:KAPIKey];
    if (!_twitterAPI) {
        self.twitterAPI;
    }
    
    self.persistentStack = [[PersistentStack alloc] initWithStoreURL:self.storeURL modelURL:self.modelURL];
    
    return YES;
}

- (NSURL *)storeURL {
    NSURL *documentsDirectory = [[NSFileManager defaultManager] URLForDirectory:NSDocumentationDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:NULL];
    return [documentsDirectory URLByAppendingPathComponent:@"db.sqlite"];
}

- (NSURL *)modelURL {
    return [[NSBundle mainBundle] URLForResource:@"MTSearchTweets" withExtension:@"momd"];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [self.persistentStack.managedObjectContext save:NULL];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Custom Methods

- (void)customizeAppearance
{
    self.window.tintColor = [MTStyles newKidOnTheBlockBlue];
    [[UINavigationBar appearance] setBarTintColor:[MTStyles newKidOnTheBlockBlue]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:16.0]}];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

@synthesize twitterAPI = _twitterAPI;

- (TwitterAPI *)twitterAPI {
    if (_twitterAPI == nil) {
        _twitterAPI = [TwitterAPI Twitter];
    }
    return _twitterAPI;
}

@end
