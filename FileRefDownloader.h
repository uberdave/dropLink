//
//  FileRefDownloader.h
//  dropLink
//
//  Created by dave on 12/17/12.
//  Copyright (c) 2012 Parse, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <DropboxSDK/DropboxSDK.h>
#import "Parse/Parse.h"
#import "AppDelegate.h"


DBRestClient *restClient;
@class FileRefDownloader;
@interface FileRefDownloader : NSObject <DBRestClientDelegate>
@property (nonatomic,retain)NSString *dropBoxUser;
@property (nonatomic,retain)NSString *dropBoxFileName;

@property   (nonatomic,retain)NSMutableArray *fileRefs;
-(void)startLoadingMetadata;

@end

