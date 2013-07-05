//
//  DownloadsViewController.h
//  Geolocations
//
//  Created by dave on 11/29/12.
//  Copyright (c) 2012 Parse, Inc. All rights reserved.
//

#import <Parse/Parse.h>
#import <DropboxSDK/DropboxSDK.h>
#import <UIKit/UIKit.h>
#import "FileRefs.h"



DBRestClient *restClient;


@class DownloadsViewController;
@protocol DownloadsViewControllerDelegate <NSObject>
- (void)downloadsViewControllerDidCancel:
(DownloadsViewController *)controller;
- (void)downloadsViewControllerDidSave:
(DownloadsViewController *)controller;
@end

@interface DownloadsViewController : PFQueryTableViewController <DBRestClientDelegate>
@property (nonatomic, weak) id <DownloadsViewControllerDelegate> delegate;
@property (nonatomic, strong) PFObject *detailItem;
@property (nonatomic, retain) NSMutableArray *refsArray;
- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;

@end
