//
//  MasterViewController.h
//  Geolocations
//
//  Created by Héctor Ramos on 7/31/12.
//  Copyright (c) 2012 Parse, Inc. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <Parse/Parse.h>
#import "DownloadsViewController.h"
#import "SearchViewController.h"
#import <MapKit/MapKit.h>
#import <QuartzCore/QuartzCore.h>
#import <DropboxSDK/DropboxSDK.h>




DBRestClient *restClient;

NSMutableArray *fileRefsDownload;

@interface MasterViewController : PFQueryTableViewController <CLLocationManagerDelegate, DownloadsViewControllerDelegate,  DBRestClientDelegate,PFLogInViewControllerDelegate,PFSignUpViewControllerDelegate>

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) NSMutableArray *fileRefsDownload;

- (IBAction)insertCurrentLocation:(id)sender;
-(void)updateGeopoints;
-(void)loginPFUser;
@end


