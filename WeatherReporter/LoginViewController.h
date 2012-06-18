//
//  LoginViewController.h
//  WeatherReporter
//
//  Created by Vladimir Tsenev on 6/11/12.
//  Copyright (c) 2012 MentorMate. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewControllerDelegate.h"
#import "RegisterUserDelegate.h"

@class User;
@class WeatherTableViewController;

@interface LoginViewController : UIViewController <UITextFieldDelegate, RegisterUserDelegate>

@property (retain, nonatomic) IBOutlet UITextField *usernameField;
@property (retain, nonatomic) IBOutlet UITextField *passwordField;
@property (nonatomic, assign) id<LoginViewControllerDelegate> weatherTableViewControllerDelegate;
@property (nonatomic, assign) id<LoginViewControllerDelegate> profileViewControllerDelegate;
@property (retain, nonatomic) IBOutlet UISwitch *switchBtn;

- (IBAction)login:(id)sender;
- (IBAction)registerNewUser:(id)sender;

@end
