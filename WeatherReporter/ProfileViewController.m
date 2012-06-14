//
//  ProfileViewController.m
//  WeatherReporter
//
//  Created by Vladimir Tsenev on 6/8/12.
//  Copyright (c) 2012 MentorMate. All rights reserved.
//

#import "ProfileViewController.h"
#import "User.h"
#import "LoginViewController.h"
#import "WeatherTableViewController.h"

@interface ProfileViewController ()

- (void)updateView;

@end

@implementation ProfileViewController
@synthesize logoutBtn;
@synthesize user;
@synthesize firstNameField;
@synthesize lastNameField;
@synthesize dateOfBirthField;
@synthesize passwordField;
@synthesize cityCountLabel;

- (void)dealloc {
    [user release];
    [firstNameField release];
    [lastNameField release];
    [dateOfBirthField release];
    [passwordField release];
    [logoutBtn release];
    [cityCountLabel release];
    [super dealloc];
}

- (void)viewDidUnload {
    [self setUser:nil];
    [self setFirstNameField:nil];
    [self setLastNameField:nil];
    [self setDateOfBirthField:nil];
    [self setPasswordField:nil];
    [self setLogoutBtn:nil];
    [self setCityCountLabel:nil];
    [super viewDidUnload];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UIImage *tabBarImage = [UIImage imageNamed:@"profile.png"];
        [self.tabBarItem setImage:tabBarImage];
        
        [self.navigationItem setTitle:@"Profile"];
        [self.tabBarItem setTitle:@"Edit Profile"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateView];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)updateUserInfo:(id)sender {
    [self.user setFirstName:self.firstNameField.text];
    [self.user setLastName:self.lastNameField.text];
//  set user birthday date
    [self.user setPassword:self.passwordField.text];
}

- (IBAction)logoutUser:(id)sender {
    LoginViewController *loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    
    loginViewController.profileViewControllerDelegate = self;
    UINavigationController *weatherNavController = [self.tabBarController.viewControllers objectAtIndex:0];
    WeatherTableViewController *weatherTableViewController = (WeatherTableViewController *)[[weatherNavController viewControllers] objectAtIndex:0];
    loginViewController.weatherTableViewControllerDelegate = weatherTableViewController;
    
    self.user = nil;
    weatherTableViewController.user = nil;
    weatherTableViewController.tableData = nil;
    
    UINavigationController *loginNavigationController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
    [loginViewController release];
    
    [loginNavigationController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self presentViewController:loginNavigationController animated:YES completion:NULL];
    [loginNavigationController release];
}

- (void)updateView {
    if (self.user) {
        [self.firstNameField setText:self.user.firstName];
        [self.lastNameField setText:self.user.lastName];

        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat: @"yyyy-MMMM-dd"];
        [self.dateOfBirthField setText:[dateFormatter stringFromDate:self.user.birthdayDate]];
        [dateFormatter release];
        
        [self.cityCountLabel setText:[NSString stringWithFormat:@"%d", self.user.cities.count]];
    }
}

# pragma mark - LoginViewControllerDelegate methods

- (void)loginDidSucceedWithUser:(User *)theUser {
    self.user = theUser;
    [self updateView];
}

# pragma mark - UITextFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    BOOL success = [textField resignFirstResponder];
    return success;
}

@end
