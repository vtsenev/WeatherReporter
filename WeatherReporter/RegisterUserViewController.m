//
//  RegisterUserViewController.m
//  WeatherReporter
//
//  Created by Vladimir Tsenev on 6/11/12.
//  Copyright (c) 2012 MentorMate. All rights reserved.
//

#import "RegisterUserViewController.h"
#import "DatePickerViewController.h"
#import "DataManager.h"
#import "User.h"

@interface RegisterUserViewController ()

@end

@implementation RegisterUserViewController
@synthesize usernameField;
@synthesize firstnameField;
@synthesize lastnameField;
@synthesize dateOfBirthField;
@synthesize passwordField, confirmPasswordField;
@synthesize user;
@synthesize birthdayDate;

- (void)dealloc {
    [user release];
    [passwordField release];
    [confirmPasswordField release];
    [usernameField release];
    [firstnameField release];
    [lastnameField release];
    [dateOfBirthField release];
    [birthdayDate release];
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
            
            User *newUser = [[DataManager defaultDataManager] addUser];
            
            newUser.username = self.usernameField.text;
            newUser.firstName = self.firstnameField.text;
            newUser.lastName = self.lastnameField.text;
            newUser.birthdayDate = self.birthdayDate;
            
            self.user = newUser;
            [self displayPasswordAlertView];
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

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != [alertView cancelButtonIndex]) {
        if ([[[alertView textFieldAtIndex:0] text] isEqualToString:[[alertView textFieldAtIndex:1] text]]) {
            user.password = [[alertView textFieldAtIndex:0] text];
            [[DataManager defaultDataManager] updateUser:user];
            
            NSLog(@" Inserted user: %@, %@, %@, %@, %@", user.username, user.firstName, user.lastName, user.birthdayDate, user.password);
            
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [alertView setTitle:@"Passwords do not match"];
        }
    }
}

- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView {
    UITextField *textField = [alertView textFieldAtIndex:0];
    if ([textField.text length] == 0) {
        return NO;
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    //If we begin editing in dateOfBirthField
    if(textField.tag == 1)
    {
        [textField resignFirstResponder];
        DatePickerViewController* datePickerViewController = [[DatePickerViewController alloc] initWithNibName:@"DatePickerViewController" bundle:nil];
        datePickerViewController.delegate = self;
        [self presentModalViewController:datePickerViewController animated:YES];
    }
    
}

- (void)datePickerController:(DatePickerViewController *)datePickerViewController didPickDate:(NSDate *)date
{
    self.birthdayDate = date;
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MMMM-dd"];
    self.dateOfBirthField.text = [dateFormatter stringFromDate:date];
    [dateFormatter release];
}

@end
