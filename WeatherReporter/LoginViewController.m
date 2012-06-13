//
//  LoginViewController.m
//  WeatherReporter
//
//  Created by Vladimir Tsenev on 6/11/12.
//  Copyright (c) 2012 MentorMate. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterUserViewController.h"
#import "DataManager.h"
#import "User.h"
#import "WeatherTableViewController.h"
#import "ProfileViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize usernameField;
@synthesize passwordField;
@synthesize delegate;

- (void)dealloc {
    [usernameField release];
    [passwordField release];
    [super dealloc];
}

- (void)viewDidUnload {
    [self setUsernameField:nil];
    [self setPasswordField:nil];
    [super viewDidUnload];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self.navigationItem setTitle:@"Login"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)login:(id)sender {
    User *user = [[DataManager defaultDataManager] fetchUserForUsername:self.usernameField.text];
    if (!user) {
        
        NSString *wrongUsername = [NSString stringWithFormat:@"Username: \"%@\" doesn't exist!", self.usernameField.text];
        
        UIAlertView *wrongUserAllertView = [[UIAlertView alloc] initWithTitle:@"Wrong username" message:wrongUsername delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [wrongUserAllertView show];
        [wrongUserAllertView release];
        
        NSLog(@"Incorrect username!");
        
    } else {
        BOOL isPasswordCorrect = [user.password isEqualToString:self.passwordField.text]; // pass should be hashed
        if (isPasswordCorrect) {
            if ([self.delegate respondsToSelector:@selector(loginDidSucceedWithUser:)]) {
                [self.delegate loginDidSucceedWithUser:user];
                [self dismissModalViewControllerAnimated:YES];
                NSLog(@"Correct user data!");
            }
        } else {
            
            UIAlertView *wrongUserAllertView = [[UIAlertView alloc] initWithTitle:@"Wrong password" message:@"Incorrect Password!\n Try Again!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            [wrongUserAllertView show];
            [wrongUserAllertView release];
            
            NSLog(@"Incorrect user password!");
        }
    }
}

- (IBAction)registerNewUser:(id)sender {
    RegisterUserViewController *registerUserViewController = [[RegisterUserViewController alloc] initWithNibName:@"RegisterUserViewController" bundle:nil];
    [self.navigationController pushViewController:registerUserViewController animated:YES];
    [registerUserViewController release];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    BOOL success = [textField resignFirstResponder];
    return success;
}

@end
