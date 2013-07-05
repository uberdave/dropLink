//
//  Downloader.h
//  dropLink
//
//  Created by dave on 12/19/12.
//  Copyright (c) 2012 Parse, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <DropboxSDK/DropboxSDK.h>
#import "MasterViewController.h"
#import "Uploader.h"

DBRestClient *restClient;

@protocol DownloadDataDelegate <NSObject>
@required
- (void) downloadCompleted: (BOOL)success;
@end

@interface Downloader : UITableViewController <DBRestClientDelegate>

@property (nonatomic, weak) id <DownloadDataDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *fileRefsArray;


-(void)startDownload;
-(void)downloadCopyRef;
-(void)downloadThumbnail;
-(void)imagePicker;
@end
