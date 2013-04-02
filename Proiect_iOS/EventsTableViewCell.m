//
//  EventsTableViewCell.m
//  Proiect_iOS
//
//  Created by Axelut Alex on 253//13.
//  Copyright (c) 2013 Axelut Alex. All rights reserved.
//

#import "EventsTableViewCell.h"

@implementation EventsTableViewCell

@synthesize nameLabel = _nameLabel;
@synthesize dateLabel = _dateLabel;
@synthesize locationLabel = _locationLabel;
@synthesize createdBy = _createdBy;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
