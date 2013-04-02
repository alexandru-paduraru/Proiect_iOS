//
//  iOSAppDelegate.h
//  Proiect_iOS
//
//  Created by Axelut Alex on 203//13.
//  Copyright (c) 2013 Axelut Alex. All rights reserved.
//
#import <UIKit/UIKit.h>


@class iOSViewController;

@interface iOSAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) iOSViewController *viewController;

@property (nonatomic, retain) UINavigationController *navController;

@end
