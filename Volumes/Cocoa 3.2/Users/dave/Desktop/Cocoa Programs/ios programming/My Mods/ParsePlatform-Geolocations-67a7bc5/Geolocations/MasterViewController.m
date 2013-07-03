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
#import "SettingsViewController.h"



@implementation MasterViewController
@synthesize locationManager = _locationManager;
NSNumber *kilometers;
CLLocation *location;
NSDictionary *theData;


-(void)searchViewNotifications:(NSNotification *)value{
    theData = [value userInfo];
    kilometers = [theData valueForKey:@"howFar"];
    location = [theData valueForKey:@"location"];
    [self queryForTable];
    [self updateGeopoints];
    
}
    
#pragma mark - NSObject

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"geoPointAnnotiationUpdated" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"locationUpdated" object:nil];
}


#pragma mark - UIViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.navigationItem.leftBarButtonItem.enabled = NO;
    self.navigationItem.rightBarButtonItem.enabled = NO;

    if (![CLLocationManager locationServicesEnabled]) {
        
    }

    [[self locationManager] startUpdatingLocation];
    
    
    // Listen for annotation updates. Triggers a refresh whenever an annotation is dragged and dropped.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadObjects) name:@"geoPointAnnotiationUpdated" object:nil]; 
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchViewNotifications:) name:@"locationUpdated" object:nil];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
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
    
    // Configure the cell
   // PFGeoPoint *geoPoint = [object objectForKey:@"location"];
    NSString *user = [object objectForKey:@"user"];
    
	cell.textLabel.text = user; //[dateFormatter stringFromDate:[object updatedAt]];
    
   // NSString *string = [NSString stringWithFormat:@"%@, %@",
	//					[numberFormatter stringFromNumber:[NSNumber numberWithDouble:geoPoint.latitude]],
	//					[numberFormatter stringFromNumber:[NSNumber numberWithDouble:geoPoint.longitude]]];
    
   // cell.detailTextLabel.text = string;
    
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
    [_locationManager setPurpose:@"Your current location is used to demonstrate PFGeoPoint and Geo Queries."];
	
	return _locationManager;
}
-(void)updateGeopoints{
    // If it's not possible to get a location, then return.
	CLLocation *location = _locationManager.location;
	if (!location) {
		return;
	}
    
    PFQuery *query = [PFQuery queryWithClassName:@"Location"];
    [query whereKey:@"user" equalTo:[[PFUser currentUser]username]];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        
        if (object) {
            // The find succeeded.
            //Remove object- only one location per user
            //[object deleteInBackground];
            // Configure the new event and update  the location.
            CLLocationCoordinate2D coordinate = [location coordinate];
            
            PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLatitude:coordinate.latitude longitude:coordinate.longitude];
            
            [object setObject:geoPoint forKey:@"location"];
            
            [object saveEventually:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                
                    
                    // Reload the PFQueryTableViewController
                    [self loadObjects];
                    
                }
            }];
            
            NSLog(@"Successfully retrieved %@ object.", object);
        }
        if (!object) {
            
            // Configure the new event with information from the location and create a new record.
            CLLocationCoordinate2D coordinate = [location coordinate];
            NSString *myUserId = [[PFUser currentUser]username];
            PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLatitude:coordinate.latitude longitude:coordinate.longitude];
            PFObject *object = [PFObject objectWithClassName:@"Location"];
            [object setObject:geoPoint forKey:@"location"];
            [object setObject:myUserId forKey:@"user"];
            [object saveEventually:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    // Reload the PFQueryTableViewController
                    [self loadObjects];
                }
                else {
                    // Log details of the failure
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                }
                
            }];
            
        }
    }];
    
   


}

- (IBAction)insertCurrentLocation:(id)sender {
	[self updateGeopoints];
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