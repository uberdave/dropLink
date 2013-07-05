//
//  DownloadCopyRefs.m
//  dropLink
//
//  Created by dave on 12/18/12.
//  Copyright (c) 2012 Parse, Inc. All rights reserved.
//

#import "DownloadCopyRefs.h"
#import "FileRefs.h"
#import "RecordUploader.h"
@implementation DownloadCopyRefs
@synthesize refArray;
NSString *fileRef;

- (DBRestClient *) restClient {
    if ( ! restClient ) {
        restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        restClient.delegate = self;
        
        
    }
    return restClient;
}


-(void)startDownload:(NSString *)fileRef{
    
   
       [[self restClient] createCopyRef:fileRef];
    
}
- (void)restClient:(DBRestClient*)client createdCopyRef:(NSString *)copyRef{
    
    NSDictionary *refDict = [NSDictionary dictionaryWithObject:copyRef
                                                        forKey:fileRef];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"copyRefDone" object:self
                                                         userInfo:refDict];
}


@end
