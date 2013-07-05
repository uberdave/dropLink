//
//  CircleOverlay.h
//  Geolocations
//
//  Created by Héctor Ramos on 8/16/12.
//  Copyright (c) 2012 Parse, Inc. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface CircleOverlay : NSObject <MKOverlay>

@property (nonatomic, readonly) CLLocationDistance radius;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

- (id)initWithCoordinate:(CLLocationCoordinate2D)aCoordinate radius:(CLLocationDistance)aRadius;

@end
