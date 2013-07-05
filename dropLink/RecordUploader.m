//
//  RecordUploader.m
//  dropLink
//
//  Created by dave on 12/18/12.
//  Copyright (c) 2012 Parse, Inc. All rights reserved.
//

#import "RecordUploader.h"
#import "FileRefs.h"
#import "DownloadCopyRefs.h"
#import "MasterViewController.h"


@implementation RecordUploader
@synthesize refArray;
int counter =0;
NSString *fileRef;


- (id)init {
    self = [super init];
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(startCopyRefDownload)
                                                     name:@"refArrayLoaded"
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(assembleCopyRefs:)
                                                     name:@"copyRefDone"
                                                   object:nil];

    }
    return self;
}

-(void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refArrayLoaded" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"copyRefDone" object:nil];
}

-(void)startCopyRefDownload{
    
    //self.refArray = [self.refArray initWithArray:masterViewController.fileRefsDownload];
    
    NSLog(@"ref array loaded--whoooo hooo!and has %d objects",[refArray count]);
    
    FileRefs *object =[refArray objectAtIndex:counter];
    fileRef = object.dbFilePath;
    DownloadCopyRefs *downloadCopyRefs =[[DownloadCopyRefs alloc]init];
    [downloadCopyRefs startDownload:fileRef];
    }

-(void)assembleCopyRefs:(NSNotification *)notification{
    NSDictionary *theData = [notification userInfo];
    if (theData != nil) {
        NSString *dbCopyRef = [theData objectForKey:fileRef];
        
        NSLog(@"sucessfully recovered copyRef: %@", dbCopyRef);
    } 
    counter = counter+1;
    if (counter == [refArray count]) {
        [self buildUploadRecord];
    }

}

-(void)buildUploadRecord{
    
}
@end
