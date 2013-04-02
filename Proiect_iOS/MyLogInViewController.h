//
//  MyLogInViewController.h
//  Proiect_iOS
//
//  Created by Axelut Alex on 233//13.
//  Copyright (c) 2013 Axelut Alex. All rights reserved.
//

#import <Parse/Parse.h>

@interface MyLogInViewController : PFLogInViewController{
    UIImageView *_fieldsBackground;
}

@property (nonatomic,retain) UIImageView *fieldsBackground;
@end
