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
    NSString *defaultUsername = [[NSUserDefaults standardUserDefaults] valueForKey:@"username"];
    [self.usernameField setText:defaultUsername];
    NSString *password = [[NSUserDefaults standardUserDefaults] valueForKey:@"password"];
    [self.passwordField setText:password];
    NSInteger rememberMe = [[NSUserDefaults standardUserDefaults] integerForKey:@"rememberMe"];
    if (rememberMe == 1) {
        [self.switchBtn setOn:YES];
    } else {
        [self.switchBtn setOn:NO];
    }
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
            if ([self.weatherTableViewControllerDelegate respondsToSelector:@selector(loginDidSucceedWithUser:)]) {
                [self.weatherTableViewControllerDelegate loginDidSucceedWithUser:user];
                if ([self.profileViewControllerDelegate respondsToSelector:@selector(loginDidSucceedWithUser:)]) {
                    [self.profileViewControllerDelegate loginDidSucceedWithUser:user];
                }
                if (switchBtn.on) {
                    [self rememberUser];
                }
                UITabBarController *tabBarController = (UITabBarController *)[self presentingViewController];
                [tabBarController setSelectedIndex:0];
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

- (void)rememberUser {
    [[NSUserDefaults standardUserDefaults] setValue:self.usernameField.text forKey:@"username"];
    [[NSUserDefaults standardUserDefaults] setValue:self.passwordField.text forKey:@"password"];
    [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"rememberMe"];
}

# pragma mark - UITextFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    BOOL success = [textField resignFirstResponder];
    return success;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (![self.usernameField.text isEqualToString:@""] && ![self.passwordField.text isEqualToString:@""]) {
        [self login:nil];
    }
}

@end
