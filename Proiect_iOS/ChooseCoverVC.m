
#import "ChooseCoverVC.h"
#import "EventsTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

@interface ChooseCoverVC (){
    UIBezierPath *headerMaskPath;
    NSURL *coverURL;
    NSMutableArray *coverImage, *coverTitle;
}

@end

@implementation ChooseCoverVC
@synthesize coverTableView = _coverTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)okPressed{
    if([self.delegate respondsToSelector:@selector(showSelectedCover:)]){
        [self.delegate showSelectedCover:coverURL];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)cancelPressed{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    coverImage = [[NSMutableArray alloc] initWithObjects:[NSURL URLWithString:@"http://www.mixmag.ro/wp-content/uploads/2011/03/kristal.jpg"],[NSURL URLWithString:@"http://newsair.ro/wp-content/uploads/new_york_skyline-wide.jpg"],[NSURL URLWithString:@"http://2.bp.blogspot.com/-8DJzYiftzeM/UL37vvr9NnI/AAAAAAAADuU/O1Ydi6g3fpQ/s1600/Romantic-Dinner-on-the-beach-1024-cropped1.jpg"],[NSURL URLWithString:@"http://www.eurobrandsindia.com/blog/wp-content/uploads/2010/08/business-meeting-india1.png"],[NSURL URLWithString:@"http://www.wallcoo.net/photography/coffee/wallpapers/1024x768/%5Bwallcoo%5D_coffee_Photo_073858.jpg"],[NSURL URLWithString:@"http://www.tea-time.ro/tea.jpg"], nil];
    coverTitle = [[NSMutableArray alloc] initWithObjects:@"Club",@"Town",@"Romantic place",@"Business meeting",@"Coffee",@"Tea", nil];
    
    
    self.title = [[NSString alloc] initWithFormat:@"Choose a cover"];
    UIBarButtonItem *okButton = [[UIBarButtonItem alloc] initWithTitle:@"Ok" style:UIBarButtonItemStyleDone target:self action:@selector(okPressed)];
    [okButton setTintColor:[UIColor grayColor]];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(cancelPressed)];
    [cancelButton setTintColor:[UIColor blackColor]];
    
    [self.navigationItem.backBarButtonItem setTintColor:[UIColor grayColor]];
    self.navigationItem.rightBarButtonItem = okButton;
    self.navigationItem.leftBarButtonItem = cancelButton;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 6;
}

- (UIView*)createCellFooter:(NSString *)status{
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(10, 159, 300, 30)];
    footer.backgroundColor = [UIColor whiteColor];
    footer.layer.shadowColor = [UIColor blackColor].CGColor;
    footer.layer.shadowOffset = CGSizeMake(0, 1);
    footer.layer.shadowOpacity = 0.1;
    
    footer.layer.borderColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.15].CGColor;
    footer.layer.borderWidth = 1.0f;
    footer.layer.shadowPath = [[UIBezierPath bezierPathWithRect:footer.bounds] CGPath
                               ];
    UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 280, 20)];
    [statusLabel setText:status];
    [statusLabel setTextColor:[UIColor grayColor]];
    [statusLabel setFont:[UIFont fontWithName: @"Helvetica" size: 16.0f]];
    
    [footer addSubview:statusLabel];
    
    return footer;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CellIdentifier";
    
    EventsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"EventsTableViewCell" owner:self options:nil];
        cell = (EventsTableViewCell*)[topLevelObjects objectAtIndex:0];
    }
    [cell.activityIndicator startAnimating];
    

    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 30, 300, 130)];
    imgView.backgroundColor = [UIColor whiteColor];
    
    imgView.layer.borderColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.15].CGColor;
    
    imgView.layer.borderWidth = 1.0;
    
    // Create the path (with only the top-left corner rounded)
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 300, 130)
                                                   byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerTopRight)
                                                         cornerRadii:CGSizeMake(5.0, 5.0)];
    
    CAShapeLayer *maskLayer2 = [CAShapeLayer layer];
    maskLayer2.frame = CGRectMake(0, 0, 300, 130);
    maskLayer2.path = maskPath.CGPath;
    imgView.layer.mask = maskLayer2;
    
    [imgView.layer setContentsGravity:kCAGravityResizeAspectFill];
    [imgView setAlpha:0.0];
    
    
    if(!imgView.image){
        // Configure the cell.
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            NSData *backgroundData = [NSData dataWithContentsOfURL:coverImage[indexPath.row]];
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                NSLog(@"adaug imaginea din info server");
                imgView.image = [UIImage imageWithData:backgroundData];
                //  [cell addSubview:imgView];
                [cell insertSubview:imgView atIndex:2];
                [UIView animateWithDuration:0.7 animations:^{
                    [imgView setAlpha:1.0];
                }];
                [cell.activityIndicator stopAnimating];
            });
        });
    }
    UIView *footer = [self createCellFooter:coverTitle[indexPath.row]];
    [cell insertSubview:footer atIndex:1];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    coverURL = coverImage[indexPath.row];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [cell setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"finalBackground2.png"]]];
}

@end
