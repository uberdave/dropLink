//
//  Uploader.h
//  dropLink
//
//  Created by dave on 12/22/12.
//  Copyright (c) 2012 Parse, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "FileRefs.h"


@interface Uploader : NSObject
-(void)uploadToParse:(NSMutableArray*)objects;


@end
