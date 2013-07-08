//
//  AppDelegate.h
//  Geolocations
//
//  Created by Héctor Ramos on 7/31/12.
//  Copyright (c) 2012 Parse, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Downloader.h"
#import <DropboxSDK/DropboxSDK.h>
#import <Parse/Parse.h>

DBRestClient *restClient;

@class AppDelegate;
Downloader *downloader;
@interface AppDelegate : UIResponder <UIApplicationDelegate, DownloadDataDelegate,PFLogInViewControllerDelegate,PFSignUpViewControllerDelegate>

@property (nonatomic, strong) UIWindow *window;
@property (strong, nonatomic) UIViewController *viewController;

@end
