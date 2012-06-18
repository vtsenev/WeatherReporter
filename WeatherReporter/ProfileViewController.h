//
//  ProfileViewController.h
//  WeatherReporter
//
//  Created by Vladimir Tsenev on 6/8/12.
//  Copyright (c) 2012 MentorMate. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewControllerDelegate.h"
#import "DatePickerControllerDelegate.h"
#import "PasswordViewControllerDelegate.h"
#import "SortOptionsDelegate.h"
@class User;

@interface ProfileViewController : UIViewController <LoginViewControllerDelegate, UITextFieldDelegate, DatePickerControllerDelegate, SortOptionsDelegate>

@property (nonatomic, retain) User *user;
@property (retain, nonatomic) IBOutlet UITextField *firstNameField;
@property (retain, nonatomic) IBOutlet UITextField *lastNameField;
@property (retain, nonatomic) IBOutlet UITextField *dateOfBirthField;
@property (retain, nonatomic) IBOutlet UITextField *passwordField;
@property (retain, nonatomic) IBOutlet UILabel *cityCountLabel;
@property (retain, nonatomic) IBOutlet UIButton *logoutBtn;
@property (retain, nonatomic) NSDate *birthdayDate;
@property (nonatomic) BOOL passwordChanged;
@property (retain, nonatomic) IBOutlet UITextField *sortByField;

- (IBAction)updateUserInfo:(id)sender;
- (IBAction)logoutUser:(id)sender;

@end
