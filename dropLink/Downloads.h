//
//  Downloads.h
//  Geolocations
//
//  Created by dave on 12/3/12.
//  Copyright (c) 2012 Parse, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <DropboxSDK/DropboxSDK.h>

DBRestClient *restClient;
@protocol DownloadsDelegate;
@interface Downloads : NSObject <DBRestClientDelegate>


@property (nonatomic,retain)NSString *dropBoxUser;
@property (nonatomic,retain)NSString *dropBoxFileName;
@property (nonatomic,retain)NSString *dropBoxCopyReference;
@property (nonatomic, retain) UIImage *dropBoxThumbnail;
@property (nonatomic, retain) NSString *imageURLString;
@property (nonatomic, retain) NSString *downloadedImagePath;
@property (nonatomic, assign) id <DownloadsDelegate> delegate;
//id <DownloadsDelegate> delegate;
@end
@protocol DownloadsDelegate

- (void)appImageDidLoad:(NSIndexPath *)indexPath;

- (DBRestClient *) restClient;

@end