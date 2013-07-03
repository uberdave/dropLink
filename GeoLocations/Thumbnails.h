//
//  Thumbnails.h
//  dropLink
//
//  Created by dave on 12/16/12.
//  Copyright (c) 2012 Parse, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <DropboxSDK/DropboxSDK.h>
#import "SettingsViewController.h"
SettingsViewController *settingsViewController;
//DBRestClient *restClient;

@interface Thumbnails : NSObject
@property (nonatomic,retain)UIImage *dropBoxThumbnail;
@class SettingsViewController;
@protocol ThumbnailsDelegate

- (void)appImageDidLoad:(NSIndexPath *)indexPath;

- (DBRestClient *) restClient;


@end
