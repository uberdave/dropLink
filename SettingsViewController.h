//
//  SettingsViewController.h
//  Geolocations
//
//  Created by dave on 11/27/12.
//  Copyright (c) 2012 Parse, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DropboxSDK/DropboxSDK.h>
#import <Parse/Parse.h>

DBRestClient *restClient;


@interface SettingsViewController : UITableViewController <PFLogInViewControllerDelegate,PFSignUpViewControllerDelegate>
@property(nonatomic,strong)NSMutableArray *fileNameCache;
@property(nonatomic,strong)NSMutableArray *objectsToUpload;
- (IBAction)buttonLogout:(id)sender;

- (IBAction)buttonLogClickIn:(id)sender;
- (IBAction)dropBoxUploadFile:(id)sender;
- (IBAction)buttonListDirectory:(id)sender;
- (IBAction)buttonDownloadFile:(id)sender;

@end