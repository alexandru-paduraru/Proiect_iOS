//
//  PlacePickerViewController.h
//  Proiect_iOS
//
//  Created by Axelut Alex on 54//13.
//  Copyright (c) 2013 Axelut Alex. All rights reserved.
//

@protocol PlacePickerDelegate
@optional
-(void)selectedLocation:(id)object;
@end
#import <FacebookSDK/FacebookSDK.h>

@interface PlacePickerViewController : FBPlacePickerViewController

@end
