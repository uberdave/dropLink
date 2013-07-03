//
//  DownloadsViewController.h
//  Geolocations
//
//  Created by dave on 11/29/12.
//  Copyright (c) 2012 Parse, Inc. All rights reserved.
//

#import <Parse/Parse.h>
#import <DropboxSDK/DropboxSDK.h>
DBRestClient *restClient;
@class DownloadsViewController;

@protocol DownloadsViewControllerDelegate <NSObject>
- (void)downloadsViewControllerDidCancel:
(DownloadsViewController *)controller;
- (void)downloadsViewControllerDidSave:
(DownloadsViewController *)controller;
@end
@interface DownloadsViewController : PFQueryTableViewController
@property (nonatomic, strong) PFObject *detailItem;

@property (nonatomic, weak) id <DownloadsViewControllerDelegate> delegate;
//@property (nonatomic, strong) NSMutableArray *downloads;



- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;

@end
