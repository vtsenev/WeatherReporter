//
//  PasswordViewController.m
//  WeatherReporter
//
//  Created by Victor Hristoskov on 6/13/12.
//  Copyright (c) 2012 MentorMate. All rights reserved.
//

#import "PasswordViewController.h"
#import "CustomAnimationUtilities.h"
#import <QuartzCore/QuartzCore.h>

@interface PasswordViewController ()

@end

@implementation PasswordViewController
@synthesize passwordView;
@synthesize passwordTextField;
@synthesize confirmPassTextField;
@synthesize warningLabel;
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.passwordView.layer.cornerRadius = 15.0;
    self.passwordView.layer.masksToBounds = YES;
    
    // seems to look like a little bit better with this property
    // when the view is shaked 
//    self.passwordView.layer.shouldRasterize = YES;
}

- (void)viewDidUnload
{
    [self setPasswordView:nil];
    [self setPasswordTextField:nil];
    [self setConfirmPassTextField:nil];
    [self setWarningLabel:nil];
    [self setDelegate:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
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
    
    if([password isEqualToString:@""] || [confirmPass isEqualToString:@""]){
        self.warningLabel.text = @"Please, fill in fields!";
    }
    else if(password.length < MIN_PASS_LENGTH){
        [self passwordViewWithWarning:@"Password is too short. Minimum 4 chars!" withClearContent:YES animated:YES];
    }
    else if([ password isEqualToString:confirmPass]){
        self.warningLabel.text = @"";
        [CustomAnimationUtilities hideViewToBottom:self.view withHeight:480 withDuration:0.4];
        [self.delegate confirmPassword:password];
    }
    else {
        [self passwordViewWithWarning:@"" withClearContent:YES animated:YES];   
    }
        
}

- (void)passwordViewWithWarning:(NSString *)warning withClearContent:(BOOL)clearCont animated:(BOOL)animated{
    if(animated){
        [CustomAnimationUtilities shakeView:self.passwordView onAngle:5];        
    }
   
    if(clearCont){
        self.passwordTextField.text = @""; 
        self.confirmPassTextField.text = @""; 
    }
    self.warningLabel.text = warning;
    
}
    




@end
