//
//  PasswordViewController.h
//  WeatherReporter
//
//  Created by Victor Hristoskov on 6/13/12.
//  Copyright (c) 2012 MentorMate. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PasswordViewControllerDelegate.h"

@interface PasswordViewController : UIViewController
@property (retain, nonatomic) IBOutlet UIView *passwordView;
@property (retain, nonatomic) IBOutlet UITextField *passwordTextField;
@property (retain, nonatomic) IBOutlet UITextField *confirmPassTextField;
@property (retain, nonatomic) IBOutlet UILabel *warningLabel;
@property (nonatomic, assign)id<PasswordViewControllerDelegate> delegate;

- (IBAction)cancelPassword:(id)sender;
- (IBAction)confirmPassword:(id)sender;
- (void) shakeToClearTextContentForView:(UIView *)view; 
@end
