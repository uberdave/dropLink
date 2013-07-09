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
 int count;

-(void)countUserDownloadObjects{
    PFQuery *query = [PFQuery queryWithClassName:@"Downloads"];
    [query whereKey:@"user" equalTo:[[PFUser currentUser]username]];

    NSError *error = nil;
    NSArray * objects;
    objects =[query findObjects:&error];
    {
        if (!error) {
           
            // int i;
            
            count =[objects count];
           
            
        }else{
            count = -1;
        
    }
}
}
-(void)deleteDownloadObject{
    
    NSMutableArray *allObjects = [NSMutableArray array];
    //NSUInteger limit = 0;
    //NSUInteger skip = 0;
    PFQuery *query = [PFQuery queryWithClassName:@"Downloads"];
    [query whereKey:@"user" equalTo:[[PFUser currentUser]username]];
    //[query setLimit: limit];
    //[query setSkip: skip];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded. Add the returned objects to allObjects
            [allObjects addObjectsFromArray:objects];
            //if (objects.count == limit) {
                // There might be more objects in the table. Update the skip value and execute the query again.
               // skip += limit;
                //[query setSkip: skip];
                //[query findObjects... // Execute the query until all objects have been returned. Keep adding the results to the allObjects mutable array.
                 }else {
                     // Log details of the failure
                     NSLog(@"Error: %@ %@", error, [error userInfo]);
                 }
                 }];
            }
    

-(void)callbackWithResult:(NSNumber *)result error:(NSError *)error{
    if(result){
        count=count-1;
        if (count > 0) {
            [self deleteDownloadObject];
        }else{
            NSLog(@"All objects deleted");
        }
       
    NSLog(@"Result of delete xxxxxxxxcv  s jneibefbibfub3fubu3hrb= %@",result);
    }
    else{
        NSLog(@"%@",error);
    return;
    }
    
}


-(void)uploadToParse:(NSMutableArray*)objects{
    
    //clear the table on serverfor the new object
   [self countUserDownloadObjects ];
    if (count >0) {
        [self deleteDownloadObject];
    }
    
    
    
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
