//
//  RegisterUserViewController.m
//  WeatherReporter
//
//  Created by Vladimir Tsenev on 6/11/12.
//  Copyright (c) 2012 MentorMate. All rights reserved.
//

#import "RegisterUserViewController.h"
#import "DatePickerViewController.h"
#import "PasswordViewController.h"
#import "DataManager.h"
#import "User.h"
#import "JFBCrypt.h"

@interface RegisterUserViewController ()
- (IBAction)removeFromSuperviewView:(id)sender;
- (void) showPasswordView;
@end

@implementation RegisterUserViewController
@synthesize scrollView;
@synthesize usernameField;
@synthesize firstnameField;
@synthesize lastnameField;
@synthesize dateOfBirthField;
@synthesize passwordField, confirmPasswordField;
@synthesize user;
@synthesize birthdayDate;
@synthesize delegate;

- (void)dealloc {
    [user release];
    [passwordField release];
    [confirmPasswordField release];
    [usernameField release];
    [firstnameField release];
    [lastnameField release];
    [dateOfBirthField release];
    [birthdayDate release];
    [scrollView release];
    [super dealloc];
}

- (void)viewDidUnload {
    [self setUser:nil];
    [self setPasswordField:nil];
    [self setConfirmPasswordField:nil];
    [self setUsernameField:nil];
    [self setFirstnameField:nil];
    [self setLastnameField:nil];
    [self setDateOfBirthField:nil];
    [self setBirthdayDate:nil];
    [self setScrollView:nil];
    [super viewDidUnload];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self.navigationItem setTitle:@"Register"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.scrollView.contentSize = self.view.frame.size;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)registerNewUser:(id)sender {
    
    if ([self.usernameField.text isEqualToString:@""] || [self.firstnameField.text isEqualToString:@""] ||
            [self.lastnameField.text isEqualToString:@""] || [self.dateOfBirthField.text isEqualToString:@""]){
        
        UIAlertView *emptyRequiredAllertView = [[UIAlertView alloc] initWithTitle:@"Empty Required Fileds!" message:@"Please fill in required fields!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [emptyRequiredAllertView show];
        [emptyRequiredAllertView release];
    }
    else{
        
        BOOL isUsernameExists = [[DataManager defaultDataManager] checkIfUserExistsWithUsername:self.usernameField.text];
        
        if (isUsernameExists) {
            
            NSString *existingUsername = [NSString stringWithFormat:@"Username: \"%@\" already exists!", self.usernameField.text];
            
            UIAlertView *existingUsernameAllertView = [[UIAlertView alloc] initWithTitle:@"Username Already Exists" message:existingUsername delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            [existingUsernameAllertView show];
            [existingUsernameAllertView release];
            
            NSLog(@"Incorrect username!");
            
        } else {
            
            [self showPasswordView];
//            [self displayPasswordAlertView];
        }
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    BOOL success = [textField resignFirstResponder];
    return success;
}

- (void)displayPasswordAlertView {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please Login" message:@""
                                                   delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Submit", nil];
    
    alert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    [[alert textFieldAtIndex:0] setPlaceholder:@"password"];
    [[alert textFieldAtIndex:0] setSecureTextEntry:YES];
    [[alert textFieldAtIndex:1] setPlaceholder:@"confirm password"];
    
    [alert show];
}

- (void)showPasswordView{
    
    PasswordViewController *passViewController = [[PasswordViewController alloc] initWithNibName:@"PasswordViewController" bundle:nil];
    passViewController.delegate = self;
    [self appearFromBottomForView:passViewController.view];
}

#pragma mark - Appear/Disapear View animations

- (void)appearFromBottomForView:(UIView *)view{
    int height = 480;
    
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


#pragma mark - PasswordViewController Delegate Methods

- (void)dismissPasswordView:(UIView *)view{
    
    [self hideToBottomForView:view];
}

- (void)confirmPassword:(NSString *)password{
    
    User *newUser = [[DataManager defaultDataManager] addUser];
    
    newUser.username = self.usernameField.text;
    newUser.firstName = self.firstnameField.text;
    newUser.lastName = self.lastnameField.text;
    newUser.birthdayDate = self.birthdayDate;
    
    self.user = newUser;

    self.user.password = [self hashPassword:password];
    NSLog(@" Inserted user: %@, %@, %@, %@, %@", user.username, user.firstName, user.lastName, user.birthdayDate, user.password);
    [self.navigationController popViewControllerAnimated:YES];
    if ([self.delegate respondsToSelector:@selector(newUserIsRegistered:)]) {
        [self.delegate newUserIsRegistered:self.user];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    //If we begin editing in dateOfBirthField
    if(textField.tag == 1)
    { 
        [textField resignFirstResponder];
        DatePickerViewController* datePickerViewController = [[DatePickerViewController alloc] initWithNibName:@"DatePickerViewController" bundle:nil];
        datePickerViewController.delegate = self;
        [self appearFromBottomForView:datePickerViewController.view];
    }
    
}

- (NSString *)hashPassword:(NSString *)password {
    if (![password isEqualToString:@""] && password.length >= MIN_PASS_LENGTH) {
        NSString *salt = [JFBCrypt generateSaltWithNumberOfRounds: 10];
        NSString *hashedPassword = [JFBCrypt hashPassword: password withSalt: salt];
        return hashedPassword;
    }
    return nil;
}

@end
