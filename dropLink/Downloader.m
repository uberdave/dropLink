//
//  Downloader.m
//  dropLink
//
//  Created by dave on 12/19/12.
//  Copyright (c) 2012 Parse, Inc. All rights reserved.
//

#import "Downloader.h"
#import "FileRefs.h"
#import <DropboxSDK/DropboxSDK.h>




@implementation Downloader
@synthesize delegate;
@synthesize fileRefsArray;
FileRefs *fileRefs;
static int refIndex = 0;
NSString *copyRef;

-(void)startDownload{
   
    
    [self startLoadingMetadata];
    
    

}
- (void)processComplete
{
    [[self delegate] downloadCompleted:YES];
}


#pragma mark -DropBox

- (DBRestClient *) restClient {
    
   
    if ( ! restClient ) {
        
        restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        restClient.delegate = self;
        
       
        }
    return restClient;
}


-(void) startLoadingMetadata {
    
    
    // show in the status bar that network activity is starting
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
    NSString *documentsDirectory = [paths objectAtIndex:0]; 
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"data.plist"]; 
    NSMutableDictionary *savedCursor = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
    NSString *cursor;
    
    //load from savedCursor
    
    cursor = [savedCursor objectForKey:@"cursor"] ;
    
    if (!cursor) {
        cursor=@"";
    }
  NSLog(@"cursor from data.plist = %@",cursor);
[[self restClient] loadDelta:cursor];
    
    
}



- (void)restClient:(DBRestClient*)client loadedDeltaEntries:(NSArray *)entries reset:(BOOL)shouldReset cursor:(NSString *)cursor hasMore:(BOOL)hasMore{
    
    
    
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
    NSString *documentsDirectory = [paths objectAtIndex:0]; 
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"data.plist"]; 
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath: path]) 
    {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"plist"]; 
        
        [fileManager copyItemAtPath:bundle toPath: path error:&error]; 
    }
    if (![[data objectForKey:@"cursor"]isEqual:cursor]) {
        NSLog(@"cursors are not equal");
        [data setObject: cursor forKey:@"cursor"];
        [data writeToFile: path atomically:YES];
        [[self restClient] loadMetadata:@"/"];
        
    }else{
         NSLog(@"cursors are equal");
         [self processComplete];
    }
     NSLog(@"cursor written = %@",[data objectForKey:@"cursor"]);
 
    NSLog(@"cursor recieved = %@",cursor);
   }

- (void)restClient:(DBRestClient*)client loadDeltaFailedWithError:(NSError *)error{
    NSLog(@"DELTA ERROR");
        
    }
  

    


- (void)restClient:(DBRestClient *)client loadedMetadata:(DBMetadata *)metadata {
    
    int x =0;
    if (metadata.isDirectory) {
        self.fileRefsArray = [[NSMutableArray alloc]init];
       NSLog(@"Folder '%@' contains:", metadata.path);
        
        for (DBMetadata *file in metadata.contents) {
            NSLog(@"\t%@", file.filename);
            NSString *dbFilePath = [@"/" stringByAppendingString:file.filename];
           fileRefs = [[FileRefs alloc]init];
            fileRefs.dbFileName = file.filename;
            fileRefs.dbFilePath =dbFilePath;
            
            
            //[dataDict setObject:fileRefs forKey:filePath];
            
            [self.fileRefsArray insertObject:fileRefs atIndex:x];
            
            
            x=x+1;
            
        }
        [self downloadCopyRef];
    }
}
- (void)restClient:(DBRestClient*)client loadMetadataFailedWithError:(NSError*)error{
     NSLog(@"Error loading metadata: %@", error);
}
-(void)downloadCopyRef{
    
   int refCount = [fileRefsArray count];
    
    if (refIndex < refCount ) {
        NSLog(@"refCount/////// = %d",refCount);
    [[self restClient] createCopyRef:[[self.fileRefsArray objectAtIndex:refIndex]dbFilePath]];
    NSLog(@"filepath = %@",[[self.fileRefsArray objectAtIndex:refIndex]dbFilePath]);
    }else{
    refIndex =0;
    [self downloadThumbnail];
    }
}

- (void)restClient:(DBRestClient*)client createdCopyRef:(NSString *)copyRef{
    
    fileRefs = [[FileRefs alloc]init];
    fileRefs.dbFileName = [[self.fileRefsArray objectAtIndex:refIndex]dbFileName];
    fileRefs.dbFilePath = [[self.fileRefsArray objectAtIndex:refIndex]dbFilePath];
    fileRefs.dbCopyRef =copyRef;
    [fileRefsArray replaceObjectAtIndex:refIndex withObject:fileRefs];
    
    NSLog(@"copyRef = %@", [[self.fileRefsArray objectAtIndex:refIndex]dbCopyRef]);
    refIndex = refIndex +1;
    [self downloadCopyRef];
    
}
- (void)restClient:(DBRestClient*)client createCopyRefFailedWithError:(NSError *)error{
    NSLog(@"error =%@",error);
}
-(void)downloadThumbnail{
    
    int refCount = [fileRefsArray count];
    
    if (refIndex < refCount ) {
    NSString *ext = [[[[self.fileRefsArray objectAtIndex:refIndex]dbFileName] pathExtension] uppercaseString];
    if ( [ext isEqualToString:@"PNG"] || [ext isEqualToString:@"JPG"] || [ext isEqualToString:@"JPEG"]) {

    [[self restClient] loadThumbnail:[[self.fileRefsArray objectAtIndex:refIndex]dbFilePath] ofSize:@"medium" intoPath:[NSTemporaryDirectory() stringByAppendingPathComponent:[[self.fileRefsArray objectAtIndex:refIndex]dbFileName]]];
    }else{
        [self imagePicker];
        
    }
        
    }else{
        Uploader *uploader = [[Uploader alloc]init];
        [uploader uploadToParse:fileRefsArray];
        [self processComplete];
    }
}
- (void)restClient:(DBRestClient*)client loadedThumbnail:(NSString*)destPath metadata:(DBMetadata*)metadata{
    UIImage *image = [UIImage imageWithContentsOfFile:destPath];
    
    NSData *imageData = UIImagePNGRepresentation(image);
    PFFile *imageFile = [PFFile fileWithName:[[self.fileRefsArray objectAtIndex:refIndex]dbFileName] data:imageData];
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        // Handle success or failure here ...
        if (succeeded) {
            
            
            fileRefs = [[FileRefs alloc]init];
            fileRefs.dbFileName = [[self.fileRefsArray objectAtIndex:refIndex]dbFileName];
            fileRefs.dbFilePath = [[self.fileRefsArray objectAtIndex:refIndex]dbFilePath];
            fileRefs.dbCopyRef = [[self.fileRefsArray objectAtIndex:refIndex]dbCopyRef];
            fileRefs.dbThumbnail = imageFile;
            fileRefs.dbThumbnailName=[[self.fileRefsArray objectAtIndex:refIndex]dbFileName];;
            [fileRefsArray replaceObjectAtIndex:refIndex withObject:fileRefs];
            
            refIndex = refIndex +1;
            NSLog(@"Added thumbnail=============================================");
            [self downloadThumbnail];
        }
    } progressBlock:^(int percentDone) {
        // Update your progress spinner here. percentDone will be between 0 and 100.
    }];

    
  
    
}
- (void)restClient:(DBRestClient*)client loadThumbnailFailedWithError:(NSError*)error{
    
}
- (void)cancelThumbnailLoad:(NSString*)path size:(NSString*)size{
    
}
-(void)imagePicker{
    UIImage *image = [UIImage imageNamed:@"bluedot.png"];
    NSData *imageData = UIImagePNGRepresentation(image);
    PFFile *imageFile = [PFFile fileWithName:@"bluedot.png" data:imageData];
    
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        // Handle success or failure here ...
        if (succeeded) {
            
       
        fileRefs = [[FileRefs alloc]init];
        fileRefs.dbFileName = [[self.fileRefsArray objectAtIndex:refIndex]dbFileName];
        fileRefs.dbFilePath = [[self.fileRefsArray objectAtIndex:refIndex]dbFilePath];
        fileRefs.dbCopyRef = [[self.fileRefsArray objectAtIndex:refIndex]dbCopyRef];
        fileRefs.dbThumbnail = imageFile; //[UIImage imageNamed:@"bulb_on_24.png"];
        fileRefs.dbThumbnailName = @"bluedot.png";
        [fileRefsArray replaceObjectAtIndex:refIndex withObject:fileRefs];
        NSLog(@"Added stock image =============================================");
        refIndex = refIndex +1;
        [self downloadThumbnail];
        }
    } progressBlock:^(int percentDone) {
        // Update your progress spinner here. percentDone will be between 0 and 100.
    }];
    
   
}

@end
