//
//  EventsTableViewController.h
//  Proiect_iOS
//
//  Created by Axelut Alex on 303//13.
//  Copyright (c) 2013 Axelut Alex. All rights reserved.
//

#import <Parse/Parse.h>

@interface EventsTableViewController : PFQueryTableViewController

- (void)initProfileInfoFacebook:(NSDictionary *)profileInfo;
@end
