//
//  EventsTableVC.h
//  Proiect_iOS
//
//  Created by Axelut Alex on 214//13.
//  Copyright (c) 2013 Axelut Alex. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface EventsTableVC : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) IBOutlet UITableView *myTableView;

-(void)initWithEvents:(NSArray*)aEvents;
-(void)initProfileInfoFacebook:(NSDictionary *)profileInfo;

@end
