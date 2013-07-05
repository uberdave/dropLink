//
//  DownloadsViewController.m
//  Geolocations
//
//  Created by dave on 11/29/12.
//  Copyright (c) 2012 Parse, Inc. All rights reserved.
//

#import "DownloadsViewController.h"

#import "Parse/Parse.h"
#import "FileRefs.h"

@interface DownloadsViewController ()

@end

@implementation DownloadsViewController



@synthesize detailItem = _detailItem;
@synthesize refsArray = _refsArray;

//NSString *dbFileName;
//NSMutableDictionary *_refsDictionary;



- (DBRestClient *) restClient {
    if ( ! restClient ) {
        restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        restClient.delegate = self;
        
    }
    return restClient;
}



- (id)initWithCoder:(NSCoder *)aCoder {
    self = [super initWithCoder:aCoder];
    if (self) {
        // Customize the table
        
        // The className to query on
        self.className = @"Downloads";
        
        // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"filename";
        
        // Uncomment the following line to specify the key of a PFFile on the PFObject to display in the imageView of the default cell style
        // self.imageKey = @"image";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // The number of objects to show per page
        self.objectsPerPage = 25;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.refsArray = [[NSMutableArray alloc]initWithCapacity:25];
    if (self.detailItem) {
       NSLog(@"username successfully set to %@",_detailItem);
        
        if (![[DBSession sharedSession] isLinked]) {
            
            [[DBSession sharedSession] linkFromController:self];
        }
        
        
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
     PFQuery *query = [PFQuery queryWithClassName:@"Downloads"];
     [query whereKey:@"user" equalTo:_detailItem];

 
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
 }

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     NSInteger path = indexPath.row;
 NSString   *copyRef = [[self.refsArray objectAtIndex:path]dbCopyRef];
    NSString *filePath =[[self.refsArray objectAtIndex:path]dbFilePath];
   NSLog(@"copyRef = %@",copyRef);
    NSLog(@"filepath = %@",filePath);
    
   [[self restClient]copyFromRef:copyRef toPath:filePath];
    
}
- (void)restClient:(DBRestClient*)client copiedRef:(NSString *)copyRef to:(DBMetadata *)to{
    NSLog(@"copied to%@",to);
}
- (void)restClient:(DBRestClient*)client copyFromRefFailedWithError:(NSError*)error{
     NSLog(@"failedcopy with error %@",error);
}
 /*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    // A date formatter for the creation date.
   
    
    PFTableViewCell *cell = (PFTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"DownloadCell"];
    
    // Configure the cell
    //PFObject *downloads = [object objectForKey:@"Downloads"];
    
	//cell.textLabel.text = Downloads.filename;
    
    //NSString *string = [NSString stringWithFormat:@"%@, %@",
	//					[numberFormatter stringFromNumber:[NSNumber numberWithDouble:geoPoint.latitude]],
	//					[numberFormatter stringFromNumber:[NSNumber numberWithDouble:geoPoint.longitude]]];
    
   // cell.detailTextLabel.text = string;
    
    return cell;
}
*/
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    static NSString *identifier = @"Cell";
    PFTableViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[PFTableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:identifier];
    }
    NSString *copyRef =  [object objectForKey:@"copyref"];
    
    NSInteger path = indexPath.row;
    //int refPath = path -1;
    NSLog(@"%i",path);
    FileRefs *fileRefs = [[FileRefs alloc]init];
    fileRefs.dbFilePath = [@"/" stringByAppendingString:[object objectForKey:@"filename"]];
    fileRefs.dbCopyRef =  copyRef;
    
   [self.refsArray insertObject:fileRefs atIndex:path];
    //NSLog(@"copyRef = %@",[_refsDictionary objectForKey:indexPath]);
    
    
    PFFile *thumbnail = [object objectForKey:@"thumbnail"];
 
    cell.imageView.file = thumbnail;
  
    
	cell.textLabel.text = [object objectForKey:@"filename"];
   
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)cancel:(id)sender
{
	[self.delegate downloadsViewControllerDidCancel:self];
}
- (IBAction)done:(id)sender
{
	[self.delegate downloadsViewControllerDidSave:self];
}

@end
