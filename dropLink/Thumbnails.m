//
//  Thumbnails.m
//  dropLink
//
//  Created by dave on 12/16/12.
//  Copyright (c) 2012 Parse, Inc. All rights reserved.
//

#import "Thumbnails.h"


@implementation Thumbnails
@synthesize dropBoxThumbnail;

- (DBRestClient *) restClient {
    if ( ! restClient ) {
        restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        restClient.delegate = self;
        
        
    }
    return restClient;
}




@end
