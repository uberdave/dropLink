//
//  fileRefDownloader.h
//  dropLink
//
//  Created by dave on 12/17/12.
//  Copyright (c) 2012 Parse, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <DropboxSDK/DropboxSDK.h>
DBRestClient *restClient;
@protocol fileRefDownloaderDelegate;

@interface fileRefDownloader : NSObject <DBRestClientDelegate>



@property (nonatomic,retain)NSString *dropBoxUser;
@property (nonatomic,retain)NSString *dropBoxFileName;
@property (nonatomic, assign) id <fileRefDownloaderDelegate> delegate;
@end

//@protocol fileRefDownloaderDelegate;

//- (void)appImageDidLoad:(NSIndexPath *)indexPath;

//- (DBRestClient *) restClient;

//@end