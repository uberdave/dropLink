//
//  FileRefDownloader.m
//  dropLink
//
//  Created by dave on 12/17/12.
//  Copyright (c) 2012 Parse, Inc. All rights reserved.
//

#import "FileRefDownloader.h"

@implementation FileRefDownloader
@synthesize fileRefs;

-(void)startLoadingMetadata{
    [self.restClient loadMetadata:@"/"];
}

// dropbox methods
- (DBRestClient *) restClient {
    if ( ! restClient ) {
        restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        restClient.delegate = self;
        
        
    }
    return restClient;
}


@end
