//
//  WeatherTableViewController.h
//  WeatherReporter
//
//  Created by Vladimir Tsenev on 6/8/12.
//  Copyright (c) 2012 MentorMate. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewControllerDelegate.h"
#import "AddCityDelegate.h"

@class User;

@interface WeatherTableViewController : UITableViewController <UISearchBarDelegate, LoginViewControllerDelegate, AddCityDelegate>

@property (retain, nonatomic) User *user;

@end
