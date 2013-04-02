
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <Parse/Parse.h>

@protocol AddEventDelegate @optional
    -(void)amountEntered:(NSInteger)amount;
@end


@interface AddEventViewController : UIViewController <CLLocationManagerDelegate>{
    IBOutlet UITextField *amountTextField;
    IBOutlet UILabel *coordinates;
    IBOutlet UITextField *eventName;
//    IBOutlet UITextField *eventDate;
    UIDatePicker *_datePicker;
    CLLocationManager *_locationManager;
    
}
@property (nonatomic,weak) id <AddEventDelegate> delegate;
@property (nonatomic) IBOutlet UIDatePicker *datePicker;
@property (nonatomic) IBOutlet UIButton *changeDateButton;

- (IBAction)backgroundClicked;
- (IBAction)changeDatePressed:(UIButton*)sender;
- (IBAction)cancelPressed;
- (IBAction)savePressed;



@end
