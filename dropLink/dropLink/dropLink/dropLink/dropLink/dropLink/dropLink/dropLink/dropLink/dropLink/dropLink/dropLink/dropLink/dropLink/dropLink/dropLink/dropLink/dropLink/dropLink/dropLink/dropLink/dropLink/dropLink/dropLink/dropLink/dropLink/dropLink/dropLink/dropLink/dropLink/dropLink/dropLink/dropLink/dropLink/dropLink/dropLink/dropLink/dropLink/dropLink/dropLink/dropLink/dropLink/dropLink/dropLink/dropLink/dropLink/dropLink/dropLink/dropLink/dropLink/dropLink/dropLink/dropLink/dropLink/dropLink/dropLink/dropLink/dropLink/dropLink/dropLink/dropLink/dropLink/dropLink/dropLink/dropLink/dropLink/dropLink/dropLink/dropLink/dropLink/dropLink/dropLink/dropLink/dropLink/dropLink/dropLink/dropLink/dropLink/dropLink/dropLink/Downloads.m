//
//  Downloads.m
//  Geolocations
//
//  Created by dave on 12/3/12.
//  Copyright (c) 2012 Parse, Inc. All rights reserved.
//

#import "Downloads.h"

@implementation Downloads
@synthesize dropBoxUser, dropBoxFileName,dropBoxCopyReference,dropBoxThumbnail,downloadedImagePath,imageURLString;
@synthesize delegate;


// dropbox methods
- (DBRestClient *) restClient {
    if ( ! restClient ) {
        restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        restClient.delegate = self;
        
        
    }
    return restClient;
}

@end
