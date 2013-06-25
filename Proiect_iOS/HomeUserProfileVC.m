//
//  HomeUserProfileVC.m
//  Proiect_iOS
//
//  Created by Axelut Alex on 84//13.
//  Copyright (c) 2013 Axelut Alex. All rights reserved.
//

#import "HomeUserProfileVC.h"
#import "iOSAppDelegate.h"

@interface HomeUserProfileVC (){
    UIImage *FBProfileImage;
    UIImage *FBProfileCover;
    NSString *FBProfileName;
    int momentsNumber;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
- (void)initProfileInfoFacebook:(NSDictionary *)profileInfo;
- (void)viewDidLoad;

@end

@implementation HomeUserProfileVC

@synthesize profileCover;
@synthesize userNameLabel;
@synthesize profileImageView;
@synthesize userMomentsNumber;

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
   
    self.view.backgroundColor = [UIColor clearColor];
//    self.profileCover.image = FBProfileCover;
    self.profileImageView.image = FBProfileImage;
    self.userNameLabel.text = FBProfileName;
    
    self.profileImageView.layer.masksToBounds = YES;
    
    [self.profileCover.layer setContentsGravity:kCAGravityResizeAspectFill];
    self.profileCover.layer.masksToBounds = YES;
    
    if(momentsNumber != 0){
        self.userMomentsNumber.text = [NSString stringWithFormat:@"%i moments", momentsNumber];
    } else {
        self.userMomentsNumber.text = @"No moments tap + to create one";
    }
 //   [self.profileImageView.layer setBorderColor: [[UIColor grayColor] CGColor]];
 //   [self.profileImageView.layer setBorderWidth: 2.0];
    self.profileImageView.layer.cornerRadius = FBProfileImage.size.width/2;
    self.view.frame = CGRectMake(0.f, 0.f, 320.f, 150.f);
    
}

- (void)initProfileInfoFacebook:(NSDictionary *)profileInfo{

    FBProfileImage = [profileInfo objectForKey:kUserProfilePictureKey];
    FBProfileName = [profileInfo objectForKey:kUserNameKey];
    momentsNumber = 10;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
