//
//  AppDelegate.m
//  Geolocations
//
//  Created by Héctor Ramos on 7/31/12.
//  Copyright (c) 2012 Parse, Inc. All rights reserved.
//

#import "AppDelegate.h"
#import "Downloader.h"
#import <Parse/Parse.h>
#import "MasterViewController.h"
#import "SettingsViewController.h"
#import <DropboxSDK/DropboxSDK.h>



@implementation AppDelegate
@synthesize viewController;

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    if ([[DBSession sharedSession] handleOpenURL:url]) {
        if ([[DBSession sharedSession] isLinked]) {
            NSLog(@"App linked successfully!");
            // At this point you can start making API calls
            downloader = [[Downloader alloc] init];
            [downloader setDelegate:self];
            [downloader startDownload];
                    }
        return YES;
    }
    // Add whatever other url handling code your app requires here
    return NO;
}
//delegate method for Download Completed

- (void)downloadCompleted:(BOOL)success
{
    NSLog(@"Download Completed");
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // ****************************************************************************
    // Parse initialization
     [Parse setApplicationId:@"Your app key" clientKey:@"your client key"];
    // ****************************************************************************
    
    DBSession* dbSession =
    [[DBSession alloc]
      initWithAppKey:@"your app key"
      appSecret:@"your ap secret"
      root:kDBRootAppFolder] // either kDBRootAppFolder or kDBRootDropbox
     ;
    [DBSession setSharedSession:dbSession];
   
    
        //Start Dropbox downloads
     
    
    if ([[DBSession sharedSession] isLinked]) {
        
        
    
    
     downloader = [[Downloader alloc] init];
    [downloader setDelegate:self];
    [downloader startDownload];
   }
   
    
    
    // Override point for customization after application launch.
    
    
    return YES;
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    //Remove user data
   /* PFQuery *query = [PFQuery queryWithClassName:@"Location"];
    [query whereKey:@"user" equalTo:[[PFUser currentUser]username]];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        
        if (object) {
             NSLog(@" removing object");
            //Remove object- sharing is only enabled while the appis active
            [object deleteInBackground];
        }
        if (!object){
            NSLog(@"failed to remove object");
        }
    }];

    */
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    MasterViewController *masterViewController = [storyboard instantiateViewControllerWithIdentifier:@"MasterViewController"];
    
    // Stop updating locations while in the background.
    [masterViewController.locationManager stopUpdatingLocation];
    
  
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
   if ([PFUser currentUser]) {
   
    // Start updating locations when the app returns to the foreground.
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    MasterViewController *masterViewController = [storyboard instantiateViewControllerWithIdentifier:@"MasterViewController"];
    [masterViewController.locationManager startUpdatingLocation];
    NSLog(@"location updated");
    //*******************************************************************************
 
}
}
// Called when user has allowed this application via Dropbox website or Dropbox app


@end
