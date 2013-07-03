//
//  RecordUploader.h
//  dropLink
//
//  Created by dave on 12/18/12.
//  Copyright (c) 2012 Parse, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DownloadCopyRefs.h"

@interface RecordUploader : NSObject
@property (nonatomic,retain)NSMutableArray *refArray;
-(void)startCopyRefDownload;
-(void)buildUploadRecord;
-(void)assembleCopyRefs:(NSNotification *)notification;
@end
