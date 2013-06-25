//
//  HomeUserProfileVC.h
//  Proiect_iOS
//
//  Created by Axelut Alex on 84//13.
//  Copyright (c) 2013 Axelut Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface HomeUserProfileVC : UIViewController

@property (nonatomic, retain) IBOutlet UIImageView *profileCover;
@property (nonatomic, retain) IBOutlet UIImageView *profileImageView;
@property (nonatomic, retain) IBOutlet UILabel *userNameLabel;
@property (nonatomic, retain) IBOutlet UILabel *userMomentsNumber;

- (void)initProfileInfoFacebook:(NSDictionary *)profileInfo;

@end

