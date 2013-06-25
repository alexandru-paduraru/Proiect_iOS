
#import "EventsTableVC.h"
#import "EventsTableViewCell.h"
#import "iOSAppDelegate.h"
#import "HomeUserProfileVC.h"
#import <QuartzCore/QuartzCore.h>
#import <Parse/Parse.h>
#import "EventDetailsViewController.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "UIScrollView+SVPullToRefresh.h"

@interface EventsTableVC()
@property NSMutableArray *events;

-(void)viewDidLoad;
-(void)initWithEvents:(NSArray*)aEvents;
-(void)initProfileInfoFacebook:(NSDictionary *)profileInfo;

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
-(UIView*)createCellFooter:(NSString *)status;
-(UILabel*)createMoreInfoHourLabel: (NSString *)hour;
-(UILabel*)createMoreInfoLabel:(NSString*)title;
-(UILabel*)createEventLabel:(int)xOffset Y:(int)yOffset labelName:(NSString*)labelName delay:(int)delay;

-(void)scrollViewDidScroll:(UIScrollView *)scrollView;


@end

@implementation EventsTableVC{
    NSDateFormatter *dateFormatter;
    NSMutableDictionary *eventProfilePictures;
    PFUser *parent;
    
    UIImage *FBprofileCover;
    NSString *FBuserNameLabel;
    UIImage *FBprofileImage;
    HomeUserProfileVC *homeUserProfile;
    CGRect initial;
    
    UIImageView *headerImage;
    float headerImageYOffset;

    NSArray *newEvents;
    
    UIBezierPath *headerMaskPath;
    NSURL *coverURL;
 //   NSData *backgroundData;
    NSMutableArray *eventDisplay;
    NSMutableArray *coverURLArray;
}


@synthesize myTableView;
@synthesize events;

- (void)initProfileInfoFacebook:(NSDictionary *)profileInfo{
    FBprofileCover = [profileInfo objectForKey:@"cover"];
    FBprofileImage = [profileInfo objectForKey:@"profileImage"];
    FBuserNameLabel = [profileInfo objectForKey:@"name"];
    
    homeUserProfile = [[HomeUserProfileVC alloc] initWithNibName:@"HomeUserProfileVC" bundle:nil];
    [homeUserProfile initProfileInfoFacebook:profileInfo];
}



- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - UIViewController

- (void)initWithEvents:(NSArray*)aEvents{
   // events = aEvents;
    events = [[NSMutableArray alloc] initWithCapacity:[aEvents count]];
    [events addObjectsFromArray:aEvents];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:Background]];
    eventDisplay = [[NSMutableArray alloc] initWithCapacity:[events count]];
    coverURLArray = [[NSMutableArray alloc] initWithCapacity:[events count]];
    
    // Create an empty table header view with small bottom border view
    UIView *tableHeaderView = [[UIView alloc] initWithFrame: CGRectMake(0.0, 0.0, self.view.frame.size.width, 150.0)];
    
    UIView *whiteBorderView = [[UIView alloc] initWithFrame: CGRectMake(0.0, 149.0, self.view.frame.size.width, 1.0)];
    whiteBorderView.backgroundColor = [UIColor colorWithRed:220.0 green:220.0 blue:220.0 alpha:1];
    UIView *blackBorderView = [[UIView alloc] initWithFrame: CGRectMake(0.0, 148.0, self.view.frame.size.width, 1.0)];
    blackBorderView.backgroundColor = [UIColor colorWithRed: 0.0 green: 0.0 blue: 0.0 alpha: 0.5];
    
    [tableHeaderView addSubview:homeUserProfile.view];
    [tableHeaderView addSubview: blackBorderView];
    [tableHeaderView addSubview: whiteBorderView];
    
    [tableHeaderView setBackgroundColor:[UIColor clearColor]];
    
    self.myTableView.tableHeaderView = tableHeaderView;
    
        // Create the underlying imageview and offset it
    headerImageYOffset = -50.0;
    
    headerImage = [[UIImageView alloc] initWithImage: FBprofileCover];
    CGRect headerImageFrame = headerImage.frame;
    headerImageFrame = CGRectMake(0, -50, headerImage.frame.size.width/1.5, headerImage.frame.size.height/1.5);
    //headerImageFrame.origin.y = _headerImageYOffset;
    headerImage.frame = headerImageFrame;
    
    headerMaskPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 320, headerImage.frame.size.height)];
    CAShapeLayer *maskLayer2 = [CAShapeLayer layer];
    maskLayer2.path = headerMaskPath.CGPath;
    
    // Set the newly created shape layer as the mask for the image view's layer
    headerImage.layer.mask = maskLayer2;
    //   imgView.layer.cornerRadius = 4.0;
    
    [headerImage.layer setContentsGravity:kCAGravityResizeAspectFill];
    headerImage.layer.masksToBounds = YES;
    [self.view insertSubview: headerImage belowSubview: self.myTableView];
    
    self.myTableView.backgroundColor = [UIColor clearColor];
    self.myTableView.separatorColor = [UIColor clearColor];
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:EventDateFormat];
    
    eventProfilePictures = [[NSMutableDictionary alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(locationDidChange:)
                                                 name:CLocationChangeNotification
                                               object:nil];
    
    self.myTableView.pullToRefreshView.arrowColor = [UIColor whiteColor];
    
    __weak typeof(self) weakSelf = self;
    [self.myTableView addPullToRefreshWithActionHandler:^{
        PFQuery *myEventsQuery = [PFQuery queryWithClassName:kParticipateClassKey];
        [myEventsQuery whereKey:kFriendInvited equalTo:[[PFUser currentUser] objectId]];
        [myEventsQuery orderByDescending:kCreatedAt];
        [myEventsQuery includeKey:kParticipateEventID];
        myEventsQuery.cachePolicy = kPFCachePolicyNetworkElseCache;
        [myEventsQuery findObjectsInBackgroundWithBlock:^(NSArray *myEvents, NSError *error) {
            if(!error){
                [weakSelf.events removeAllObjects];
                [weakSelf.events addObjectsFromArray:myEvents];
                [weakSelf.myTableView reloadData];
                [weakSelf.myTableView.pullToRefreshView stopAnimating];
            } else {
                NSLog(@"eroare la primirea evenimentelor userului curent");
            }
        }];
        
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat scrollOffset = scrollView.contentOffset.y;
    CGRect headerImageFrame = headerImage.frame;
    
    if (scrollOffset < 0) {
        // Adjust image proportionally
        headerImageFrame.origin.y = headerImageYOffset - ((scrollOffset / 3));
    } else {
        // We're scrolling up, return to normal behavior
        headerImageFrame.origin.y = headerImageYOffset - ((scrollOffset / 1.7));
        //headerImageFrame.origin.y = headerImageYOffset;
    }
    headerImage.frame = headerImageFrame;
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


- (UILabel*) createEventLabel:(int)xOffset Y:(int)yOffset labelName:(NSString*)labelName delay:(int)delay{
    UILabel *yourLabel = [[UILabel alloc] initWithFrame:CGRectMake(xOffset, yOffset, 170, 30)];
    
    [yourLabel setTextColor:[UIColor whiteColor]];
    [yourLabel setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]];
    
    [yourLabel setText:[labelName uppercaseString]];
    [yourLabel setFont:[UIFont fontWithName: @"Helvetica" size: 15.0f]];
    
    [UIView animateWithDuration:0.7 delay:delay options:UIViewAnimationOptionAllowAnimatedContent animations:^{
        yourLabel.frame = CGRectMake(10, yOffset, [yourLabel.text length]*10-10, 26);
    } completion:nil];
    
    return yourLabel;
}

- (UILabel*) createMoreInfoLabel:(NSString*)title{
    UILabel *readMoreView = [[UILabel alloc] initWithFrame:CGRectMake(420, 132, 90, 18)];
    [readMoreView setBackgroundColor:[UIColor colorWithRed:226/255.0 green:109/255.0 blue:93/255.0 alpha:1]];
    [readMoreView setText:[title uppercaseString]];
    
    [readMoreView setTextColor:[UIColor whiteColor]];
    [readMoreView setFont:[UIFont fontWithName: @"Helvetica" size: 12.0f]];
    
    [UIView animateWithDuration:0.7 delay:0.7 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
        readMoreView.frame = CGRectMake(255, 132, 90, 18);
        
    } completion:nil];
    
    return readMoreView;
}

- (UILabel*)createMoreInfoHourLabel: (NSString *)hour{
    UILabel *readMoreView = [[UILabel alloc] initWithFrame:CGRectMake(420, 118, 90, 18)];
    [readMoreView setBackgroundColor:[UIColor colorWithRed:226/255.0 green:109/255.0 blue:93/255.0 alpha:1]];
    [readMoreView setText:[hour uppercaseString]];
    
    [readMoreView setTextColor:[UIColor whiteColor]];
    [readMoreView setFont:[UIFont fontWithName: @"Helvetica" size: 14.0f]];
    
    [UIView animateWithDuration:0.7 delay:0.7 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
        readMoreView.frame = CGRectMake(255, 118, 90, 18);
    } completion:nil];
    
    return readMoreView;
}


- (UIView*)createCellFooter:(NSString *)status{
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(10, 159, 300, 30)];
    footer.backgroundColor = [UIColor whiteColor];
    footer.layer.shadowColor = [UIColor blackColor].CGColor;
    footer.layer.shadowOffset = CGSizeMake(0, 1);
    footer.layer.shadowOpacity = 0.1;
    
    footer.layer.borderColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.15].CGColor;
    footer.layer.borderWidth = 1.0f;
    footer.layer.shadowPath = [[UIBezierPath bezierPathWithRect:footer.bounds] CGPath
                               ];
    UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 100, 20)];
    [statusLabel setText:status];
    [statusLabel setTextColor:[UIColor grayColor]];
    [statusLabel setFont:[UIFont fontWithName: @"Helvetica" size: 16.0f]];

    [footer addSubview:statusLabel];

    return footer;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    NSDictionary *eventDetails;
    
    
    EventsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"EventsTableViewCell" owner:self options:nil];
        cell = (EventsTableViewCell*)[topLevelObjects objectAtIndex:0];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell.activityIndicator startAnimating];
    UIImageView *eventProfile = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 50, 50)];
    eventProfile.layer.masksToBounds = YES;
    eventProfile.layer.cornerRadius = 25;
    eventProfile.layer.borderWidth = 2.0;
    eventProfile.layer.borderColor = [UIColor whiteColor].CGColor;
    
    if([events[indexPath.row] objectForKey:@"eventProfilePicture"]){
        UIImage *eventProfilePicture = [UIImage imageWithData:[[events[indexPath.row] objectForKey: @"eventProfilePicture"] getData]];
        eventProfile.image = eventProfilePicture;
    } else {
       // eventProfile.image = [UIImage imageNamed:@"profilePicture2.png"];
    }
    [cell addSubview:eventProfile];
    
    
    eventDetails = [events[indexPath.row] objectForKey:@"eventID"];    
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 30, 300, 130)];
    imgView.backgroundColor = [UIColor whiteColor];
    
    imgView.layer.borderColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.15].CGColor;
    
    imgView.layer.borderWidth = 1.0;
    
    // Create the path (with only the top-left corner rounded)
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 300, 130)
                                                   byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerTopRight)
                                                         cornerRadii:CGSizeMake(5.0, 5.0)];

    CAShapeLayer *maskLayer2 = [CAShapeLayer layer];
    maskLayer2.frame = CGRectMake(0, 0, 300, 130);
    maskLayer2.path = maskPath.CGPath;
    imgView.layer.mask = maskLayer2;
   
    [imgView.layer setContentsGravity:kCAGravityResizeAspectFill];
    [imgView setAlpha:0.0];
    
    NSString *eventName = [NSString stringWithFormat:@" %@",[eventDetails objectForKey:kEventNameKey]];
    NSString *eventLocation = [NSString stringWithFormat:@" %@",[eventDetails objectForKey:kEventLocationNameKey]];
    
    [dateFormatter setDateFormat:@" dd MMM"];
   
    NSString *dateString2 = [dateFormatter stringFromDate:[eventDetails objectForKey:kEventDateKey]];
    [dateFormatter setDateFormat:@" HH:MM"];
    
    NSString *timeString = [dateFormatter stringFromDate:[eventDetails objectForKey:kEventDateKey]];
    
    UILabel *nameLabel = [self createEventLabel:-110 Y:90 labelName:eventName delay:.4];
    
    
    UILabel *eventLabel = [self createEventLabel:-210 Y:118 labelName:eventLocation delay:.7];
    
    
    UILabel *moreInfo = [self createMoreInfoLabel:dateString2];
    UILabel *moreInfoHour = [self createMoreInfoHourLabel:timeString];
    
    [cell insertSubview:moreInfoHour atIndex:10];
    [cell insertSubview:moreInfo atIndex:10];
    
    parent = [events[indexPath.row] objectForKey:kParticipateEventHost];
    [parent fetchInBackgroundWithBlock:^(PFObject *utilizator, NSError *error) {
        if (!error) {
            PFFile *theImage = [utilizator objectForKey:kUserProfilePictureKey];
            cell.createdBy.text = [utilizator objectForKey:kUserNameKey];
            [theImage getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                UIImage *image = [UIImage imageWithData:data];
                NSLog(@"background dl image for event");
                eventProfile.image = image;
               
                PFFile *profilePicture = [PFFile fileWithName:@"profilePicture.png" data:data];
                [events[indexPath.row] setObject:profilePicture forKey:@"eventProfilePicture"];
                if (!profilePicture) {
                    CATransition *transition = [CATransition animation];
                    transition.duration = 1.0f;
                    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                    transition.type = kCATransitionFade;
                    [eventProfile.layer addAnimation:transition forKey:nil];
                }
            }];
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
    if([eventDetails objectForKey:@"eventCoverURL"]){
    //    coverURL = [[NSURL alloc] initWithString:[eventDetails objectForKey:@"eventCoverURL"]];
        coverURLArray[indexPath.row] = [[NSURL alloc] initWithString:[eventDetails objectForKey:@"eventCoverURL"]];
    } else {
   //     coverURL = [[NSURL alloc] initWithString:@"http://www.wall321.com/thumbnails/detail/20120423/abstract%20blurred%202560x1440%20wallpaper_www.wallpaperto.com_70.jpg"];
        coverURLArray[indexPath.row] = [[NSURL alloc] initWithString:@"http://www.wall321.com/thumbnails/detail/20120423/abstract%20blurred%202560x1440%20wallpaper_www.wallpaperto.com_70.jpg"];
    }
    
    if(!imgView.image){
        // Configure the cell.
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            NSData *backgroundData = [NSData dataWithContentsOfURL:coverURLArray[indexPath.row]];
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                NSLog(@"adaug imaginea din info server");
                imgView.image = [UIImage imageWithData:backgroundData];
              //  [cell addSubview:imgView];
                [cell insertSubview:imgView atIndex:2];
                [UIView animateWithDuration:0.7 animations:^{
                    [imgView setAlpha:1.0];
                }];
                [cell.activityIndicator stopAnimating];
            });
        });
    }
//    else {
//        imgView.image = [UIImage imageWithData:backgroundData];
//        
//        [cell insertSubview:imgView atIndex:1];
//        
//        [UIView animateWithDuration:0.7 animations:^{
//            [imgView setAlpha:1.0];
//        }];
//        [cell.activityIndicator stopAnimating];
//
//    }
    [cell insertSubview:nameLabel atIndex:10];
    [cell insertSubview:eventLabel atIndex:10];
    UIView *footer = [self createCellFooter:@""];
    [cell insertSubview:footer atIndex:1];
    
    eventDisplay[indexPath.row] = [[NSNumber alloc] initWithBool:YES];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
  //  [cell setBackgroundColor:[UIColor colorWithRed:230/255.f green:233/255.f blue:230/255.f alpha:1]];
    [cell setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"finalBackground2.png"]]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    EventDetailsViewController *eventDetailsVC = [[EventDetailsViewController alloc] initWithNibName:@"EventDetailsViewController" bundle:nil event:[events[indexPath.row] objectForKey:kParticipateEventID]];
    [eventDetailsVC initCover:coverURLArray[indexPath.row] initInvitationStatus:[events[indexPath.row] objectForKey:@"invitationStatus"]];
    [self.navigationController pushViewController:eventDetailsVC animated:YES];
    eventDetailsVC = nil;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 220;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [events count];
}


@end
