
#import "iOSAppDelegate.h"
#import "iOSViewController.h"
#import <Parse/Parse.h>
#import <FacebookSDK/FacebookSDK.h>

@implementation iOSAppDelegate


@synthesize navController;
@synthesize currentLocation;

- (void)setCurrentLocation:(CLLocation *)aCurrentLocation
{
	currentLocation = aCurrentLocation;
    
	// Notify the app of the location change:
	NSDictionary *userInfo = [NSDictionary dictionaryWithObject:currentLocation forKey:@"location"];
	dispatch_async(dispatch_get_main_queue(), ^{
		[[NSNotificationCenter defaultCenter] postNotificationName:CLocationChangeNotification object:nil userInfo:userInfo];
	});
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [Parse setApplicationId:@"XZYQCrXBa77Q1AoQINpkrRE6KzMWXSaBwr9KtogM"
                  clientKey:@"Hw3czq11mVXE6GW2Nv1q83o9zjJpfDHxkeYzOO3f"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    [PFFacebookUtils initializeFacebook];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    UIViewController *rootView = [[iOSViewController alloc] initWithNibName:@"iOSViewController" bundle:nil];
    
    self.navController = [[UINavigationController alloc] initWithRootViewController:rootView];
    
    self.viewController = [[iOSViewController alloc] initWithNibName:@"iOSViewController" bundle:nil];
    self.window.rootViewController = self.navController;
    
    UINavigationBar *navBar = [[self navController] navigationBar];
    UIImage *backgroundImage = [UIImage imageNamed:NavBarBackground];
    [navBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    
    
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [PFFacebookUtils handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [PFFacebookUtils handleOpenURL:url];
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
