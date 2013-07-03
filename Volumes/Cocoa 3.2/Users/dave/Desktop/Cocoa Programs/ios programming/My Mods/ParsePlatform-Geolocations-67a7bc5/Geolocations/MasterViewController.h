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

@class MasterViewController;
@interface MasterViewController : PFQueryTableViewController <CLLocationManagerDelegate, DownloadsViewControllerDelegate>

@property (nonatomic, retain) CLLocationManager *locationManager;

- (IBAction)insertCurrentLocation:(id)sender;
-(void)updateGeopoints;
@end
