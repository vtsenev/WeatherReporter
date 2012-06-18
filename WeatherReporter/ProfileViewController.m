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
#import "SortOptionsViewController.h"

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
@synthesize birthdayDate;
@synthesize passwordChanged;
@synthesize sortByField;

- (void)dealloc {
    [birthdayDate release];
    [user release];
    [firstNameField release];
    [lastNameField release];
    [dateOfBirthField release];
    [passwordField release];
    [logoutBtn release];
    [cityCountLabel release];
    [sortByField release];
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
    [self setSortByField:nil];
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
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Info Updated!" message:@"User information is updated." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
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

- (NSString *)hashPassword:(NSString *)password {
    if (![password isEqualToString:@""] && password.length >= MIN_PASS_LENGTH) {
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
        [self appearFromBottomForView:datePickerViewController.view];
    } 
    // If we begin editting the password field
    else if (textField.tag == 2) {
        self.passwordChanged = YES;
    }
    // If we begin editting sortBy field
    else if (textField.tag == 3) {
        [textField resignFirstResponder];
        SortOptionsViewController *sortOptionsViewController = [[SortOptionsViewController alloc] initWithNibName:@"SortOptionsViewController" bundle:nil];
        sortOptionsViewController.delegate = self;
        [self appearFromBottomForView:sortOptionsViewController
         .view];
    }
}

#pragma mark - DatePickerViewController delegate methods

- (void)datePickerController:(id)datePickerViewController didPickDate:(NSDate *)date{
    self.birthdayDate = date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MMMM-dd"];
    self.dateOfBirthField.text = [dateFormatter stringFromDate:date];
    [dateFormatter release];
    
}

- (void)dismissDatePickerView:(UIView *)view{
    [self hideToBottomForView:view];
}

#pragma mark - Appear/Disapear View animations

- (void)hideToBottomForView:(UIView *)view{
    
    CGRect viewFrame = view.frame;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.4];
    viewFrame.origin.y += 480;
    view.frame = viewFrame;
    [UIView commitAnimations];
    [self performSelector:@selector(removeFromSuperviewView:) withObject:view afterDelay:0.5];    
}


- (IBAction)removeFromSuperviewView:(id)sender {
    [sender removeFromSuperview]; 
}

- (void)appearFromBottomForView:(UIView *)view{
    int height = 460;
    
    [self.view addSubview:view];
    
    CGRect viewFrame = view.frame;
    // Set the popup view's frame so that it is off the bottom of the screen
    viewFrame.origin.y = CGRectGetMaxY(self.view.bounds);
    view.frame  = viewFrame; 
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.4];
    viewFrame.origin.y -= height;
    view.frame = viewFrame;
    [UIView commitAnimations];
}

# pragma mark - SortingOptionsDelegate methods

- (void)didChooseSortingOption:(NSInteger)sortingOption {
    [self.sortByField setText:[NSString stringWithFormat:@"%i", sortingOption]];
    NSLog(@"%i", sortingOption);
}

- (void)dismissSortingOptionsView:(UIView *)view {
    [self hideToBottomForView:view];
}

@end
