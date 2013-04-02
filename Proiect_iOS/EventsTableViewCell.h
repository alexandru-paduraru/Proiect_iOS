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
}

@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet UILabel *locationLabel;
@property (nonatomic, retain) IBOutlet UILabel *dateLabel;
@property (nonatomic, retain) IBOutlet UILabel *createdBy;

@end