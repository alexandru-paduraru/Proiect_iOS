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
#import "HomeUserProfileVC.h"


@interface iOSViewController : UIViewController <PFLogInViewControllerDelegate , PFSignUpViewControllerDelegate>{
    UILabel *label;
}

@property (nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,retain) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic) IBOutlet EventsTableViewController *eventsTable;
@property (nonatomic) IBOutlet HomeUserProfileVC *homeUserProfile;
@property (nonatomic, strong) IBOutlet FBProfilePictureView *userProfileImage;
@property (nonatomic, strong) IBOutlet UILabel *userNameLabel;

- (IBAction)createEventClicked:(id)sender;
- (IBAction)logOutButtonPressed:(id)sender;
//- (IBAction)showMapButtonPressed;

@end
