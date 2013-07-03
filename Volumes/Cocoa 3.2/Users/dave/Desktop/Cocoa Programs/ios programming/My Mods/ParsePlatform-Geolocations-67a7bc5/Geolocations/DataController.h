//
//  DataController.h
//  Geolocations
//
//  Created by dave on 12/3/12.
//  Copyright (c) 2012 Parse, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <DropboxSDK/DropboxSDK.h>
#import "Parse/Parse.h"

DBRestClient *restClient;

@interface DataController : NSObject
@property(nonatomic,strong)NSMutableArray *objectsToUpload;
@property(nonatomic,strong)NSMutableArray *fileNameCache;
+(void)fetchData:(NSString*)string;
-(void)dumpData:(PFUser *)user;

@end
