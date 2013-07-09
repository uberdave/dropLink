//
//  MasterViewController.m
//  Geolocations
//
//  Created by Héctor Ramos on 7/31/12.
//  Copyright (c) 2012 Parse, Inc. All rights reserved.
//

// PFQueryTableViewController UIStoryboard Template

#import "MasterViewController.h"
#import "DownloadsViewController.h"
#import "SearchViewController.h"
#import "Downloader.h"


#import "FileRefs.h"









@implementation MasterViewController
@synthesize locationManager = _locationManager;

NSNumber *kilometers;
CLLocation *location;
NSDictionary *theData;
FileRefs *fileRefs;
BOOL userBroadcasting = NO;


// dropbox methods
- (DBRestClient *) restClient {
    if ( ! restClient ) {
        restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        restClient.delegate = self;
        
    }
    return restClient;
}
- (void)sessionDidReceiveAuthorizationFailure:(DBSession *)session userId:(NSString *)userId{
    [[[UIAlertView alloc]
      initWithTitle:@"Account Unlinked!" message:@"Your dropbox account has been unlinked"
      delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]
     
     show];
    
}

//////////////////////need to make sure pfuser is logged in or will crash
-(void)searchViewNotifications:(NSNotification *)value{
    theData = [value userInfo];
    kilometers = [theData valueForKey:@"howFar"];
    location = [theData valueForKey:@"location"];
    [self queryForTable];
    //[self updateGeopoints];
    [self loadObjects];
    
}

#pragma mark - NSObject

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"geoPointAnnotiationUpdated" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"locationUpdated" object:nil];

}


#pragma mark - UIViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
  if ([PFUser currentUser]) {
    self.navigationItem.leftBarButtonItem.enabled = NO;
    self.navigationItem.rightBarButtonItem.enabled = NO;
  
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor blueColor]];
   
     //[self.navigationItem.rightBarButtonItem setTitle:@"Share"];
    if (![CLLocationManager locationServicesEnabled]) {
        
    }

    [[self locationManager] startUpdatingLocation];
    
    
    // Listen for annotation updates. Triggers a refresh whenever an annotation is dragged and dropped.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadObjects) name:@"geoPointAnnotiationUpdated" object:nil]; 
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchViewNotifications:) name:@"locationUpdated" object:nil];
   
   
     [self updateBarButtonColor];
    
    
    
       
    


NSLog(@"view did load----------------------------------------------------->>>>>>>");
   }
}
- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"view will appear----------------------------------------------------->>>>>>>");
   // [self loadObjects];
}
-(void)loginPFUser{
    }

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (![PFUser currentUser]) { // No user logged in
        // Create the log in view controller
        NSLog(@"Creating the log in view controller");
        PFLogInViewController *logInViewController = [[PFLogInViewController alloc] init];
        [logInViewController setDelegate:self]; // Set ourselves as the delegate
        
        // Create the sign up view controller
        PFSignUpViewController *signUpViewController = [[PFSignUpViewController alloc] init];
        [signUpViewController setDelegate:self]; // Set ourselves as the delegate
        
        // Assign our sign up controller to be displayed from the login controller
        [logInViewController setSignUpController:signUpViewController];
        
        
        
        
        //[self.container presentModalViewController:nc animated:YES];
        
        /* Present next run loop. Prevents "unbalanced VC display" warnings. */
       // double delayInSeconds = 0.1;
        //dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        // Present the log in view controller
        
        //  dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self.tabBarController presentViewController:logInViewController animated:YES completion:NULL];
        //});
        NSLog(@"view did appear----------------------------------------------------->>>>>>>");
        
        
    }


    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait || UIInterfaceOrientationIsLandscape(interfaceOrientation));
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  /* if ([[segue identifier] isEqualToString:@"showDownloads"]) {
        // Row selection
       NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
       PFObject *object = [self.objects objectAtIndex:indexPath.row];
       [[segue destinationViewController] setDetailItem:[object objectForKey:@"user"]];
    */
  if ([[segue identifier] isEqualToString:@"showDownloads"]){
      NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
      PFObject *object = [self.objects objectAtIndex:indexPath.row];
      
    UINavigationController *navigationController =
    segue.destinationViewController;
    DownloadsViewController
    *downloadsViewController =
    [[navigationController viewControllers]
     objectAtIndex:0];
    downloadsViewController.delegate = self;
  // [[segue destinationViewController] setDetailItem:[object objectForKey:@"user"]];
      [downloadsViewController setDetailItem:[object objectForKey:@"user"]];
    } else if ([[segue identifier] isEqualToString:@"showSearch"]) {
        // Search button
        [[segue destinationViewController] setInitialLocation:[self locationManager].location];
    }
}


#pragma mark - PFQueryTableViewController

- (void)objectsWillLoad {
    [super objectsWillLoad];
    
    // This method is called before a PFQuery is fired to get more objects
   
    
}

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    
    // This method is called every time objects are loaded from Parse via the PFQuery
}


 // Override to customize what kind of query to perform on the class. The default is to query for
 // all objects ordered by createdAt descending.
 - (PFQuery *)queryForTable {
     if ([PFUser currentUser]) {
      PFQuery *query = [PFQuery queryWithClassName:@"Location"];
     
     
     if (!location) {
         location = [self locationManager].location;
         
         
         kilometers  = [NSNumber numberWithDouble:1.0]   ;
     }
 
 NSLog(@"latitude = %f",location.coordinate.latitude);
 NSLog(@"longitude = %f",location.coordinate.longitude);
 NSLog(@"kilometers = %f",[kilometers doubleValue]);
 [query setLimit:25];
 [query whereKey:@"location"
 nearGeoPoint:[PFGeoPoint geoPointWithLatitude:location.coordinate.latitude
 longitude:location.coordinate.longitude]
 withinKilometers:[kilometers doubleValue]];

 // If Pull To Refresh is enabled, query against the network by default.
 if (self.pullToRefreshEnabled) {
 query.cachePolicy = kPFCachePolicyNetworkOnly;
 }
 
 // If no objects are loaded in memory, we look to the cache first to fill the table
 // and then subsequently do a query against the network.
 if (self.objects.count == 0) {
 query.cachePolicy = kPFCachePolicyCacheThenNetwork;
   
 }
 
 [query orderByDescending:@"createdAt"];


 return query;
   // [self loadObjects];
 }
     return nil;
 }

// Override to customize the look of a cell representing an object. The default is to display
// a UITableViewCellStyleDefault style cell with the label being the textKey in the object,
// and the imageView being the imageKey in the object.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    
    
    // A date formatter for the creation date.
    static NSDateFormatter *dateFormatter = nil;
	if (dateFormatter == nil) {
		dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
		[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
	}
    
	static NSNumberFormatter *numberFormatter = nil;
	if (numberFormatter == nil) {
		numberFormatter = [[NSNumberFormatter alloc] init];
		[numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
		[numberFormatter setMaximumFractionDigits:3];
	}

    PFTableViewCell *cell = (PFTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"LocationCell"];
    if ([PFUser currentUser]) {
    // Configure the cell
   // PFGeoPoint *geoPoint = [object objectForKey:@"location"];

    NSString *user = [object objectForKey:@"user"];
    
	cell.textLabel.text = user; //[dateFormatter stringFromDate:[object updatedAt]];
    
   // NSString *string = [NSString stringWithFormat:@"%@, %@",
	//					[numberFormatter stringFromNumber:[NSNumber numberWithDouble:geoPoint.latitude]],
	//					[numberFormatter stringFromNumber:[NSNumber numberWithDouble:geoPoint.longitude]]];
    
   // cell.detailTextLabel.text = string;
    }else{
        cell.textLabel.text = nil;
    }
    return cell;
}

/*
 // Override if you need to change the ordering of objects in the table.
 - (PFObject *)objectAtIndex:(NSIndexPath *)indexPath {
 return [self.objects objectAtIndex:indexPath.row];
 }
 */

/*
 // Override to customize the look of the cell that allows the user to load the next page of objects.
 // The default implementation is a UITableViewCellStyleDefault cell with simple labels.
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForNextPageAtIndexPath:(NSIndexPath *)indexPath {
 static NSString *CellIdentifier = @"NextPage";
 
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
 
 if (cell == nil) {
 cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
 }
 
 cell.selectionStyle = UITableViewCellSelectionStyleNone;
 cell.textLabel.text = @"Load more...";
 
 return cell;
 }
 */


#pragma mark - UITableViewDataSource

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the object from Parse and reload the table view
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, and save it to Parse
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


#pragma mark - CLLocationManagerDelegate

/**
 Conditionally enable the Search/Add buttons:
 If the location manager is generating updates, then enable the buttons;
 If the location manager is failing, then disable the buttons.
 */
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    self.navigationItem.leftBarButtonItem.enabled = YES;
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    NSLog(@"Location Manager Failed");
    self.navigationItem.leftBarButtonItem.enabled = NO;
    self.navigationItem.rightBarButtonItem.enabled = NO;
}


#pragma mark - MasterViewController

/**
 Return a location manager -- create one if necessary.
 */
- (CLLocationManager *)locationManager {
	
    if (_locationManager != nil) {
		return _locationManager;
	}
	
	_locationManager = [[CLLocationManager alloc] init];
	[_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
	[_locationManager setDelegate:self];
    [_locationManager setPurpose:@"Your current location is used to find other members nearby"];
	
	return _locationManager;
}
-(void)updateBarButtonColor{
    if ([PFUser currentUser]) {
    
    PFQuery *query = [PFQuery queryWithClassName:@"Location"];
    [query whereKey:@"user" equalTo:[[PFUser currentUser]username]];
    
    //If the user has a record here they are broadcasting-else they are hidden.
    [query countObjectsInBackgroundWithBlock:^(int count, NSError *error) {
        if (!error) {
            int userBroadcastStatus = count;
            if(userBroadcastStatus >= 1 ){
                [self.navigationItem.rightBarButtonItem setTintColor:[UIColor redColor]];
                userBroadcasting =YES;
        
            }
            else {
                [self.navigationItem.rightBarButtonItem setTintColor:[UIColor blueColor]];
                userBroadcasting =NO;
            }

            
        }
    }];
      
}
}
-(void)updateGeopoints{
    // If it's not possible to get a location, then return.
	CLLocation *location = _locationManager.location;
	if (!location) {
        NSLog(@"No Location!");
		return;
	}
    //self.navigationItem.rightBarButtonItem.enabled = NO;
    if (userBroadcasting) {
        //delete user location broadcast
        //using an array to make sure that no more than one record can be in the user location table
        NSMutableArray *allUserObjects = [NSMutableArray array];
        PFQuery *query = [PFQuery queryWithClassName:@"Location"];
        [query whereKey:@"user" equalTo:[[PFUser currentUser]username]];
        
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
                    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor blueColor]];
                    userBroadcasting= NO;
                }
            }else {
              
                [[[UIAlertView alloc] initWithTitle:@"Network Error"
                                            message:@"Sorry, A network error has occurred"
                                           delegate:nil
                                  cancelButtonTitle:@"ok"
                                  otherButtonTitles:nil] show];
            }
            }];
    }
    
    
    if (!userBroadcasting ) {
        
        
        
       
        // Configure the new event with information from the location and create a new record.
        CLLocationCoordinate2D coordinate = [location coordinate];
        NSString *myUserId = [[PFUser currentUser]username];
        PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLatitude:coordinate.latitude longitude:coordinate.longitude];
        PFObject *object = [PFObject objectWithClassName:@"Location"];
        [object setObject:geoPoint forKey:@"location"];
        [object setObject:myUserId forKey:@"user"];
         NSError *error = nil;
        if([object save:&error]) {
                 
                // Reload the PFQueryTableViewController
                [self loadObjects];
                //[self.tableView reloadData];
                NSLog(@"Successfully added location object.");
              //add the user to the broadcast pool
                userBroadcasting= YES;
               [self.navigationItem.rightBarButtonItem setTintColor:[UIColor redColor]];
            }
            else {
                // Log details of the failure
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }
    
}

-(void)callbackWithResult:(NSNumber *)result error:(NSError *)error{
    if(result){
        NSLog(@"Location Object deleted");
    }
    else{
        NSLog(@"%@",error);
        return;
    }
    
}
- (IBAction)insertCurrentLocation:(id)sender {
  
	[self updateGeopoints];
    // [self loadObjects];
        //[self.tableView reloadData];
    //[self.tableView setNeedsDisplay];

}
#pragma mark -PFUSER Login Delegate Methods

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
    
    
    [self dismissViewControllerAnimated:YES completion:^{[self loadObjects];
        self.navigationItem.leftBarButtonItem.enabled = NO;
        self.navigationItem.rightBarButtonItem.enabled = NO;
        
        [self.navigationItem.leftBarButtonItem setTintColor:[UIColor blueColor]];
        
        //[self.navigationItem.rightBarButtonItem setTitle:@"Share"];
        if (![CLLocationManager locationServicesEnabled]) {
            
        }
        
        [[self locationManager] startUpdatingLocation];
        
        
        // Listen for annotation updates. Triggers a refresh whenever an annotation is dragged and dropped.
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadObjects) name:@"geoPointAnnotiationUpdated" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchViewNotifications:) name:@"locationUpdated" object:nil];
        
        
        [self updateBarButtonColor];
        
        if (![[DBSession sharedSession] isLinked]) {
            /* Present next run loop. Prevents "unbalanced VC display" warnings. */
            double delayInSeconds = 0.1;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [[DBSession sharedSession] linkFromController:self];
            });
            
        }
        
    }];
    
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



#pragma mark - DownloadsViewControllerDelegate

- (void)downloadsViewControllerDidCancel:
(DownloadsViewController *)controller
{
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)downloadsViewControllerDidSave:
(DownloadsViewController *)controller
{
	[self dismissViewControllerAnimated:YES completion:nil];
}


@end