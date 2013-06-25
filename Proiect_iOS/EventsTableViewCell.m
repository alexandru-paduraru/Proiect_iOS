//
//  EventsTableViewCell.m
//  Proiect_iOS
//
//  Created by Axelut Alex on 253//13.
//  Copyright (c) 2013 Axelut Alex. All rights reserved.
//

#import "EventsTableViewCell.h"
#import <QuartzCore/QuartzCore.h>
@implementation EventsTableViewCell

@synthesize nameLabel = _nameLabel;
@synthesize dateLabel = _dateLabel;
@synthesize locationLabel = _locationLabel;
@synthesize createdBy = _createdBy;
@synthesize eventProfilePicture = _eventProfilePicture;
@synthesize background;
@synthesize eventCover;

@synthesize activityIndicator;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}
- (void)viewDidLoad {
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
