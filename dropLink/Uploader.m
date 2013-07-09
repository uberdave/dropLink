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

-(void)deleteDownloadObject{
    
    NSMutableArray *allUserObjects = [NSMutableArray array];
    PFQuery *query = [PFQuery queryWithClassName:@"Downloads"];
    [query whereKey:@"user" equalTo:[[PFUser currentUser]username]];
    //get all of the user's records in the Downloads table
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // received the present objects in the table
            [allUserObjects addObjectsFromArray:objects];
             if (allUserObjects.count > 0) {
                 for (int i =0; i< allUserObjects.count  ; i++) {
                     
                 
                 PFObject *myObject = [allUserObjects objectAtIndex:i];
                 NSString  *myObjectId = [myObject objectId];
                
                 NSLog(@" object id is %@",myObjectId);
            [myObject deleteInBackgroundWithTarget:self selector:@selector(callbackWithResult:error:)];
                     
                 
                 }
                 }
                 }else {
                     // Log details of the failure
                     NSLog(@"Error: %@ %@", error, [error userInfo]);
                 }
                 }];
    
    
            }
    

-(void)callbackWithResult:(NSNumber *)result error:(NSError *)error{
    if(result){
        NSLog(@"Download Object deleted");
    }
    else{
        NSLog(@"%@",error);
    return;
    }
    
}


-(void)uploadToParse:(NSMutableArray*)objects{
    
    //clear the table on serverfor the new objects
   
        [self deleteDownloadObject];
    
    
    
    
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
