//
//  RegisterUserViewController.h
//  WeatherReporter
//
//  Created by Vladimir Tsenev on 6/11/12.
//  Copyright (c) 2012 MentorMate. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatePickerControllerDelegate.h"
#import "PasswordViewControllerDelegate.h"
#import "RegisterUserDelegate.h"

@class User;

@interface RegisterUserViewController : UIViewController <UITextFieldDelegate, UIAlertViewDelegate,
                                        DatePickerControllerDelegate, PasswordViewControllerDelegate>

@property (retain, nonatomic) User *user;
@property (retain, nonatomic) NSDate *birthdayDate;

@property (retain, nonatomic) IBOutlet UITextField *usernameField;
@property (retain, nonatomic) IBOutlet UITextField *firstnameField;
@property (retain, nonatomic) IBOutlet UITextField *lastnameField;
@property (retain, nonatomic) IBOutlet UITextField *dateOfBirthField;

@property (retain, nonatomic) UITextField *passwordField;
@property (retain, nonatomic) UITextField *confirmPasswordField;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic, assign) BOOL keyboardVisible;
@property (assign) id<RegisterUserDelegate> delegate;

- (IBAction)registerNewUser:(id)sender;

- (void)keyboardDidShow:(NSNotification *)notif;
- (void)keyboardDidHide:(NSNotification *)notif;

@end
