//
//  Uploader.m
//  dropLink
//
//  Created by dave on 12/22/12.
//  Copyright (c) 2012 Parse, Inc. All rights reserved.
//

#import "Uploader.h"
#import <UIKit/UIKit.h>

@implementation Uploader




-(void)uploadToParse:(NSMutableArray*)objects{
    NSString *myUserId = [[PFUser currentUser]username];
    int  numberOfObjects =[objects count];
    
    for (int x=0;x < numberOfObjects;x++) {
   
        
    FileRefs *fileRefs = [[FileRefs alloc]init];
    fileRefs.dbFileName=[[objects objectAtIndex:x]dbFileName];
    fileRefs.dbCopyRef=[[objects objectAtIndex:x]dbCopyRef];
    fileRefs.dbThumbnail=[[objects objectAtIndex:x]dbThumbnail];
    fileRefs.dbThumbnailName=[[objects objectAtIndex:x]dbThumbnailName];
        
    PFObject *object = [PFObject objectWithClassName:@"Downloads"];
        
    [object setObject:myUserId forKey:@"user"];
    [object setObject:fileRefs.dbFileName forKey:@"filename"];
    [object setObject:fileRefs.dbCopyRef forKey:@"copyref"];
    [object setObject:fileRefs.dbThumbnailName forKey:@"imageName"];
    [object setObject:fileRefs.dbThumbnail forKey:@"thumbnail"];
    [object saveEventually:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            
            NSLog(@"Successfully added object.");
         
        }
        else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}
}


@end