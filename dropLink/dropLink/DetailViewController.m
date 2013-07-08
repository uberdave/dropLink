//
//  DetailViewController.m
//  Geolocations
//
//  Created by Héctor Ramos on 7/31/12.
//  Copyright (c) 2012 Parse, Inc. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <Parse/Parse.h>

#import "DetailViewController.h"
#import "GeoPointAnnotation.h"

@implementation DetailViewController
@synthesize detailItem = _detailItem;
@synthesize mapView = _mapView;

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.detailItem) {
        // obtain the geopoint
        PFGeoPoint *geoPoint = [self.detailItem objectForKey:@"location"];
        
        // center our map view around this geopoint
        [self.mapView setRegion:MKCoordinateRegionMake(CLLocationCoordinate2DMake(geoPoint.latitude, geoPoint.longitude), MKCoordinateSpanMake(0.01, 0.01))];
        
        // add the annotation
        GeoPointAnnotation *annotation = [[GeoPointAnnotation alloc] initWithObject:self.detailItem];
        [self.mapView addAnnotation:annotation];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    static NSString *GeoPointAnnotationIdentifier = @"RedPin";

    MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:GeoPointAnnotationIdentifier];
    
    if (!annotationView) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:GeoPointAnnotationIdentifier];
        annotationView.pinColor = MKPinAnnotationColorRed;
        annotationView.canShowCallout = YES;
        annotationView.draggable = YES;
        annotationView.animatesDrop = YES;
    }
    
    return annotationView;
}

@end
