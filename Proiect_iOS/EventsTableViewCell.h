//
//  EventsTableViewCell.h
//  Proiect_iOS
//
//  Created by Axelut Alex on 253//13.
//  Copyright (c) 2013 Axelut Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventsTableViewCell : UITableViewCell{
    UILabel *_nameLabel;
    UILabel *_locationLabel;
    UILabel *_dateLabel;
    UILabel *_createdBy;
    UIImageView *_eventProfilePicture;
}

@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet UILabel *locationLabel;
@property (nonatomic, retain) IBOutlet UILabel *dateLabel;
@property (nonatomic, retain) IBOutlet UILabel *createdBy;
@property (nonatomic, retain) IBOutlet UIImageView *eventProfilePicture;
@property (nonatomic, retain) IBOutlet UIImageView *eventCover;
@property (nonatomic, retain) IBOutlet UIView *background;

@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;

@end
