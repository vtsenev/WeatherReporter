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
#import "CustomAnimationUtilities.h"
#import "DataManager.h"
#import "User.h"
#import "JFBCrypt.h"
#import "Constants.h"

@interface RegisterUserViewController ()

- (void) showPasswordView;
- (NSString *)hashPassword:(NSString *)password;
- (IBAction)registerNewUser:(id)sender;

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
@synthesize keyboardVisible;

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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    keyboardVisible = NO;
}

-(void) viewWillDisappear:(BOOL)animated{

    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewWillDisappear:animated];
    
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)registerNewUser:(id)sender {
    
    if ([self.usernameField.text isEqualToString:emptyString] || [self.firstnameField.text isEqualToString:emptyString] ||
            [self.lastnameField.text isEqualToString:emptyString] || [self.dateOfBirthField.text isEqualToString:emptyString]){
        
        [self displayAlertWithTitle:requeredFieldAreEmptyError alertMessage:missingFieldsError];
    }
    else{
        BOOL isUsernameExists = [[DataManager defaultDataManager] checkIfUserExistsWithUsername:self.usernameField.text];
        if (isUsernameExists) {
            
            NSString *existingUsername = [NSString stringWithFormat:@"Username: \"%@\" already exists!", self.usernameField.text];
            [self displayAlertWithTitle:userWithThisUsernameExistsError alertMessage:existingUsername];
            NSLog(@"Incorrect username!");
        } else {   
            [self showPasswordView];
        }
    }
}

- (void)displayAlertWithTitle:(NSString *)alertTitle alertMessage:(NSString *)alertMessage {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertTitle message:alertMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [alert release];
}

- (void)showPasswordView {
    
    PasswordViewController *passViewController = [[PasswordViewController alloc] initWithNibName:@"PasswordViewController" bundle:nil];
    passViewController.delegate = self;
    [CustomAnimationUtilities appearView:passViewController.view 
                        FromBottomOfView:self.navigationController.view withHeight:480 withDuration:0.4];

}

#pragma mark - DatePickerViewController delegate methods

- (void)datePickerController:(id)datePickerViewController didPickDate:(NSDate *)date {
    self.birthdayDate = date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateFormat];
    self.dateOfBirthField.text = [dateFormatter stringFromDate:date];
    [dateFormatter release];

}

#pragma mark - PasswordViewController Delegate Methods

- (void)confirmPassword:(NSString *)password {
    
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

#pragma mark - UITextFieldDelegate methods

//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
//    if(textField.tag == 1)
//    { 
//        [self.view endEditing:YES];
//        DatePickerViewController* datePickerViewController = [[DatePickerViewController alloc] initWithNibName:@"DatePickerViewController" bundle:nil];
//        datePickerViewController.delegate = self;
//        [CustomAnimationUtilities appearView:datePickerViewController.view FromBottomOfView:self.navigationController.view withHeight:480 withDuration:0.4];
//        return YES;
//    }
//    return YES;
//}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    BOOL success = [textField resignFirstResponder];
    return success;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if(textField.tag == 1){
        for(UIView *subView in self.scrollView.subviews){
            if([subView isKindOfClass:[UITextField class]] && subView.isFirstResponder){// && (subView.tag !=1)){
                [subView resignFirstResponder];
            }
        }
        DatePickerViewController* datePickerViewController = [[DatePickerViewController alloc] initWithNibName:@"DatePickerViewController" bundle:nil];
        datePickerViewController.delegate = self;
        [CustomAnimationUtilities appearView:datePickerViewController.view FromBottomOfView:self.navigationController.view withHeight:480 withDuration:0.4];
        
        return YES;
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    NSLog(@"sad");
    //If we begin editing in dateOfBirthField
    if(textField.tag == 1){
        [textField resignFirstResponder];
    }
}

#pragma mark - Private methods

- (NSString *)hashPassword:(NSString *)password {
    if (![password isEqualToString:emptyString] && password.length >= minPassLength) {
        NSString *salt = [JFBCrypt generateSaltWithNumberOfRounds:10];
        NSString *hashedPassword = [JFBCrypt hashPassword:password withSalt:salt];
        return hashedPassword;
    }
    return nil;
}

#pragma mark - Keyboard handlers

-(void)keyboardDidShow:(NSNotification *)notif
{
    if(keyboardVisible)
    {
        return;
    }
    
    //Get the origin of the keyboard when it sinishes animating
    NSDictionary* info = [notif userInfo ]; 
    NSValue* aValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey ];
    
    //Get the top of the keyboard in view's coordinate system.
    //We need to set the bottom of the scroll view to line up with it
    
    CGRect keyboardRect = [aValue CGRectValue ];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil ];
    CGFloat keyboardTop = keyboardRect.origin.y;        
    //Resize the scroll view to make room for the keyboard
    
    CGRect viewFrame = self.view.bounds;
    viewFrame.size.height = keyboardTop - self.view.bounds.origin.y;    
    self.scrollView.frame = viewFrame;
    keyboardVisible = YES; 
    
    
}

-(void)keyboardDidHide:(NSNotification *)notif{
    if(!keyboardVisible){
        return;        
    }
    
    //Resize the scroll view back to the full size of our view
    self.scrollView.frame = self.view.bounds;
    keyboardVisible = NO;
    
}
@end
