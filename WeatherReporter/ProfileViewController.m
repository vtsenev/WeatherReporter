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
#import "JFBCrypt.h"
#import "DatePickerViewController.h"
#import "PasswordViewController.h"
#import "CustomAnimationUtilities.h"
#import "Constants.h"
#import "DataManager.h"

@interface ProfileViewController ()

- (void)updateView;
- (NSString *)hashPassword:(NSString *)password;

@end

@implementation ProfileViewController
@synthesize logoutBtn;
@synthesize user;
@synthesize firstNameField;
@synthesize lastNameField;
@synthesize dateOfBirthField;
@synthesize passwordField;
@synthesize cityCountLabel;
@synthesize birthdayDate;
@synthesize passwordChanged;
@synthesize sortingOption;
@synthesize sortingOptions;

- (void)dealloc {
    [birthdayDate release];
    [user release];
    [firstNameField release];
    [lastNameField release];
    [dateOfBirthField release];
    [passwordField release];
    [logoutBtn release];
    [cityCountLabel release];
    [sortingOptions release];
    [super dealloc];
}

- (void)viewDidUnload {
    [self setBirthdayDate:nil];
    [self setUser:nil];
    [self setFirstNameField:nil];
    [self setLastNameField:nil];
    [self setDateOfBirthField:nil];
    [self setPasswordField:nil];
    [self setLogoutBtn:nil];
    [self setCityCountLabel:nil];
    [self setSortingOptions:nil];
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
    self.passwordChanged = NO;
    self.birthdayDate = self.user.birthdayDate;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)updateUserInfo:(id)sender {
    [self.user setFirstName:self.firstNameField.text];
    [self.user setLastName:self.lastNameField.text];
    [self.user setBirthdayDate:self.birthdayDate];
    if (self.passwordChanged) {
        NSString *newPass = [self hashPassword:self.passwordField.text];
        [self.user setPassword:newPass];
    }
    if ([self.sortingOptions selectedSegmentIndex] == 0) {
        [[NSUserDefaults standardUserDefaults] setValue:sortByCity forKey:userDefaultsSortByKey];
    } else {
        [[NSUserDefaults standardUserDefaults] setValue:sortByCountry forKey:userDefaultsSortByKey];
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:profileUpdatedTitle message:profileUpdatedMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [alert release];
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
    
    [[DataManager defaultDataManager] saveChanges];
}

- (void)updateView {
    if (self.user) {
        [self.firstNameField setText:self.user.firstName];
        [self.lastNameField setText:self.user.lastName];

        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:dateFormat];
        [self.dateOfBirthField setText:[dateFormatter stringFromDate:self.user.birthdayDate]];
        [dateFormatter release];
        
        [self.cityCountLabel setText:[NSString stringWithFormat:@"%d", self.user.cities.count]];
        
        NSString *sortBy = [[NSUserDefaults standardUserDefaults] valueForKey:userDefaultsSortByKey];
        if (sortBy) {
            if ([sortBy isEqualToString:sortByCity]) {
                [self.sortingOptions setSelectedSegmentIndex:0];
            } else {
                [self.sortingOptions setSelectedSegmentIndex:1];
            }
        } else {
            [[NSUserDefaults standardUserDefaults] setValue:sortByDefault forKey:userDefaultsSortByKey];
            [self.sortingOptions setSelectedSegmentIndex:1];
        }
    }
}

- (NSString *)hashPassword:(NSString *)password {
    if (![password isEqualToString:emptyString] && password.length >= minPassLength) {
        NSString *salt = [JFBCrypt generateSaltWithNumberOfRounds:10];
        NSString *hashedPassword = [JFBCrypt hashPassword:password withSalt:salt];
        return hashedPassword;
    }
    return nil;
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

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    //If we begin editing in dateOfBirthField
    if(textField.tag == 1) { 
        [textField resignFirstResponder];
        DatePickerViewController* datePickerViewController = [[DatePickerViewController alloc] initWithNibName:@"DatePickerViewController" bundle:nil];
        datePickerViewController.delegate = self;
        [CustomAnimationUtilities appearView:datePickerViewController.view FromBottomOfView:self.view withHeight:480 withDuration:0.4];
    } 
    // If we begin editting the password field
    else if (textField.tag == 2) {
        PasswordViewController *passViewController = [[PasswordViewController alloc] initWithNibName:@"PasswordViewController" bundle:nil];
        passViewController.delegate = self;
        [CustomAnimationUtilities appearView:passViewController.view 
                            FromBottomOfView:self.navigationController.view withHeight:460 withDuration:0.4];
        
        self.passwordChanged = YES;
    }
}

#pragma mark - DatePickerViewController delegate methods

- (void)datePickerController:(id)datePickerViewController didPickDate:(NSDate *)date {
    self.birthdayDate = date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: dateFormat];
    self.dateOfBirthField.text = [dateFormatter stringFromDate:date];
    [dateFormatter release];
    
}

#pragma mark - PasswordViewController Delegate methods

- (void)confirmPassword:(NSString *)password {
    self.passwordField.text = password;
}

@end
