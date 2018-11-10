//
//  AppDelegate.m
//  FSNetwork
//
//  Created by 付森 on 2018/10/22.
//  Copyright © 2018年 付森. All rights reserved.
//

#import "AppDelegate.h"
#import "FSMainVC.h"


@interface AppDelegate ()

@end

@implementation AppDelegate

void UncaughtExceptionHandler(NSException *exception)
{
    NSLog(@"捕捉到异常");
    
    AppDelegate *app = (id)[UIApplication sharedApplication].delegate;
    
    [app.loader invalidateAndCancel];
    
    NSLog(@"end: %@",[NSThread currentThread]);
    
    [NSThread sleepForTimeInterval:2];
    
    NSLog(@"real 崩溃了");
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    FSMainVC *controller = [[FSMainVC alloc] init];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
    
    self.window.rootViewController = nav;
    
    [self.window makeKeyAndVisible];
    
//    NSSetUncaughtExceptionHandler(&UncaughtExceptionHandler);
    
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


- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    NSLog(@"fs_applicationWillTerminate");
    
}

- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(nonnull NSString *)identifier completionHandler:(nonnull void (^)(void))completionHandler
{
    
}


@end
