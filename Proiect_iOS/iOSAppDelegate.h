//
//  iOSAppDelegate.h
//  Proiect_iOS
//
//  Created by Axelut Alex on 203//13.
//  Copyright (c) 2013 Axelut Alex. All rights reserved.
//


// Parse API key constants:
static NSString *const kEventClassKey = @"Event";
static NSString *const kEventParentKey = @"parent";
static NSString *const kEventNameKey = @"eventName";
static NSString *const kEventDateKey = @"eventDate";
static NSString *const kEventLocationNameKey = @"eventLocationName";

// Parse API User key constants:
static NSString *const kUserNameKey = @"username";
static NSString *const kUserBirthdayKey = @"birthday";
static NSString *const kUserEmailKey = @"email";
static NSString *const kUserCheckedKey = @"checked";
static NSString *const kUserProfilePictureKey = @"profilePicture";
static NSString *const kUserCoverKey = @"cover";
static NSString *const kUserLocationNameKey = @"location";
// Parse API Participate key constants:
static NSString *const kParticipateClassKey = @"Participate";
static NSString *const kFriendInvited = @"friendInvited";
static NSString *const kParticipateEventID = @"eventID";
static NSString *const kParticipateEventHost = @"eventHost";
static NSString *const kParticipateInvitationStatus = @"invitationStatus";
static int const kParticipateJoin = 1;
static int const kParticipateDecline = 0;

//Design elemnts
static NSString *const NavBarBackground = @"top_bar2.png";
static NSString *const Background = @"finalBackground2.png";
//other constants
static NSString *const EventDateFormat = @"MMM dd, yyyy 'at' HH:mm";
static NSString *const EventHourFormat = @" HH:mm";
static NSString *const kCreatedAt = @"createdAt";


//notification names
static NSString* const CLocationChangeNotification= @"CLocationChangeNotification";
static NSString* const kEventLocationKey = @"location";

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <Parse/Parse.h>
#import <QuartzCore/QuartzCore.h>

@class iOSViewController;

@interface iOSAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) iOSViewController *viewController;

@property (nonatomic, retain) UINavigationController *navController;

@property (nonatomic, strong) CLLocation *currentLocation;

@end
