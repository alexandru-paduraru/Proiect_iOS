//
//  SearchChooseFriendsVC.m
//  Proiect_iOS
//
//  Created by Axelut Alex on 114//13.
//  Copyright (c) 2013 Axelut Alex. All rights reserved.
//

#import "SearchChooseFriendsVC.h"
#import "iOSAppDelegate.h"


@interface SearchChooseFriendsVC (){
    NSMutableArray *_data;
    NSArray *friends;
    NSArray *selectedFriends;
   // iOSAppDelegate *appDelegate;
    
    UIImageView *_headerImage;
    float _headerImageYOffset;
}
- (void)viewDidLoad;
- (void)okPressed;
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section;


@end

@implementation SearchChooseFriendsVC

@synthesize myTableView = _myTableView;
@synthesize delegate;

- (void)initWithUsers:(NSArray*)aUsers{
    friends = aUsers;
}

#pragma mark - Actions

- (void)okPressed{
    selectedFriends = [self.myTableView indexPathsForSelectedRows];
    if(selectedFriends){
        NSMutableString *friendsString = [NSMutableString stringWithFormat:@""];
        NSIndexPath *path;

        path = [selectedFriends objectAtIndex:0];
        NSUInteger index = [path indexAtPosition:[path length]-1];
        PFUser *friend = [friends objectAtIndex:index];
        [friendsString appendFormat:@"%@",[friend objectForKey:kUserNameKey]];
        
        if([self.delegate respondsToSelector:@selector(showSelectedFriendsFromTableView:numberOfInvitedFriends:)]){
            [self.delegate showSelectedFriendsFromTableView:friendsString numberOfInvitedFriends:[selectedFriends count]];
//            [self dismissModalViewControllerAnimated:YES];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)viewDidLoad
{
    
    //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _data = [[NSMutableArray alloc] initWithCapacity:8];
    for (int i = 0; i < 8; i++) {
        [_data addObject:@"fs"];
    }
//   self.myTableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    UIBarButtonItem *okButton = [[UIBarButtonItem alloc] initWithTitle:@"Ok" style:UIBarButtonItemStyleDone target:self action:@selector(okPressed)];
    self.navigationItem.rightBarButtonItem = okButton;
    selectedFriends = [[NSMutableArray alloc] init];
    self.myTableView.allowsMultipleSelection = YES;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(mockSearch:) userInfo:searchString repeats:NO];
    return NO;
}

- (void)mockSearch:(NSTimer*)timer
{
//    [_data removeAllObjects];
//    int count = 1 + random() % 20;
//    for (int i = 0; i < count; i++) {
//        [_data addObject:timer.userInfo];
//    }
    
    [self.searchDisplayController.searchResultsTableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [friends count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CellIdentifier";
    
    // Dequeue or create a cell of the appropriate type.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [NSString stringWithString:[[friends objectAtIndex:indexPath.row] objectForKey:kUserNameKey]];
    //de facut o lista globala cu informatii cache
    
    if([[[friends objectAtIndex:indexPath.row] objectForKey:kUserCheckedKey] intValue] == 1){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.myTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    if(!cell.imageView.image){
    // Configure the cell.
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        PFFile *image = [[friends objectAtIndex:indexPath.row] objectForKey:kUserProfilePictureKey];
        NSData *data = [image getData];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSLog(@"adaug imaginea din info server");
            cell.imageView.image = [UIImage imageWithData:data];
            [self.myTableView beginUpdates];
            [self.myTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil]
                                    withRowAnimation:UITableViewRowAnimationNone];
            [self.myTableView endUpdates];
        });
        
    });
    }
    else {
        NSLog(@"Imaginea exista, nu se face request!");
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    [[friends objectAtIndex:indexPath.row] setObject:[NSNumber numberWithInt:1] forKey:kUserCheckedKey];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
    [[friends objectAtIndex:indexPath.row] setObject:[NSNumber numberWithInt:0] forKey:kUserCheckedKey];

}

@end
