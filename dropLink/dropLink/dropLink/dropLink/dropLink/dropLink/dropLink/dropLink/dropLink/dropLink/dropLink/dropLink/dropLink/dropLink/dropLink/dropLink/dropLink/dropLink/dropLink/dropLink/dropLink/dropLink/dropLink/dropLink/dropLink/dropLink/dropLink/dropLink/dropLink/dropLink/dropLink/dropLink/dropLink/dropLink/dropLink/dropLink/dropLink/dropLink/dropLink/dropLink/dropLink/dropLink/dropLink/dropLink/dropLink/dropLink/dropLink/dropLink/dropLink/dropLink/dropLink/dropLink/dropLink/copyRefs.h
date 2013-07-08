//
//  copyRefs.h
//  dropLink
//
//  Created by dave on 12/18/12.
//  Copyright (c) 2012 Parse, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <DropboxSDK/DropboxSDK.h>


DBRestClient *restClient;

@interface copyRefs : NSObject <DBRestClientDelegate>
@property (nonatomic,retain)NSMutableArray *refArray;
-(void)downloadCopyRefs:(NSNotification *)notification;

@end
