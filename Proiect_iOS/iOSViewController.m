

#import "iOSViewController.h"
#import "MyLogInViewController.h"
#import "AddEventViewController.h"



@interface iOSViewController () <UITableViewDelegate, UITableViewDataSource>{
    NSArray *eventsArray;
}
    

@end

@implementation iOSViewController
@synthesize label;
@synthesize tableView;
@synthesize activityIndicator;
@synthesize eventsTable;

- (void) alertStatus:(NSString *) message title:(NSString *) title{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
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
- (void)viewDidLoad{
    [super viewDidLoad];
    [super setTitle:@"Events"];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]]];
    [self addButtonsToNavBar];
    //   [activityIndicator startAnimating];
    // Create the table view controller
    self.eventsTable = [[EventsTableViewController alloc] initWithStyle:UITableViewStylePlain];
    
    self.eventsTable.view.frame = CGRectMake(0.f, 0.f, 320.f, 420.f);
    
    [self addChildViewController:self.eventsTable];
    [self.view addSubview:self.eventsTable.view];
    [self checkIfUserExistsOrAddHimToDB];
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


-(void) showLogInViewController{
    MyLogInViewController *loginViewController = [[MyLogInViewController alloc] init];
    [loginViewController setDelegate:self];
    [loginViewController setFields:PFLogInFieldsUsernameAndPassword | PFLogInFieldsSignUpButton | PFLogInFieldsFacebook];
    [self presentViewController:loginViewController animated:YES completion:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (![PFUser currentUser]) { // No user logged in
        [self showLogInViewController];
    }
        
}

-(void)checkIfUserExistsOrAddHimToDB{
    FBRequest *request = [FBRequest requestForMe];
    
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            
            NSDictionary *userData = (NSDictionary *)result;
            
            NSString *facebookID = userData[@"id"];
            
            NSDictionary *userProfile = @{
                                          @"facebookId": facebookID,
                                          @"name": userData[@"name"],
                                          @"location": userData[@"location"][@"name"],
                                          @"gender": userData[@"gender"],
                                          @"birthday": userData[@"birthday"]
                                          //  @"pictureURL": [pictureURL absoluteString]
                                          };
          //  NSPredicate *predicate = [NSPredicate predicateWithFormat:
          //                            @"username = %@",[PFUser currentUser]];
          //  PFQuery *query = [PFQuery queryWithClassName:@"GameScore" predicate:predicate];
//            PFObject *user = [PFObject objectWithClassName:@"User"];
//            [user setObject:[userProfile objectForKey:@"birthday"] forKey:@"birthday"];
//            
            
            NSLog(@"nume:%@, \n data nasterii: %@",[userProfile objectForKey:@"name"],[userProfile objectForKey:@"birthday"]);
            
        } else if ([error.userInfo[FBErrorParsedJSONResponseKey][@"body"][@"error"][@"type"] isEqualToString:@"OAuthException"]) { // Since the request failed, we can check if it was due to an invalid session
            NSLog(@"The facebook session was invalidated");
            [self showLogInViewController];
        } else {
            NSLog(@"Some other error: %@", error);
        }
    }];
}
-(void)amountEntered:(NSInteger)amount
{
    label.text = [NSString stringWithFormat:@"%i" , amount];
}

- (void) createEventClicked:(id)sender{
    AddEventViewController *addEventViewController = [[AddEventViewController alloc] initWithNibName:@"AddEventViewController" bundle:nil];
    [addEventViewController setDelegate:self];
    [self presentViewController:addEventViewController animated:YES completion:nil];
   // [[self navigationController] pushViewController:addEventViewController animated:YES];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
@end
