
#import "AddEventViewController.h"

@interface AddEventViewController ()

@end

@implementation AddEventViewController{
    NSDateFormatter *dateFormatter;
    NSString *dateString;
    BOOL datePickerIsOnTheScreen;
}

@synthesize delegate = _delegate;
@synthesize datePicker = _datePicker;
@synthesize changeDateButton;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (CLLocationManager *)locationManager {
    if (_locationManager != nil) {
        return _locationManager;
    }
    _locationManager = [[CLLocationManager alloc] init];
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    [_locationManager setDelegate:self];
    [_locationManager setPurpose:@"Your current location is used to demonstrate PFGeoPoint and Geo Queries."];
    
    return _locationManager;
}

-(IBAction)savePressed
{
    //Is anyone listening
    CLLocation *location = _locationManager.location;
    CLLocationCoordinate2D coordinate = [location coordinate];
    PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLatitude:coordinate.latitude
                                                  longitude:coordinate.longitude];
    
    if([eventName.text isEqualToString:@""] || self.datePicker.date == nil){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Fail!" message:@"Make sure all the fields are completed" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertView show];
    } else {
    PFObject *object = [PFObject objectWithClassName:@"Event"];
    [object setObject:[PFUser currentUser] forKey:@"createdBy"];
    [object setObject:geoPoint forKey:@"location"];
    [object setObject:eventName.text forKey:@"eventName"];
    [object setObject:self.datePicker.date forKey:@"eventDate"];
    [object saveEventually:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
                // Reload the PFQueryTableViewController
      //        [self loadObjects];
                [self dismissModalViewControllerAnimated:YES];
                NSLog(@"eveniment adaugat! verifica parse.com");
            }
        }];
    }
    
    /*
    if([self.delegate respondsToSelector:@selector(amountEntered:)])
    {
        //send the delegate function with the amount entered by the user
        [self.delegate amountEntered:[amountTextField.text intValue]];
    }
    
    [self dismissModalViewControllerAnimated:YES];
     */
}

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

- (IBAction)changeDatePressed:(UIButton *)sender{
    [self hideKeyBoards];
    if(!datePickerIsOnTheScreen){
        datePickerIsOnTheScreen = YES;
        
        self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0f, 480.0f, 325.0f, 300.0f)];
        //[newView setFrame:CGRectMake( 0.0f, 480.0f, 320.0f, 480.0f)]; //notice this is OFF screen!
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

- (void)changeDateButtonLabel{
    NSLog(@"%@",[dateFormatter stringFromDate:self.datePicker.date]);
    self.changeDateButton.titleLabel.text = [[NSString alloc] initWithFormat:@" Date: %@",[dateFormatter stringFromDate:self.datePicker.date]];
}
-(IBAction)cancelPressed{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [[self locationManager] startUpdatingLocation];
    CLLocation *location = _locationManager.location;
    coordinates.text = [[NSString alloc] initWithFormat:@"xy:%@",location];
    NSLog(@"locatie:%@",location);
    
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM dd, yyyy 'at' HH:mm"];
    dateString = [[NSString alloc] initWithFormat:@"Date: %@",[dateFormatter stringFromDate:[NSDate date]]];
  //  self.changeDateButton.titleLabel.text = dateString;
   
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]]];
    datePickerIsOnTheScreen = NO;
   
  /*  [super setTitle:@"Add Event"];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                  target:self
                                  action:@selector(menuButtonPressed)];
    
    [[self navigationItem] setRightBarButtonItem:barButton];
   */ 
   // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
