//
//  EventDetailsViewController.h
//  Proiect_iOS
//
//  Created by Axelut Alex on 135//13.
//  Copyright (c) 2013 Axelut Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "iOSAppDelegate.h"

@interface EventDetailsViewController : UIViewController<MKMapViewDelegate>{
}
@property (nonatomic,retain) IBOutlet UIButton *joinButton;
@property (nonatomic,retain) IBOutlet UIButton *declineButton;
@property (nonatomic,retain) IBOutlet UILabel *numberOfPeopleLabel;
@property (nonatomic,strong) IBOutlet MKMapView *addEventMap;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil event:(id)aEvent;
-(void)initCover:(NSURL *)coverURL initInvitationStatus:(NSNumber *)status;
-(IBAction)joinButtonPressed:(id)sender;
-(IBAction)declineButtonPressed:(id)sender;

@end
