//
//  iOSViewController.h
//  Proiect_iOS
//
//  Created by Axelut Alex on 203//13.
//  Copyright (c) 2013 Axelut Alex. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "AddEventViewController.h"
#import "EventsTableViewController.h"


@interface iOSViewController : UIViewController <PFLogInViewControllerDelegate , PFSignUpViewControllerDelegate, AddEventDelegate>{
    UILabel *label;
    CLLocationManager *_locationManager;
    
}
@property (nonatomic,retain) IBOutlet UILabel *label;
@property (nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,retain) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic) IBOutlet EventsTableViewController *eventsTable;

- (IBAction)createEventClicked:(id)sender;
- (IBAction)logOutButtonPressed:(id)sender;

@end
