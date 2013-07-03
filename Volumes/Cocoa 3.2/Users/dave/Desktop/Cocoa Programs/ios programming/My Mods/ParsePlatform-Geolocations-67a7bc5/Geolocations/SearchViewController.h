//
//  SearchViewController.h
//  Geolocations
//
//  Created by Héctor Ramos on 8/16/12.
//  Copyright (c) 2012 Parse, Inc. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

//@interface SearchViewController : UIViewController <MKMapViewDelegate>


@interface SearchViewController : UIViewController <MKMapViewDelegate>
@property (nonatomic, strong) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) IBOutlet UISlider *slider;



- (void)setInitialLocation:(CLLocation *)aLocation;

@end
