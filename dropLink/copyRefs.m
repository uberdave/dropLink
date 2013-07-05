//
//  copyRefs.m
//  dropLink
//
//  Created by dave on 12/18/12.
//  Copyright (c) 2012 Parse, Inc. All rights reserved.
//

#import "copyRefs.h"

@implementation copyRefs
@synthesize refArray;

- (DBRestClient *) restClient {
    if ( ! restClient ) {
        restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        restClient.delegate = self;
        
        
    }
    return restClient;
}


-(void)downloadCopyRefs:(NSNotification *)notification{
   //(DBMetadata *file in metadata.contents)
    
//    for (fileRefs in refArray ){
    
    [[self restClient] createCopyRef:nil];
}
//}
@end
