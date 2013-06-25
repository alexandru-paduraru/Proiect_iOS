
#import "MyLogInViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface MyLogInViewController ()

@end

@implementation MyLogInViewController

@synthesize fieldsBackground = _fieldsBackground;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.logInView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"loginWall2.png"]]];
    
  
    [self.logInView setLogo:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logoBun.png"]]];

//    self.fieldsBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bUserPassInput.png"]];
//    
//    [self.logInView.signUpButton setBackgroundImage:[UIImage imageNamed:@"signupButton.png"] forState:UIControlStateNormal];
//    [self.logInView.signUpButton setBackgroundImage:[UIImage imageNamed:@"signupButtonHover.png"] forState:UIControlStateHighlighted];
//    [self.logInView.signUpButton setTitle:@"" forState:UIControlStateNormal];
//    [self.logInView.signUpButton setTitle:@"" forState:UIControlStateHighlighted];
//    
//    
//    
//    [self.logInView insertSubview:self.fieldsBackground atIndex:1];
//    // Remove text shadow
//    CALayer *layer = self.logInView.usernameField.layer;
//    
//    layer.shadowOffset = CGSizeMake(0.0, 1.0);
//    layer = self.logInView.passwordField.layer;
//    layer.shadowOffset = CGSizeMake(0.0, 1.0);
//    
//    
//    // Set field text color
//    [self.logInView.usernameField setTextColor:[UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0]];
//    [self.logInView.passwordField setTextColor:[UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0]];
//    
   // [self loginButtonTouchHandler];
}

- (void)viewDidLayoutSubviews {
    // Set frame for elements
    [self.logInView.dismissButton setFrame:CGRectMake(10, 10, 87.5, 45.5)];
    [self.logInView.logo setFrame:CGRectMake(0, 50, 320, 42)];
    [self.logInView.facebookButton setFrame:CGRectMake(50, 350, 226, 40)];
    [self.logInView.signUpButton setFrame:CGRectMake(95, 385, 128, 53)];
    [self.fieldsBackground setFrame:CGRectMake(33, 145, 243, 95)];
   // [self.logInView.signUpLabel setFrame:CGRectMake(90, 355, 140, 53)];
}

- (void)viewDidDisappear:(BOOL)animated{
    [self.delegate facebookLoginDone];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)logInViewController:(PFLogInViewController *)controller
               didLogInUser:(PFUser *)user {
    [self dismissModalViewControllerAnimated:YES];
    
}
- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    [self dismissModalViewControllerAnimated:YES];
}

@end
