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
@class User;

@interface AddCityViewController : UIViewController <UITextFieldDelegate, CountryPickerDelegate, CustomConnectionDelegate>

@property (nonatomic, retain) User *user;
@property (nonatomic, retain) City *city;
@property (nonatomic, assign) id<AddCityDelegate> delegate;

@end
