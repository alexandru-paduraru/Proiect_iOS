
#import "AddEventViewController.h"
#import "Event.h"
#import "iOSAppDelegate.h"
#import "PlacePickerViewController.h"



@interface AddEventViewController ()
- (IBAction)backgroundClicked;
- (IBAction)changeDatePressed:(UIButton*)sender;
- (IBAction)chooseALocation:(UIButton*)sender;
- (IBAction)chooseYourEntourage:(UIButton*)sender;
@end

@implementation AddEventViewController{
    NSDateFormatter *dateFormatter;
    NSString *dateString;
    NSArray *friends;
    BOOL datePickerIsOnTheScreen;
    iOSAppDelegate *appDelegate;
}

@synthesize datePicker = _datePicker;
@synthesize mySearchDisplayController = _mySearchDisplayController;
@synthesize changeDateButton;
@synthesize chooseALocationButton;
@synthesize chooseYourEntourageButton;
@synthesize addEventMap;

#pragma mark - Init

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    UINavigationBar *navBar = [[self navigationController] navigationBar];
//    UIImage *backgroundImage = [UIImage imageNamed:NavBarBackground];
//    [navBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    
    UIBarButtonItem *createEventButton = [[UIBarButtonItem alloc] initWithTitle:@"Create" style:UIBarButtonItemStyleDone target:self action:@selector(savePressed)];
    UIBarButtonItem *cancelEvent = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelPressed)];
    self.navigationItem.leftBarButtonItem = cancelEvent;
    self.navigationItem.rightBarButtonItem = createEventButton;
    
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:EventDateFormat];
    dateString = [[NSString alloc] initWithFormat:@"Date: %@",[dateFormatter stringFromDate:[NSDate date]]];
    appDelegate = [[UIApplication sharedApplication] delegate];
    self.addEventMap.region = MKCoordinateRegionMake(appDelegate.currentLocation.coordinate, MKCoordinateSpanMake(0.018516, 0.121801));
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]]];
    datePickerIsOnTheScreen = NO;
    
    PFQuery *query = [PFUser query];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        friends = objects;
    }];
    
}
- (void)viewDidAppear:(BOOL)animated{
    coordinates.text = [[NSString alloc] initWithFormat:@"xy:%@",appDelegate.currentLocation];
    
    NSMutableArray *newPosts = [[NSMutableArray alloc] initWithCapacity:1];
    //PFObject *object = [[PFObject alloc] init];
    Event *newPost = [[Event alloc] initWithCoordinate:appDelegate.currentLocation.coordinate andTitle:@"test" andSubtitle:@"test subt"];
    [newPosts addObject:newPost];
    
    newPost.animatesDrop = YES;
    self.addEventMap.showsUserLocation = YES;
    [self.addEventMap addAnnotations:newPosts];
    
}

#pragma mark - Buttons

-(IBAction)savePressed
{
    
    // Get user's current location
    CLLocationCoordinate2D currentCoordinate = appDelegate.currentLocation.coordinate;
    
    NSLog(@"locatie: lat %f, long %f",currentCoordinate.latitude,currentCoordinate.longitude);
    
    PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLatitude:currentCoordinate.latitude
                                                  longitude:currentCoordinate.longitude];
    
    if([eventName.text isEqualToString:@""] || self.datePicker.date == nil){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Fail!" message:@"Make sure all the fields are completed" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertView show];
    } else {
        PFObject *object = [PFObject objectWithClassName:EventClassKey];
        [object setObject:[[PFUser currentUser] objectId] forKey:EventCreatedByKey];
        [object setObject:geoPoint forKey:EventLocationKey];
        [object setObject:eventName.text forKey:EventNameKey];
        [object setObject:self.datePicker.date forKey:EventDateKey];
        [object setObject:self.chooseALocationButton.titleLabel.text forKey:EventLocationNameKey];
        [object saveEventually:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                // Reload the PFQueryTableViewController
                //        [self loadObjects]d
                [self dismissModalViewControllerAnimated:YES];
                NSLog(@"eveniment adaugat! verifica parse.com");
            }
            else {
                NSLog(@"eroare:%@",error);
            }
        }];
    }
}
- (IBAction)chooseALocation:(UIButton*)sender{
    PlacePickerViewController *PPViewController = [[PlacePickerViewController alloc] initWithNibName:@"PlacePickerViewController" bundle:nil];
    PPViewController.delegate = self;
    
    PPViewController.locationCoordinate = CLLocationCoordinate2DMake(44.4325, 26.103889);
    PPViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [PPViewController presentModallyFromViewController:self animated:YES handler:
     ^(FBViewController *sender, BOOL donePressed){
         if(donePressed) {
             NSLog(@"Selected place: %@", PPViewController.selection);
             NSString *name = [PPViewController.selection objectForKey:@"name"];
             if(name){
                 chooseALocationButton.titleLabel.text = name;
             }
         }
     }];
}

- (IBAction)changeDatePressed:(UIButton *)sender{
    [self hideKeyBoards];
    if(!datePickerIsOnTheScreen){
        datePickerIsOnTheScreen = YES;
        
        self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0f, 480.0f, 325.0f, 300.0f)];
        [UIView beginAnimations:@"animateDatePicker" context:nil];
        [UIView setAnimationDuration:0.4];
        [self.datePicker setFrame:CGRectMake( 0.0f, 250.0f, 320.0f, 480.0f)]; //notice this is ON screen!
        [UIView commitAnimations];
        
        self.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        self.datePicker.hidden = NO;
        self.datePicker.date = [NSDate date];
        
        [self.datePicker addTarget:self action:@selector(changeDateButtonLabel) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:self.datePicker];
    }
}
- (IBAction)chooseYourEntourage:(UIButton *)sender{
    [self backgroundClicked];
    SearchChooseFriendsVC *searchChooseFriends = [[SearchChooseFriendsVC alloc] init];
    [searchChooseFriends initWithUsers:friends];
    searchChooseFriends.delegate = self;
//    searchChooseFriends.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//    [self presentModalViewController:searchChooseFriends animated:YES];
    [self.navigationController pushViewController:searchChooseFriends animated:YES];
}
-(IBAction)cancelPressed{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - Actions

- (IBAction)hideDatePicker{
    [UIView beginAnimations:@"animateDatePicker" context:nil];
    [UIView setAnimationDuration:0.4];
    [self.datePicker setFrame:CGRectMake( 0.0f, 480.0f, 320.0f, 480.0f)]; //notice this is ON screen!
    [UIView commitAnimations];
    datePickerIsOnTheScreen = NO;
    if(self.datePicker.date != nil){
        [self changeDateButtonLabel];
    }
}

- (void)hideKeyBoards{
    [eventName resignFirstResponder];
    //[eventDate resignFirstResponder];
}
- (IBAction)backgroundClicked{
    [self hideKeyBoards];
    [self hideDatePicker];
}

- (void)changeDateButtonLabel{
    NSLog(@"%@",[dateFormatter stringFromDate:self.datePicker.date]);
    self.changeDateButton.titleLabel.text = [[NSString alloc] initWithFormat:@"Date: %@",[dateFormatter stringFromDate:self.datePicker.date]];
}

- (void)showSelectedFriendsFromTableView:(NSString*)firstFriendName numberOfInvitedFriends:(NSInteger)number{
    NSMutableString *infoFriends = [[NSMutableString alloc] init];
    if(number > 1){
        [infoFriends appendFormat:@"You, %@ and %i others",firstFriendName,number-1];
    } else if (number == 1){
        [infoFriends appendFormat:@"You and %@",firstFriendName];
    } else {
        infoFriends = [infoFriends initWithString:@"Choose your entourage"];
    }
    self.chooseYourEntourageButton.titleLabel.text = infoFriends;
}


- (MKAnnotationView *)mapView:(MKMapView *)aMapView viewForAnnotation:(id<MKAnnotation>)annotation {
	// Let the system handle user location annotations.
	if ([annotation isKindOfClass:[MKUserLocation class]]) {
		return nil;
	}
    
	static NSString *pinIdentifier = @"CustomPinAnnotation";
    
	// Handle any custom annotations.
	if ([annotation isKindOfClass:[Event class]])
	{
		// Try to dequeue an existing pin view first.
		MKPinAnnotationView *pinView = (MKPinAnnotationView*)[aMapView dequeueReusableAnnotationViewWithIdentifier:pinIdentifier];
        
		if (!pinView)
		{
			// If an existing pin view was not available, create one.
			pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
			                                          reuseIdentifier:pinIdentifier];
		}
		else {
			pinView.annotation = annotation;
		}
		pinView.pinColor = [(Event *)annotation pinColor];
		pinView.animatesDrop = [((Event *)annotation) animatesDrop];
		pinView.canShowCallout = YES;
        
		return pinView;
	}
	return nil;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
	id<MKAnnotation> annotation = [view annotation];
    NSLog(@"apsat pe pin!");
	if ([annotation isKindOfClass:[Event class]]) {
		//Event *post = [view annotation];
        
	} else if ([annotation isKindOfClass:[MKUserLocation class]]) {
		// Center the map on the user's current location:
		appDelegate = [[UIApplication sharedApplication] delegate];
		MKCoordinateRegion newRegion = MKCoordinateRegionMakeWithDistance(appDelegate.currentLocation.coordinate, 200 * 2, 200 * 2);
        
		[self.addEventMap setRegion:newRegion animated:YES];
		//self.mapPannedSinceLocationUpdate = NO;
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)placePickerViewController:(FBPlacePickerViewController *)placePicker
                      handleError:(NSError *)error
{
    NSLog(@"Error during data fetch.");
}
- (void)placePickerViewControllerSelectionDidChange:(FBPlacePickerViewController *)placePicker
{
    NSLog(@"Place data loaded.");
}

@end
