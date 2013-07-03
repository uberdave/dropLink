//
//  AppDelegate.m
//  Geolocations
//
//  Created by Héctor Ramos on 7/31/12.
//  Copyright (c) 2012 Parse, Inc. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "MasterViewController.h"
#import <DropboxSDK/DropboxSDK.h>

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    if ([[DBSession sharedSession] handleOpenURL:url]) {
        if ([[DBSession sharedSession] isLinked]) {
            NSLog(@"App linked successfully!");
            // At this point you can start making API calls
        }
        return YES;
    }
    // Add whatever other url handling code your app requires here
    return NO;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // ****************************************************************************
    // Parse initialization
     [Parse setApplicationId:@"Ph2mzUPkUDxP3RJKIr1BdfnJwMOjDpuc0hxvcEGu" clientKey:@"AyenOoH4A5fCj4ll6vO0iQ8aflyauVtLwTNVg9Z6"];
    // ****************************************************************************
    
    DBSession* dbSession =
    [[DBSession alloc]
      initWithAppKey:@"90fhsfsbq7xiumy"
      appSecret:@"k39gsovzgzulhmm"
      root:kDBRootAppFolder] // either kDBRootAppFolder or kDBRootDropbox
     ;
    [DBSession setSharedSession:dbSession];
    
    // Override point for customization after application launch.
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    // Stop updating locations while in the background.
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    MasterViewController *masterViewController = [storyboard instantiateViewControllerWithIdentifier:@"MasterViewController"];
    [masterViewController.locationManager stopUpdatingLocation];
    //Remove user data
    
    
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

    // Start updating locations when the app returns to the foreground.
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    MasterViewController *masterViewController = [storyboard instantiateViewControllerWithIdentifier:@"MasterViewController"];
    [masterViewController.locationManager startUpdatingLocation];
}

@end
