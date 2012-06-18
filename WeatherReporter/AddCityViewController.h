//
//  AddCityViewController.h
//  WeatherReporter
//
//  Created by Vladimir Tsenev on 6/11/12.
//  Copyright (c) 2012 MentorMate. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddCityDelegate.h"
#import "CountryPickerDelegate.h"
#import "CustomConnectionDelegate.h"

@class City;

@interface AddCityViewController : UIViewController <UITextFieldDelegate, CountryPickerDelegate, CustomConnectionDelegate>

@property (nonatomic, retain) City *city;
@property (retain, nonatomic) IBOutlet UITextField *cityNameField;
@property (retain, nonatomic) IBOutlet UITextField *countryField;
@property (retain, nonatomic) IBOutlet UITextField *latitudeField;
@property (retain, nonatomic) IBOutlet UITextField *longitudeField;
@property (nonatomic, assign) id<AddCityDelegate> delegate;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;
@property (retain, nonatomic) IBOutlet UIButton *getLocationBtn;
@property (nonatomic) BOOL isCityFound;

- (IBAction)addCity:(id)sender;
- (IBAction)getLocation:(id)sender;

@end
