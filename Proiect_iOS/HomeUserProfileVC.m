//
//  HomeUserProfileVC.m
//  Proiect_iOS
//
//  Created by Axelut Alex on 84//13.
//  Copyright (c) 2013 Axelut Alex. All rights reserved.
//

#import "HomeUserProfileVC.h"

@interface HomeUserProfileVC ()

@end

@implementation HomeUserProfileVC

@synthesize profileCover;
@synthesize userNameLabel;
@synthesize profileImageView;

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
    // Do any additional setup after loading the view from its nib.
    [self.profileImageView.layer setBorderColor: [[UIColor whiteColor] CGColor]];
    [self.profileImageView.layer setBorderWidth: 2.0];
   
}
- (void)initWithPictureAndCover{
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
