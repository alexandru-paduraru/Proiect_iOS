//
//  PlacePickerViewController.m
//  Proiect_iOS
//
//  Created by Axelut Alex on 54//13.
//  Copyright (c) 2013 Axelut Alex. All rights reserved.
//

#import "PlacePickerViewController.h"
#import "iOSAppDelegate.h"

@interface PlacePickerViewController ()
- (void)viewDidLoad;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;

@end

@implementation PlacePickerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Set the place picker title
        self.title = @"Pick Places";
        
        // Configure the additional search parameters
        self.radiusInMeters = 500;
        self.resultsLimit = 50;   
        self.searchText = @"restaurant";
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self loadData];
    UINavigationBar *navBar = [[self navigationController] navigationBar];
    UIImage *backgroundImage = [UIImage imageNamed:NavBarBackground];
    [navBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
