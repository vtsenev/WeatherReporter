//
//  LoginViewController.h
//  WeatherReporter
//
//  Created by Vladimir Tsenev on 6/11/12.
//  Copyright (c) 2012 MentorMate. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewControllerDelegate.h"

@class User;
@class WeatherTableViewController;

@interface LoginViewController : UIViewController <UITextFieldDelegate>

@property (retain, nonatomic) IBOutlet UITextField *usernameField;
@property (retain, nonatomic) IBOutlet UITextField *passwordField;
@property (nonatomic, assign) id<LoginViewControllerDelegate> weatherTableViewControllerDelegate;
@property (nonatomic, assign) id<LoginViewControllerDelegate> profileViewControllerDelegate;

- (IBAction)login:(id)sender;
- (IBAction)registerNewUser:(id)sender;

@end
