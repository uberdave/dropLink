//
//  DataController.m
//  Geolocations
//
//  Created by dave on 12/3/12.
//  Copyright (c) 2012 Parse, Inc. All rights reserved.
//

#import "DataController.h"
#import "Downloads.h"

@implementation DataController
@synthesize objectsToUpload;
@synthesize fileNameCache;
int y =0;
Downloads *downloads;


- (void)fetchData:(NSString *)string{
if (string == nil) string = @"Default Value";
[[self restClient] loadMetadata:@"/"];
    
}
-(void)dumpData:(PFUser *)user{
    
}

- (DBRestClient *)restClient {
    if (!restClient) {
        restClient =
        [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        restClient.delegate = (id)self;
    }
    return restClient;
}
- (void)restClient:(DBRestClient *)client loadedMetadata:(DBMetadata *)metadata {
   y=0;
    if (metadata.isDirectory) {
     
        NSLog(@"Folder '%@' contains:", metadata.path);
        
        for (DBMetadata *file in metadata.contents) {
            //NSLog(@"\t%@", file.filename);
            NSString   *myRef = [@"/" stringByAppendingString:file.filename];
           NSString *dbFileName = file.filename;
           // downloads = [[Downloads alloc]init];
         
           [fileNameCache insertObject:dbFileName atIndex:y];
            //add filename to array here
            [[self restClient] createCopyRef:myRef];
           y = y+1;
            
            
        }
    }
    y=0;
}
- (void)restClient:(DBRestClient*)client createdCopyRef:(NSString *)copyRef{
    //add copyRef here and build object with username file and copyRef
    NSLog(@"%@",copyRef);
    
    NSString *currentFilename = [fileNameCache objectAtIndex:y];
    downloads = [[Downloads alloc]init];
    downloads.dropBoxFileName = currentFilename;
    downloads.dropBoxUser = [[PFUser currentUser]username];
    downloads.dropBoxCopyReference = copyRef;
    [objectsToUpload insertObject:downloads atIndex:y];
    
    //PFObject *dbDownloads = [PFObject objectWithClassName:@"Downloads"];
    //[dbDownloads setObject:[[PFUser currentUser]username] forKey:@"username"];
    
    //[dbDownloads setObject:dbFileName forKey:@"filename"];
    //[dbDownloads setObject:copyRef forKey:@"fileRef"];
    //[dbDownloads save];
    
    //the only time we create a copyref is in loadedMetaData which sets x back to zero.
    y=y+1;
    
}
@end