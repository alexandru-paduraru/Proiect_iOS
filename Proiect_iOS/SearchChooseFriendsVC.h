//
//  SearchChooseFriendsVC.h
//  Proiect_iOS
//
//  Created by Axelut Alex on 114//13.
//  Copyright (c) 2013 Axelut Alex. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@protocol SelectedFriendsDelegate <NSObject>
- (void)showSelectedFriendsFromTableView:(NSString*)firstFriendName numberOfInvitedFriends:(NSInteger)number;
@end

@interface SearchChooseFriendsVC : UIViewController<UISearchDisplayDelegate, UITableViewDataSource, UITableViewDelegate> {
    UITableView *_myTableView;
}
@property (nonatomic, retain) id<SelectedFriendsDelegate> delegate;
@property (nonatomic, retain) IBOutlet UITableView *myTableView;

- (void)initWithUsers:(NSArray*)aUsers;

@end

