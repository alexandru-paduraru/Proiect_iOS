//
//  EventDetailsViewController.m
//  Proiect_iOS
//
//  Created by Axelut Alex on 135//13.
//  Copyright (c) 2013 Axelut Alex. All rights reserved.
//

#import "EventDetailsViewController.h"
#import "Event.h"
#import "iOSAppDelegate.h"

@interface EventDetailsViewController ()

-(IBAction)joinButtonPressed:(id)sender;
-(IBAction)declineButtonPressed:(id)sender;
-(void)setEventResponse:(int)response;
-(void)viewDidLoad;
-(void)initButtons;
-(void)setEventCover;

@end

@implementation EventDetailsViewController
{
    NSString *eventTitle;
    NSString *eventId;
    int invitationStatus;
    PFObject *eventObject;
    NSNumber *numberOfPeople;
    NSNumber *inv;
    NSURL *coverURLLocal;
    iOSAppDelegate *appDelegate;
}
@synthesize joinButton;
@synthesize declineButton;
@synthesize numberOfPeopleLabel;
@synthesize addEventMap;

- (void)initCover:(NSURL *)coverURL initInvitationStatus:(NSNumber *)status{
    coverURLLocal = coverURL;
    inv = status;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil event:(PFObject *)aEvent{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self){
        eventObject = aEvent;
        self.navigationItem.title = [aEvent objectForKey:kEventNameKey];
        eventId = [aEvent objectId];
        PFQuery *query = [PFQuery queryWithClassName:@"Participate"];
        [query whereKey:@"eventID" equalTo:aEvent];
        [query countObjectsInBackgroundWithBlock:^(int count, NSError *error) {
            if (!error) {
                // The count request succeeded. Log the count
                numberOfPeople = [NSNumber numberWithInt:count];
                numberOfPeopleLabel.text = [NSString stringWithFormat:@"Number of people going: %@",numberOfPeople];
            } else {
                // The request failed
            }
        }];
    }
    return self;
}

- (void)setEventCover{
    
        
    UIImageView *eventCover= [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 130)];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 320, 130)];
    
    CAShapeLayer *maskLayer2 = [CAShapeLayer layer];
    maskLayer2.frame = CGRectMake(0, 0, 320, 130);
    maskLayer2.path = maskPath.CGPath;
    eventCover.layer.mask = maskLayer2;
    
    [eventCover.layer setContentsGravity:kCAGravityResizeAspectFill];
    [eventCover setAlpha:0.0];

    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSData *backgroundData = [NSData dataWithContentsOfURL:coverURLLocal];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSLog(@"adaug imaginea din info server");
            eventCover.image = [UIImage imageWithData:backgroundData];
            //  [cell addSubview:imgView];
            [self.view insertSubview:eventCover atIndex:2];
            [UIView animateWithDuration:0.7 animations:^{
                [eventCover setAlpha:1.0];
            }];
        });
    });
}

-(void)initButtons{
    [self.joinButton setBackgroundImage:[UIImage imageNamed:@"buttonStateNormal.png"] forState:UIControlStateNormal];
    [self.joinButton setBackgroundImage:[UIImage imageNamed:@"buttonStateSelected.png"] forState:UIControlStateSelected];
    [self.joinButton setBackgroundImage:[UIImage imageNamed:@"buttonStateSelected.png"] forState:UIControlStateHighlighted];
    
    [self.declineButton setBackgroundImage:[UIImage imageNamed:@"buttonStateNormal.png"] forState:UIControlStateNormal];
    [self.declineButton setBackgroundImage:[UIImage imageNamed:@"buttonStateSelected.png"] forState:UIControlStateSelected];
    [self.declineButton setBackgroundImage:[UIImage imageNamed:@"buttonStateSelected.png"] forState:UIControlStateHighlighted];
    
}
- (void)viewDidLoad
{
    //de facut sa se activeze butoanele in functie de ce apesi
    [super viewDidLoad];
//    self.navigationItem.title = @"asd";
    [self setEventCover];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"finalBackground2.png"]]];
    [self initButtons];
    NSLog(@"event id: %@",eventId);
    NSLog(@"invitation status: %i",invitationStatus);
    NSLog(@"event info:%@",eventObject);
    invitationStatus = [inv intValue];
    
    if(invitationStatus == 0){
        joinButton.selected = NO;
        declineButton.selected = YES;
    } else if(invitationStatus == 1){
        joinButton.selected = YES;
        declineButton.selected = NO;
    } else if (invitationStatus == -1){
        joinButton.selected = NO;
        declineButton.selected = NO;
    }
      //  PFQuery *query = [PFQuery queryWithClassName:kParticipateClassKey];
  //  [query getObjectInBackgroundWithId:<#(NSString *)#> block:<#^(PFObject *object, NSError *error)block#>]
  // de facut pagina cu detalii eveniment
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated{
    appDelegate = [[UIApplication sharedApplication] delegate];
    self.addEventMap.region = MKCoordinateRegionMake(appDelegate.currentLocation.coordinate, MKCoordinateSpanMake(0.018516, 0.121801));
    
    NSMutableArray *newPosts = [[NSMutableArray alloc] initWithCapacity:1];
    //PFObject *object = [[PFObject alloc] init];
    Event *newPost = [[Event alloc] initWithCoordinate:appDelegate.currentLocation.coordinate andTitle:@"Eveniment" andSubtitle:@"Locatie"];
    [newPosts addObject:newPost];
    
    newPost.animatesDrop = YES;
    self.addEventMap.showsUserLocation = YES;
    [self.addEventMap addAnnotations:newPosts];
}
-(IBAction)joinButtonPressed:(id)sender{
    declineButton.selected = NO;
    joinButton.selected = YES;
    [self setEventResponse:1];
}
-(IBAction)declineButtonPressed:(id)sender{
    declineButton.selected = YES;
    joinButton.selected = NO;
    [self setEventResponse:0];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewEventOnMap:(CLLocation *)aCurrentLocation{
    
}
-(void)setEventResponse:(int)response{
    PFQuery *query = [PFQuery queryWithClassName:kParticipateClassKey];
    [query whereKey:kParticipateEventID equalTo:[PFObject objectWithoutDataWithClassName:kEventClassKey objectId:eventId]];
    [query whereKey:kFriendInvited equalTo:[[PFUser currentUser] objectId]];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *event, NSError *error) {
        if (event){
            if(response == 1){
                [event setObject:[NSNumber numberWithInt:kParticipateJoin] forKey:kParticipateInvitationStatus];
            } else {
                [event setObject:[NSNumber numberWithInt:kParticipateDecline] forKey:kParticipateInvitationStatus];
            }
            [event saveInBackground];
        }
    }];
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

@end
