//
//  FileRefs.h
//  dropLink
//
//  Created by dave on 12/17/12.
//  Copyright (c) 2012 Parse, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface FileRefs : NSObject 

@property (nonatomic, retain) NSString *dbFileName;
@property (nonatomic,retain)NSString *dbFilePath;
@property (nonatomic,retain)NSString *dbCopyRef;
@property (nonatomic, retain) PFFile *dbThumbnail;
@property (nonatomic, retain)NSString *dbThumbnailName;
@property   (nonatomic,retain)NSMutableArray *fileRefsArray;


-(void)doSomething:(id)sender;

@end
