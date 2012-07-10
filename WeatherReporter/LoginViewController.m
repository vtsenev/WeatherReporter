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
#import "Constants.h"

@interface LoginViewController ()

- (void)displayAlertWithTitle:(NSString *)alertTitle alertMessage:(NSString *)alertMessage;
- (void)rememberUser;
- (void)forgetUser;
- (NSString *)hashPassword:(NSString *)password forSalt:(NSString *)salt;

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
        [self.usernameField setText:emptyString];
        [self.passwordField setText:emptyString];
        [self.switchBtn setOn:NO];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)login:(id)sender {
    if ([self.usernameField.text isEqualToString:emptyString] || [self.passwordField.text isEqualToString:emptyString]) {
        [self displayAlertWithTitle:loginErrorType alertMessage:missingUsernameOrPasswordError];
        return;
    }
    User *user = [[DataManager defaultDataManager] fetchUserForUsername:self.usernameField.text];
    if (!user) {
        NSString *wrongUsername = [NSString stringWithFormat:@"Username: \"%@\" doesn't exist!", self.usernameField.text];
        [self displayAlertWithTitle:loginErrorType alertMessage:wrongUsername];
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
                        [self forgetUser];
                    }
                    
                    UITabBarController *tabBarController = (UITabBarController *)[self presentingViewController];
                    [tabBarController setSelectedIndex:0];
                    [self dismissModalViewControllerAnimated:YES];
                }
            } else {
                // password is wrong
                [self displayAlertWithTitle:loginErrorType alertMessage:wrongPasswordError];
            }
        } else {
            // salt is wrong or missing
            [self displayAlertWithTitle:loginErrorType alertMessage:wrongPasswordError];
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
    [[NSUserDefaults standardUserDefaults] setInteger:doRememberMe forKey:userDefaultsRememberMeKey];
}

- (void)forgetUser {
    [[NSUserDefaults standardUserDefaults] setValue:emptyString forKey:userDefaultsUsernameKey];
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:userDefaultsPasswordKey];
    [[NSUserDefaults standardUserDefaults] setInteger:dontRememberMe forKey:userDefaultsRememberMeKey];
}

- (NSString *)hashPassword:(NSString *)password forSalt:(NSString *)salt {
    if (![password isEqualToString:emptyString] && password.length >= minPassLength && salt.length == saltLength) {
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
    if (![self.usernameField.text isEqualToString:emptyString] && ![self.passwordField.text isEqualToString:emptyString] && textField.tag == 1) {
        [self login:self];
    }
}

# pragma mark - Register user delegate

- (void)newUserIsRegistered:(User *)user {
    self.usernameField.text = user.username;
    self.passwordField.text = emptyString;
}

@end
