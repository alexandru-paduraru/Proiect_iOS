
#import "EventsTableViewController.h"
#import "EventsTableViewCell.h"
#import "iOSAppDelegate.h"
#import "HomeUserProfileVC.h"
#import <QuartzCore/QuartzCore.h>


@interface EventsTableViewController ()

@end

@implementation EventsTableViewController{
    NSDateFormatter *dateFormatter;
    NSMutableDictionary *eventProfilePictures;
    PFUser *parent;
    
    UIImage *FBprofileCover;
    NSString *FBuserNameLabel;
    UIImage *FBprofileImage;
    HomeUserProfileVC *homeUserProfile;
    CGRect initial;
    
    UIImageView *_headerImage;
    float _headerImageYOffset;
}


- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom the table
        
        // The className to query on
        self.className = @"Event";
        
        // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"text";
        
        // Uncomment the following line to specify the key of a PFFile on the PFObject to display in the imageView of the default cell style
        // self.imageKey = @"image";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // The number of objects to show per page
        self.objectsPerPage = 4;
        
    }
    return self;
}

- (void)initProfileInfoFacebook:(NSDictionary *)profileInfo{
    FBprofileCover = [profileInfo objectForKey:@"cover"];
    FBprofileImage = [profileInfo objectForKey:@"profileImage"];
    FBuserNameLabel = [profileInfo objectForKey:@"name"];

    homeUserProfile = [[HomeUserProfileVC alloc] initWithNibName:@"HomeUserProfileVC" bundle:nil];
    [homeUserProfile initProfileInfoFacebook:profileInfo];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat scrollOffset = scrollView.contentOffset.y;
    CGRect headerImageFrame = _headerImage.frame;
    
    if (scrollOffset < 0) {
        // Adjust image proportionally
        headerImageFrame.origin.y = _headerImageYOffset - ((scrollOffset / 3));
    } else {
        // We're scrolling up, return to normal behavior
        headerImageFrame.origin.y = _headerImageYOffset - scrollOffset;
    }
    _headerImage.frame = headerImageFrame;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:Background]];
    
    self.view.backgroundColor = [UIColor clearColor];
    self.tableView.separatorColor = [UIColor clearColor];
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:EventDateFormat];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(locationDidChange:)
                                                 name:CLocationChangeNotification
                                               object:nil];
    
    
    self.tableView.tableHeaderView = homeUserProfile.view;
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    eventProfilePictures = [[NSMutableDictionary alloc] init];
    
    
}

- (void)locationDidChange:(NSNotification *)note {
    NSLog(@"location changed");
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:CLocationChangeNotification
                                                  object:nil];
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - PFQueryTableViewController

- (void)objectsWillLoad {
    [super objectsWillLoad];
    
    // This method is called before a PFQuery is fired to get more objects
}

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    NSLog(@"obiect primit:");
    
    // This method is called every time objects are loaded from Parse via the PFQuery
}

- (PFQuery *)queryForTable {
    
    //         NSPredicate *predicate = [NSPredicate predicateWithFormat:
    //                                  @"createdBy = %@",[PFUser currentUser]];
    //         PFQuery *query = [PFQuery queryWithClassName:self.className predicate:predicate];
    PFQuery *query = [PFQuery queryWithClassName:self.className];
    
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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    
    static NSString *CellIdentifier = @"Cell";
    
        EventsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"EventsTableViewCell" owner:self options:nil];
            cell = (EventsTableViewCell*)[topLevelObjects objectAtIndex:0];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if([object objectForKey:kEventLocationNameKey]){
            NSString *eventNameAtEventLocation = [[[NSString alloc] initWithFormat:@"%@ @ %@",[object objectForKey:kEventNameKey],[object objectForKey:kEventLocationNameKey]] uppercaseString];
            cell.nameLabel.text = eventNameAtEventLocation;
        } else {
            cell.nameLabel.text = [object objectForKey:kEventNameKey];
        }
        cell.dateLabel.text = [[dateFormatter stringFromDate:[object objectForKey:kEventDateKey]] uppercaseString];
        NSLog(@"created by:%@",[object objectForKey:kEventParentKey]);
        
        parent = [object objectForKey:kEventParentKey];
        [parent fetchInBackgroundWithBlock:^(PFObject *utilizator, NSError *error) {
            if (!error) {
                PFFile *theImage = [utilizator objectForKey:kUserProfilePictureKey];
                cell.createdBy.text = [utilizator objectForKey:kUserNameKey];
                [theImage getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                    UIImage *image = [UIImage imageWithData:data];
                    NSLog(@"background dl image for event");
                    cell.eventProfilePicture.image = image;
                    cell.eventProfilePicture.layer.masksToBounds = YES;
                    cell.eventProfilePicture.layer.cornerRadius = image.size.width/2;
                    //                    cell.eventProfilePicture.layer.borderWidth = 2.0;
                    //                    cell.eventProfilePicture.layer.borderColor = [UIColor whiteColor].CGColor;
                }];
            } else {
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }

        }];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 265;
}


/*
 // Override if you need to change the ordering of objects in the table.
 - (PFObject *)objectAtIndex:(NSIndexPath *)indexPath {
 return [self.objects objectAtIndex:indexPath.row];
 }
 */


// Override to customize the look of the cell that allows the user to load the next page of objects.
// The default implementation is a UITableViewCellStyleDefault cell with simple labels.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForNextPageAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"NextPage";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = @"Load more events...";

    return cell;
}

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

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}

@end
