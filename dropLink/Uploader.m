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

-(void)deleteUserDownloads{
    
    //deletes all users as parse requires 1 api call per delete or add
    PFQuery *query = [PFQuery queryWithClassName:@"Downloads"];
    
    [query whereKey:@"user" equalTo:[[PFUser currentUser]username]];
    
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (!error) {
            int count;
            int i;
        
            count =[objects count];
            for (i=0; i < count; i++){
              
              
                
              PFObject *oldObject  = [query getFirstObject];
                NSLog(@"Object id %@",[oldObject objectId]);
               oldObject = [PFObject objectWithoutDataWithClassName:@"Downloads"
                                                                  objectId:[oldObject objectId]];
                            
            [oldObject delete];
            
        }
        }
        else {
            
            //print error
             NSLog(@"error");
            
        }
    
     }];
    
}




-(void)uploadToParse:(NSMutableArray*)objects{
    [self deleteUserDownloads];
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
