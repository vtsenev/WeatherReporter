//
//  PasswordViewController.m
//  WeatherReporter
//
//  Created by Victor Hristoskov on 6/13/12.
//  Copyright (c) 2012 MentorMate. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "PasswordViewController.h"
#import "CustomAnimationUtilities.h"
#import "Constants.h"


@interface PasswordViewController ()

- (void)shakeView:(UIView *)view onAngle:(NSInteger)angle;

@end

@implementation PasswordViewController

@synthesize passwordView;
@synthesize passwordTextField;
@synthesize confirmPassTextField;
@synthesize warningLabel;
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {}
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.passwordView.layer.cornerRadius = 15.0;
    self.passwordView.layer.masksToBounds = YES;
    
    // seems to look like a little bit better with this property
    // when the view is shaked 
    // self.passwordView.layer.shouldRasterize = YES;
}

- (void)viewDidUnload {
    [self setPasswordView:nil];
    [self setPasswordTextField:nil];
    [self setConfirmPassTextField:nil];
    [self setWarningLabel:nil];
    [self setDelegate:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [passwordView release];
    [passwordTextField release];
    [confirmPassTextField release];
    [warningLabel release];
    [delegate release];
    [super dealloc];
}

- (IBAction)cancelPassword:(id)sender {
    [CustomAnimationUtilities hideViewToBottom:self.view withHeight:480 withDuration:0.4];
}

- (IBAction)confirmPassword:(id)sender {
    
    NSString *password = self.passwordTextField.text;
    NSString *confirmPass = self.confirmPassTextField.text;
    
    if([password isEqualToString:emptyString] || [confirmPass isEqualToString:emptyString]) {
        self.warningLabel.text = missingFieldsError;
    }
    else if(password.length < minPassLength){
        [self passwordViewWithWarning:passwordTooShortError withClearContent:YES animated:YES];
    }
    else if([ password isEqualToString:confirmPass]) {
        self.warningLabel.text = emptyString;
        [CustomAnimationUtilities hideViewToBottom:self.view withHeight:480 withDuration:0.4];
        [self.delegate confirmPassword:password];
    }
    else {
        [self passwordViewWithWarning:@"" withClearContent:YES animated:YES];   
    }
}

- (void)shakeView:(UIView *)view onAngle:(NSInteger)angle {
    
    float radiansAngle = (angle / 180.0 * M_PI);
    
    CGAffineTransform leftRotate = CGAffineTransformMakeRotation( radiansAngle);
    CGAffineTransform rightRotate = CGAffineTransformMakeRotation(-radiansAngle);
    
    //rotate first to the left and then to the right 3 times
    //the rotation autoreverses
    view.transform = leftRotate;  
    [UIView beginAnimations:@"shakeView" context:view];
    //[UIView setAnimationRepeatAutoreverses:YES];
    [UIView setAnimationRepeatCount:3];
    [UIView setAnimationDuration:0.09];
    [UIView setAnimationDelegate:self];
    view.transform = rightRotate;
    
    //When finish set the view to it's identity posiotion
    [UIView setAnimationDidStopSelector:@selector(shakeViewEnded:finished:context:)];
    [UIView commitAnimations];
}

//- (void)shakeViewEnded:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
//    if ([finished boolValue]) {
//        UIView* item = (UIView *)context;
//        item.transform = CGAffineTransformIdentity;
//=======
- (void)passwordViewWithWarning:(NSString *)warning withClearContent:(BOOL)clearCont animated:(BOOL)animated{
    if(animated){
        [CustomAnimationUtilities shakeView:self.passwordView onAngle:5];        
    }
   
    if(clearCont){
        self.passwordTextField.text = emptyString; 
        self.confirmPassTextField.text = emptyString; 
    }
    self.warningLabel.text = warning;
}

@end
