

#import "iOSViewController.h"
#import "MyLogInViewController.h"
#import "AddEventViewController.h"
#import "iOSAppDelegate.h"
#import "Reachability.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import "EventsTableVC.h"


@interface iOSViewController () <CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource >{
    NSMutableArray *eventsArray;
    BOOL eventsTableIsHidden;
    EventsTableVC *eventsTable;
    int eventsNumber;
}

@property (nonatomic, strong) CLLocationManager *_locationManager;

// CLLocationManagerDelegate methods:
- (void) alertStatus:(NSString *) message title:(NSString *) title;
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation;

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error;
- (void) locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status;

- (void) startStandardUpdates;
- (BOOL) connected;
- (void) viewDidLoad;

- (void) addButtonsToNavBar;
- (void) logOutButtonPressed:(id)sender;
- (void) createEventClicked:(id)sender;

- (void) facebookLoginDone;
- (void) checkIfUserExistsOrAddHimToDB;
- (void) populateUserFBPictures;
- (void) showEventsTableViewOrRefresh:(NSDictionary *)profileInfo;

@end

@implementation iOSViewController
@synthesize tableView;
@synthesize activityIndicator;
@synthesize eventsTable;
@synthesize userNameLabel;
@synthesize userProfileImage;
@synthesize homeUserProfile;
@synthesize _locationManager = locationManager;

- (void) alertStatus:(NSString *) message title:(NSString *) title{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
}

#pragma mark - CLLocationManagerDelegate methods and helpers

- (void)startStandardUpdates {
	if (locationManager == nil) {
		locationManager = [[CLLocationManager alloc] init];
	}
    
	locationManager.delegate = self;
	locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
	// Set a movement threshold for new events.
	locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters;
    
	[locationManager startUpdatingLocation];
    
	CLLocation *currentLocation = locationManager.location;
	if (currentLocation) {
		iOSAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
		appDelegate.currentLocation = currentLocation;
	}
}
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
	NSLog(@"%s", __PRETTY_FUNCTION__);
	switch (status) {
		case kCLAuthorizationStatusAuthorized:
			NSLog(@"kCLAuthorizationStatusAuthorized");
			// Re-enable the post button if it was disabled before.
			self.navigationItem.rightBarButtonItem.enabled = YES;
			[locationManager startUpdatingLocation];
			break;
		case kCLAuthorizationStatusDenied:
			NSLog(@"kCLAuthorizationStatusDenied");
        {{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"beeThere can’t access your current location.\n\n Please turn on access for beeThere to your location in the Settings app under Location Services." message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
            [alertView show];
            // Disable the post button.
            self.navigationItem.rightBarButtonItem.enabled = NO;
        }}
			break;
		case kCLAuthorizationStatusNotDetermined:
			NSLog(@"kCLAuthorizationStatusNotDetermined");
			break;
		case kCLAuthorizationStatusRestricted:
			NSLog(@"kCLAuthorizationStatusRestricted");
			break;
	}
}
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
	NSLog(@"%s", __PRETTY_FUNCTION__);
    
	iOSAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
	appDelegate.currentLocation = newLocation;
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
	NSLog(@"%s", __PRETTY_FUNCTION__);
	NSLog(@"Error: %@", [error description]);
    
	if (error.code == kCLErrorDenied) {
		[locationManager stopUpdatingLocation];
	} else if (error.code == kCLErrorLocationUnknown) {
		// todo: retry?
		// set a timer for five seconds to cycle location, and if it fails again, bail and tell the user.
	} else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error retrieving location"
		                                                message:[error description]
		                                               delegate:nil
		                                      cancelButtonTitle:nil
		                                      otherButtonTitles:@"Ok", nil];
		[alert show];
	}
}

#pragma mark - Init
- (BOOL)connected{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return !(networkStatus == NotReachable);
}
- (void)viewDidLoad{
    [super viewDidLoad];
    [super setTitle:@"Moments"];
   // [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:Background]]];
    [self addButtonsToNavBar];
    //   [activityIndicator startAnimating];
    eventsTableIsHidden = YES;
    eventsNumber = 0;
    
    if([self connected]){
        NSLog(@"connected");
        [self startStandardUpdates];
        [activityIndicator startAnimating];
        if (![PFUser currentUser]) { // No user logged in
            [self showLogInViewController];
        } else {
            // Create the table view controller
            [self checkIfUserExistsOrAddHimToDB];
        }
    } else {
        [self alertStatus:@"There is no available internet connection. Please try again later." title:@"No internet connection"];
        //de facut aici o pagina cu o fata suparata in care sa zici ca nu exista conexiune la net, buton cu retry care duce la prima pagina, restul se face automat;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    
}

- (void)addButtonsToNavBar{
    UIButton *a1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [a1 setFrame:CGRectMake(0.0f, 0.0f, 52.0f, 53.0f)];
    // [a1 setImageEdgeInsets:UIEdgeInsetsMake(0.0f, 10.0f, 10.0f, 0.0f)];
    [a1 addTarget:self action:@selector(createEventClicked:) forControlEvents:UIControlEventTouchUpInside];
    [a1 setImage:[UIImage imageNamed:@"addEventButton2.png"] forState:UIControlStateNormal];
    [a1 setImage:[UIImage imageNamed:@"addEventButtonPressed2.png"] forState:UIControlStateHighlighted];
    UIBarButtonItem *addEventButton = [[UIBarButtonItem alloc] initWithCustomView:a1];
    
    self.navigationItem.rightBarButtonItem = addEventButton;
    
    UIButton *a2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [a2 setFrame:CGRectMake(0.0f, 0.0f, 35.0f, 32.0f)];
    [a2 addTarget:self action:@selector(logOutButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [a2 setImage:[UIImage imageNamed:@"myProfile.png"] forState:UIControlStateNormal];
    [a2 setImage:[UIImage imageNamed:@"myProfilePressed.png"] forState:UIControlStateHighlighted];
    UIBarButtonItem *myProfileButton = [[UIBarButtonItem alloc] initWithCustomView:a2];
    
    self.navigationItem.leftBarButtonItem = myProfileButton;
}

#pragma mark - Login/ Logout

- (void) showLogInViewController{
    MyLogInViewController *loginViewController = [[MyLogInViewController alloc] initWithNibName:@"MyLoginViewController" bundle:nil];
    loginViewController.delegate = self;
    [loginViewController setFields: PFLogInFieldsFacebook];
    loginViewController.facebookPermissions = [NSArray arrayWithObjects:
                                               @"user_about_me", @"user_birthday", @"user_location", @"email",@"user_photos",  nil];
    [self presentViewController:loginViewController animated:NO completion:nil];
 
}
- (void) logOutButtonPressed:(id)sender{
    [PFUser logOut];
    [FBSession.activeSession closeAndClearTokenInformation];
    [self showLogInViewController];
    NSLog(@"delogat");
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

// Sent to the delegate when the log in attempt fails.
- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
    NSLog(@"Failed to log in...");
}
- (void) logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user{
    [self dismissModalViewControllerAnimated:YES];
}

- (void) logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController{
    [self dismissModalViewControllerAnimated:YES];
}

- (void) signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user{
    [self dismissModalViewControllerAnimated:YES];
}

- (void) signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - EventsTable stuff

- (void)showEventsTableViewOrRefresh:(NSDictionary *)profileInfo{
    eventsTable = [[EventsTableVC alloc] init];
    if(profileInfo){
        [eventsTable initProfileInfoFacebook:profileInfo];
    }
    PFQuery *myEventsQuery = [PFQuery queryWithClassName:kParticipateClassKey];
    [myEventsQuery whereKey:kFriendInvited equalTo:[[PFUser currentUser] objectId]];
    [myEventsQuery orderByDescending:kCreatedAt];
    [myEventsQuery includeKey:kParticipateEventID];
    myEventsQuery.cachePolicy = kPFCachePolicyNetworkElseCache;
    [myEventsQuery findObjectsInBackgroundWithBlock:^(NSArray *myEvents, NSError *error) {
        if(!error){
            [eventsTable initWithEvents:myEvents];
            eventsTable.view.frame = CGRectMake(0.f, 0.f, 320.f, 420.f);
            [self addChildViewController:eventsTable];
            [self.view addSubview:eventsTable.view];
        } else {
            NSLog(@"eroare la primirea evenimentelor userului curent");
        }
    }];
    
}

#pragma mark - Facebook Stuff

- (void)populateUserFBPictures
{
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:@"name,cover,picture.type(square)",@"fields", nil];
    
    FBRequest *requestForUserPhotos = [[FBRequest requestForMe] initWithSession:FBSession.activeSession
                                                                      graphPath:@"me"
                                                                     parameters:param
                                                                     HTTPMethod:nil];
    if (FBSession.activeSession.isOpen) {
        [requestForUserPhotos startWithCompletionHandler:
                                    ^(FBRequestConnection *connection,
                                    id result,
                                    NSError *error) {
             if (!error) {
                 NSDictionary<FBGraphUser> *graphUser = result;
                 
                 NSURL *coverURL = [NSURL URLWithString:graphUser[@"cover"][@"source"]];
                 NSData *data = [NSData dataWithContentsOfURL:coverURL];
                 UIImage *image = [[UIImage alloc] initWithData:data];
                 
                 NSURL *profileImageURL = [NSURL URLWithString:graphUser[@"picture"][@"data"][@"url"]];
                 NSData *profileImageData = [NSData dataWithContentsOfURL:profileImageURL];
                 UIImage *profileImageView = [[UIImage alloc] initWithData:profileImageData];
                 
                 NSMutableDictionary *profileInfo = [NSMutableDictionary dictionaryWithCapacity:3];
                 if(image){
                     [profileInfo setObject:image forKey:@"cover"];
                 } else {
                     [profileInfo setObject:[UIImage imageNamed:@"eventTableCellHeader.png"] forKey:@"cover"];
                 }
                 [profileInfo setObject:profileImageView forKey:kUserProfilePictureKey];
                 [profileInfo setObject:[graphUser objectForKey:@"name"] forKey:kUserNameKey];
                 
                 [self showEventsTableViewOrRefresh:profileInfo];
                 
                 NSURL *url = [NSURL URLWithString:graphUser[@"picture"][@"data"][@"url"]];
                 data = [NSData dataWithContentsOfURL:url];
                 UIImage *profilePic = [[UIImage alloc] initWithData:data];
                 
                 NSData *imageData = UIImageJPEGRepresentation(profilePic, 0.7f);
                 
                 PFFile *imageFile = [PFFile fileWithName:@"profilePicture.jpeg" data:imageData];
               
                 // Download the user's facebook profile picture
                            
                 [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                     if (!error) {
                         PFUser *localUser = [PFUser currentUser];
                         [localUser setObject:imageFile forKey:@"profilePicture"];
                         [localUser saveInBackground];
                         [activityIndicator removeFromSuperview];
                         
//                         UIButton *sender = [[UIButton alloc] init];
//                         [self createEventClicked:sender];
                     }
                     else{
                         NSLog(@"Error: %@ %@", error, [error userInfo]);
                     }
                 }];

             }
         }];
    }
}

-(void)checkIfUserExistsOrAddHimToDB{
    FBRequest *request = [FBRequest requestForMe];
    
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            
            NSDictionary *userData = (NSDictionary *)result;
            NSString *facebookID = userData[@"id"];
            if(userData[@"name"] && userData[@"location"][@"name"]){
                NSDictionary *userProfile = @{
                                              @"facebookId": facebookID,
                                              @"name": userData[@"name"],
                                              @"location": userData[@"location"][@"name"],
                                              @"gender": userData[@"gender"],
                                              @"birthday": userData[@"birthday"],
                                              @"email":userData[@"email"]
                                              
                                              };

                PFUser *localUser = [PFUser currentUser];
                [localUser setObject:[userProfile objectForKey:@"birthday"] forKey:kUserBirthdayKey];
                [localUser setObject:[userProfile objectForKey:@"location"] forKey:kUserLocationNameKey];
                [localUser setObject:[userProfile objectForKey:@"name"] forKey:kUserNameKey];
                [localUser setObject:userProfile[@"email"] forKey:kUserEmailKey];
                [localUser saveInBackground];
                
                NSLog(@"nume:%@, \n data nasterii: %@",[userProfile objectForKey:@"name"],[userProfile objectForKey:@"birthday"]);
               
                [self populateUserFBPictures];
            }
        } else if ([error.userInfo[FBErrorParsedJSONResponseKey][@"body"][@"error"][@"type"] isEqualToString:@"OAuthException"]) { // 
            NSLog(@"The facebook session was invalidated");
           // [self showLogInViewController];
            [self showEventsTableViewOrRefresh:nil];
        } else {
            NSLog(@"Some other error: %@", error);
        }
    }];
}

- (void) createEventClicked:(id)sender{
        
    AddEventViewController *addEventViewController = [[AddEventViewController alloc] initWithNibName:@"AddEventViewController" bundle:nil];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:addEventViewController];
    [self presentModalViewController:navController animated:YES];
}
- (void)facebookLoginDone{
    [self checkIfUserExistsOrAddHimToDB];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
