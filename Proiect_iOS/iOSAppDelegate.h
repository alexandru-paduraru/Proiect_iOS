//
//  iOSAppDelegate.h
//  Proiect_iOS
//
//  Created by Axelut Alex on 203//13.
//  Copyright (c) 2013 Axelut Alex. All rights reserved.
//


// Parse API key constants:
static NSString *const PostsClassKey = @"Posts";
static NSString *const EventClassKey = @"Event";
static NSString *const EventCreatedByKey = @"createdBy";
static NSString *const EventNameKey = @"eventName";
static NSString *const EventDateKey = @"eventDate";
static NSString *const EventLocationNameKey = @"eventLocationName";

// Parse API User key constants:
static NSString *const UserNameKey = @"name";
static NSString *const UserBirthdayKey = @"birthday";
static NSString *const UserEmailKey = @"email";

//Design elemnts
static NSString *const NavBarBackground = @"top_bar2.png";
//other constants
static NSString *const EventDateFormat = @"MMM dd, yyyy 'at' HH:mm";

//notification names
static NSString* const CLocationChangeNotification= @"CLocationChangeNotification";
static NSString* const EventLocationKey = @"location";

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@class iOSViewController;

@interface iOSAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) iOSViewController *viewController;

@property (nonatomic, retain) UINavigationController *navController;

@property (nonatomic, strong) CLLocation *currentLocation;

@end
