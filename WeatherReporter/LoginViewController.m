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
#import "JFBCrypt.h"

NSString *const userDefaultsPasswordKey = @"password";
NSString *const userDefaultsUsernameKey = @"username";
NSString *const userDefaultsRememberMeKey = @"rememberMe";

@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize usernameField;
@synthesize passwordField;
@synthesize weatherTableViewControllerDelegate;
@synthesize profileViewControllerDelegate;
@synthesize switchBtn;

- (void)dealloc {
    [usernameField release];
    [passwordField release];
    [switchBtn release];
    [super dealloc];
}

- (void)viewDidUnload {
    [self setUsernameField:nil];
    [self setPasswordField:nil];
    [self setSwitchBtn:nil];
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
    NSInteger rememberMe = [[NSUserDefaults standardUserDefaults] integerForKey:userDefaultsRememberMeKey];
    if (rememberMe == 1) {
        NSString *defaultUsername = [[NSUserDefaults standardUserDefaults] valueForKey:userDefaultsUsernameKey];
        NSString *password = [[NSUserDefaults standardUserDefaults] valueForKey:userDefaultsPasswordKey];
        [self.switchBtn setOn:YES];
        [self.usernameField setText:defaultUsername];
        [self.passwordField setText:password];
    } else {
        [self.switchBtn setOn:NO];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)login:(id)sender {
    if ([self.usernameField.text isEqualToString:@""] || [self.passwordField.text isEqualToString:@""]) {
        [self displayAlertWithTitle:@"Login error" alertMessage:@"Enter your username and password."];
        return;
    }
    User *user = [[DataManager defaultDataManager] fetchUserForUsername:self.usernameField.text];
    if (!user) {
        NSString *wrongUsername = [NSString stringWithFormat:@"Username: \"%@\" doesn't exist!", self.usernameField.text];
        [self displayAlertWithTitle:@"Login error" alertMessage:wrongUsername];
        return;
    } else {
        NSString *salt = [user.password substringToIndex:29];
        NSString *hashedPassword = [self hashPassword:self.passwordField.text forSalt:salt];
        if (hashedPassword) {
            BOOL isPasswordCorrect = [user.password isEqualToString:hashedPassword];
            if (isPasswordCorrect) {
                if ([self.weatherTableViewControllerDelegate respondsToSelector:@selector(loginDidSucceedWithUser:)] &&
                    [self.profileViewControllerDelegate respondsToSelector:@selector(loginDidSucceedWithUser:)]) {

                    [self.weatherTableViewControllerDelegate loginDidSucceedWithUser:user];
                    [self.profileViewControllerDelegate loginDidSucceedWithUser:user];
                    
                    if (switchBtn.on) {
                        [self rememberUser];
                    } else {
                        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:userDefaultsRememberMeKey];
                    }
                    
                    UITabBarController *tabBarController = (UITabBarController *)[self presentingViewController];
                    [tabBarController setSelectedIndex:0];
                    [self dismissModalViewControllerAnimated:YES];
                }
            } else {
                [self displayAlertWithTitle:@"Login error" alertMessage:@"Incorrect Password!\n Try Again!"];
            }
        } else {
            [self displayAlertWithTitle:@"Login error" alertMessage:@"Incorrect Password!\n Try Again!"];
        }
    }
}

- (IBAction)registerNewUser:(id)sender {
    RegisterUserViewController *registerUserViewController = [[RegisterUserViewController alloc] initWithNibName:@"RegisterUserViewController" bundle:nil];
    registerUserViewController.delegate = self;
    [self.navigationController pushViewController:registerUserViewController animated:YES];
    [registerUserViewController release];
}

- (void)displayAlertWithTitle:(NSString *)alertTitle alertMessage:(NSString *)alertMessage {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertTitle message:alertMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [alert release];
}

- (void)rememberUser {
    [[NSUserDefaults standardUserDefaults] setValue:self.usernameField.text forKey:userDefaultsUsernameKey];
    [[NSUserDefaults standardUserDefaults] setValue:self.passwordField.text forKey:userDefaultsPasswordKey];
    [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:userDefaultsRememberMeKey];
}

- (NSString *)hashPassword:(NSString *)password forSalt:(NSString *)salt {
    if (![password isEqualToString:@""] && password.length >= MIN_PASS_LENGTH && salt.length == 29) {
        NSString *hashedPassword = [JFBCrypt hashPassword:password withSalt:salt];
        return hashedPassword;
    }
    
    return nil;
}

# pragma mark - UITextFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    BOOL success = [textField resignFirstResponder];
    return success;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (![self.usernameField.text isEqualToString:@""] && ![self.passwordField.text isEqualToString:@""] && textField.tag == 1) {
        [self login:nil];
    }
}

# pragma mark - Register user delegate

- (void)newUserIsRegistered:(User *)user {
    self.usernameField.text = user.username;
    self.passwordField.text = @"";
}

@end
