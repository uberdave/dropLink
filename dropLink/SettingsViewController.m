//
//  SettingsViewController.m
//  Geolocations
//
//  Created by dave on 11/27/12.
//  Copyright (c) 2012 Parse, Inc. All rights reserved.
//

#import "SettingsViewController.h"
#import "MasterViewController.h"
#import "Downloads.h"

NSString *dbFileName;
PFObject *dbDownloads;
Downloads *downloads;

@implementation SettingsViewController
@synthesize fileNameCache;
@synthesize objectsToUpload;


NSString *localPath;
UIImage *image;
NSString   *myRef;
int x =0;
int countThumbnails =0;

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.fileNameCache  = [[NSMutableArray alloc] init];
    self.objectsToUpload  = [[NSMutableArray alloc] init];
    if (![PFUser currentUser]) { // No user logged in
        // Create the log in view controller
        PFLogInViewController *logInViewController = [[PFLogInViewController alloc] init];
        [logInViewController setDelegate:self]; // Set ourselves as the delegate
        
        // Create the sign up view controller
        PFSignUpViewController *signUpViewController = [[PFSignUpViewController alloc] init];
        [signUpViewController setDelegate:self]; // Set ourselves as the delegate
        
        // Assign our sign up controller to be displayed from the login controller
        [logInViewController setSignUpController:signUpViewController];
        
        // Present the log in view controller
        [self presentViewController:logInViewController animated:YES completion:NULL];
       
    }
}

// Sent to the delegate to determine whether the log in request should be submitted to the server.
- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password {
    // Check if both fields are completed
    if (username && password && username.length != 0 && password.length != 0) {
        return YES; // Begin login process
    }
    
    [[[UIAlertView alloc] initWithTitle:@"Missing Information"
                                message:@"Make sure you fill out all of the information!"
                               delegate:nil
                      cancelButtonTitle:@"ok"
                      otherButtonTitles:nil] show];
    return NO; // Interrupt login process
}
// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:NULL];
}
// Sent to the delegate to determine whether the sign up request should be submitted to the server.
- (BOOL)signUpViewController:(PFSignUpViewController *)signUpController shouldBeginSignUp:(NSDictionary *)info {
    BOOL informationComplete = YES;
    
    // loop through all of the submitted data
    for (id key in info) {
        NSString *field = [info objectForKey:key];
        if (!field || field.length == 0) { // check completion
            informationComplete = NO;
            break;
        }
    }
    
    // Display an alert if a field wasn't completed
    if (!informationComplete) {
        [[[UIAlertView alloc] initWithTitle:@"Missing Information"
                                    message:@"Make sure you fill out all of the information!"
                                   delegate:nil
                          cancelButtonTitle:@"ok"
                          otherButtonTitles:nil] show];
    }
    
    return informationComplete;
}
// Sent to the delegate when a PFUser is signed up.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    [self dismissModalViewControllerAnimated:YES]; // Dismiss the PFSignUpViewController
}

// Sent to the delegate when the sign up attempt fails.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didFailToSignUpWithError:(NSError *)error {
    NSLog(@"Failed to sign up...");
}

// Sent to the delegate when the sign up screen is dismissed.
- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController {
    NSLog(@"User dismissed the signUpViewController");
}



- (void)restClient:(DBRestClient*)client loadedFile:(NSString*)localPath {
    NSLog(@"File loaded into path: %@", localPath);
}

- (void)restClient:(DBRestClient*)client loadFileFailedWithError:(NSError*)error {
    NSLog(@"There was an error loading the file - %@", error);
}



- (void)restClient:(DBRestClient *)client loadedMetadata:(DBMetadata *)metadata {
    x=0;
    if (metadata.isDirectory) {
        
        NSLog(@"Folder '%@' contains:", metadata.path);
        
        for (DBMetadata *file in metadata.contents) {
            //NSLog(@"\t%@", file.filename);
            myRef = [@"/" stringByAppendingString:file.filename];
            NSString *dbFileName = file.filename;
           
           
            //add filename to array here
            [self.fileNameCache insertObject:dbFileName atIndex:x];
            [[self restClient] createCopyRef:myRef];
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            localPath = [documentsDirectory stringByAppendingPathComponent:dbFileName];
            
            /////////////////////////////////////////////////////////////
          
            x = x+1;
            
            
        }
    }
    
    x=0;
    countThumbnails =0;
    
}

- (void)restClient:(DBRestClient*)client createdCopyRef:(NSString *)copyRef{
    //add copyRef here and build object with username file and copyRef
    NSLog(@"%@",copyRef);
    
    NSString *currentFilename = [fileNameCache objectAtIndex:x];
    downloads = [[Downloads alloc]init];
    downloads.dropBoxFileName = currentFilename;
    downloads.dropBoxUser = [[PFUser currentUser]username];
    downloads.dropBoxCopyReference = copyRef;
    
    [self.objectsToUpload insertObject:downloads atIndex:x];
    
    
        
    //the only time we create a copyref is in loadedMetaData which sets x back to zero.
    x=x+1;
    [[self restClient] loadThumbnail:myRef ofSize:@"s" intoPath:localPath];
    
}
- (void)restClient:(DBRestClient*)client loadedThumbnail:(NSString*)destPath metadata:(DBMetadata*)metadata{
    NSLog(@"LOADED THUMBNAIL AT COUNTER %i",countThumbnails);
    //downloads.downloadedImagePath = localPath;
    //downloads.imageURLString= myRef;
    UIImage *image = [UIImage imageWithContentsOfFile:destPath];
    downloads.dropBoxThumbnail = image;
    [[self.objectsToUpload objectAtIndex:countThumbnails ]dropBoxThumbnail];
    countThumbnails = countThumbnails +1;
    
}
- (void)restClient:(DBRestClient*)client loadThumbnailFailedWithError:(NSError*)error{
    NSLog(@"LOAD FAILED FOR THUMBNAIL AT COUNTER %i",countThumbnails);
    UIImage *image = [UIImage imageNamed:@"blueButton.png"];
    downloads.dropBoxThumbnail = image;
    [[self.objectsToUpload objectAtIndex:countThumbnails ]dropBoxThumbnail];
    countThumbnails = countThumbnails +1;
    
}


- (void)restClient:(DBRestClient *)client
loadMetadataFailedWithError:(NSError *)error {
    
    NSLog(@"Error loading metadata: %@", error);
}


- (DBRestClient *)restClient {
    if (!restClient) {
        
        restClient =
        [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        restClient.delegate = (id)self;
    
    }
    return restClient;
}
- (IBAction)buttonListDirectory:(id)sender {
    //DataController *dataController = [[DataController alloc]init];
    //[dataController fetchData:@" " ];
    [[self restClient] loadMetadata:@"/"];
}

- (IBAction)buttonDownloadFile:(id)sender {
    NSString *path;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    path = [paths objectAtIndex:0];
   path = [path stringByAppendingPathComponent:@"SomeFileName"];
    
[[self restClient] loadFile:@"/Photo on 2011-06-15 at 12.25 #2.jpg" intoPath:path];
    
}

- (IBAction)buttonLogout:(id)sender {
    [PFUser logOut];
    
}

- (IBAction)hideUser:(id)sender {
    if(_hideSwitch.on){
        
        PFQuery *query = [PFQuery queryWithClassName:@"Location"];
        [query whereKey:@"user" equalTo:[[PFUser currentUser]username]];
        [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
         [object deleteInBackground];
 //MasterViewController  *masterViewController =    [[MasterViewController alloc]init];
           // [masterViewController loadObjects];
    }];
       
}
}





- (IBAction)buttonLogClickIn:(id)sender {
    
    if (![[DBSession sharedSession] isLinked]) {
        [[DBSession sharedSession] linkFromController:self];
    } else {
        [[DBSession sharedSession] unlinkAll];
        [[[UIAlertView alloc]
           initWithTitle:@"Account Unlinked!" message:@"Your dropbox account has been unlinked"
           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]
         show];
        //[self updateButtons];
    }

}

- (IBAction)dropBoxUploadFile:(id)sender {
    NSString *localPath = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
    NSString *filename = @"Info.plist";
    NSString *destDir = @"/";
    [[self restClient] uploadFile:filename toPath:destDir
                    withParentRev:nil fromPath:localPath];
    
    
}

   



- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

#pragma mark - Table view delegate

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
/*{
    // Navigation logic may go here. Create and push another view controller.
 
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
    
}
*/
- (void)viewDidUnload {
    
  
    [self setHideSwitch:nil];
    [super viewDidUnload];
}

@end
