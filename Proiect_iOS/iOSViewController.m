

#import "iOSViewController.h"
#import "MyLogInViewController.h"
#import "AddEventViewController.h"
#import "iOSAppDelegate.h"


@interface iOSViewController () <CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource >{
    NSArray *eventsArray;
    BOOL eventsTableIsHidden;
}

@property (nonatomic, strong) CLLocationManager *_locationManager;

// CLLocationManagerDelegate methods:
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation;

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error;
//notification


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

/*
- (void)populateEventsList{
   
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"createdBy = %@",[PFUser currentUser]];
    PFQuery *query = [PFQuery queryWithClassName:@"Event" predicate:predicate];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            eventsArray = objects;
         //   [self initTableView];
            [activityIndicator removeFromSuperview];
            NSLog(@"Successfully retrieved %d events.", [eventsArray count]);
            for (int i=0; i<4; i++) {
                NSLog(@"%@",[[eventsArray objectAtIndex:i] objectForKey:@"eventName"]);
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}
*/

#pragma mark - Init

- (void)viewDidLoad{
    [super viewDidLoad];
    [super setTitle:@"Events"];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]]];
    [self addButtonsToNavBar];
    //   [activityIndicator startAnimating];
    eventsTableIsHidden = YES;
    [self startStandardUpdates];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [activityIndicator startAnimating];
    if (![PFUser currentUser]) { // No user logged in
        [self showLogInViewController];
    } else {
        // Create the table view controller
        [self checkIfUserExistsOrAddHimToDB];
    }
    
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

-(void) showLogInViewController{
    MyLogInViewController *loginViewController = [[MyLogInViewController alloc] init];
    [loginViewController setDelegate:self];
    [loginViewController setFields:PFLogInFieldsUsernameAndPassword | PFLogInFieldsSignUpButton | PFLogInFieldsFacebook];
    loginViewController.facebookPermissions = [NSArray arrayWithObjects:
                                               @"user_about_me", @"user_birthday", @"user_location", @"email",@"user_photos",  nil];
    [self presentViewController:loginViewController animated:YES completion:nil];
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
- (void)showEventsTableViewOrRefresh{
    [self.eventsTable.view removeFromSuperview];
    self.eventsTable = [[EventsTableViewController alloc] initWithStyle:UITableViewStylePlain];
    self.eventsTable.view.frame = CGRectMake(0.f, 120.f, 320.f, 300.f);
    [self addChildViewController:self.eventsTable];
    [self.view addSubview:self.eventsTable.view];   
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
                 
                 self.homeUserProfile = [[HomeUserProfileVC alloc] initWithNibName:@"HomeUserProfileVC" bundle:nil];
                 self.homeUserProfile.view.frame = CGRectMake(0.f, 0.f, 320.f, 150.f);
                 self.homeUserProfile.userNameLabel.text = graphUser.name;
                 self.homeUserProfile.profileCover.image = image;
                 self.homeUserProfile.profileImageView.image = profileImageView;
                 
                 [self addChildViewController:self.homeUserProfile];
                 [self.view addSubview:self.homeUserProfile.view];
                 
                 [self showEventsTableViewOrRefresh];
                 
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
                         
                         UIButton *sender = [[UIButton alloc] init];
                         [self createEventClicked:sender];
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
                                              //  @"pictureURL": [pictureURL absoluteString]
                                              };

                PFUser *localUser = [PFUser currentUser];
                [localUser setObject:[userProfile objectForKey:@"birthday"] forKey:UserBirthdayKey];
                [localUser setObject:[userProfile objectForKey:@"location"] forKey:@"location"];
                [localUser setObject:[userProfile objectForKey:@"name"] forKey:UserNameKey];
                [localUser setObject:userProfile[@"email"] forKey:UserEmailKey];
                [localUser saveInBackground];
                
                NSLog(@"nume:%@, \n data nasterii: %@",[userProfile objectForKey:@"name"],[userProfile objectForKey:@"birthday"]);
               
                
                [self populateUserFBPictures];
            }
        } else if ([error.userInfo[FBErrorParsedJSONResponseKey][@"body"][@"error"][@"type"] isEqualToString:@"OAuthException"]) { // 
            NSLog(@"The facebook session was invalidated");
           // [self showLogInViewController];
            [self showEventsTableViewOrRefresh];
        } else {
            NSLog(@"Some other error: %@", error);
        }
    }];
}

- (void) createEventClicked:(id)sender{
    AddEventViewController *addEventViewController = [[AddEventViewController alloc] initWithNibName:@"AddEventViewController" bundle:nil];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:addEventViewController];
    [self presentModalViewController:navController animated:YES];

    
//    [self presentViewController:addEventViewController animated:YES completion:nil];
   // [self.navigationController pushViewController:addEventViewController animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
