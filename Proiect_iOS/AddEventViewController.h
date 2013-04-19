
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "SearchChooseFriendsVC.h"
#import <Parse/Parse.h>
#import <MapKit/MapKit.h>

@interface AddEventViewController : UIViewController <FBPlacePickerDelegate,
MKMapViewDelegate, SelectedFriendsDelegate>{
    IBOutlet UITextField *amountTextField;
    IBOutlet UILabel *coordinates;
    IBOutlet UITextField *eventName;
    UIDatePicker *_datePicker;
    CLLocationManager *_locationManager;
    UISearchDisplayController *_mySearchDisplayController;
    
}

@property (nonatomic) IBOutlet UIDatePicker *datePicker;
@property (nonatomic) IBOutlet UIButton *changeDateButton;
@property (nonatomic) IBOutlet UIButton *chooseALocationButton;
@property (nonatomic) IBOutlet UIButton *chooseYourEntourageButton;

@property (nonatomic,strong) IBOutlet MKMapView *addEventMap;
@property (nonatomic) UISearchDisplayController *mySearchDisplayController;

@end
