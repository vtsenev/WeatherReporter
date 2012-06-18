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

- (void)shakeView:(UIView *)view onAngle:(NSInteger)angle;
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
        self.warningLabel.text = @"Password is too short. Minimum 4 chars!";
        [self shakeView:self.passwordView onAngle:5];
        self.passwordTextField.text = @""; 
        self.confirmPassTextField.text = @""; 
    }
    else if([ password isEqualToString:confirmPass]){
        self.warningLabel.text = @"";
        [CustomAnimationUtilities hideViewToBottom:self.view withHeight:480 withDuration:0.4];
        [self.delegate confirmPassword:password];
    }
    else {
        [self shakeView:self.passwordView onAngle:5];
        self.warningLabel.text = @"";
        self.passwordTextField.text = @""; 
        self.confirmPassTextField.text = @""; 
    }
        
}

- (void)shakeView:(UIView *)view onAngle:(NSInteger)angle{
    
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


- (void)shakeViewEnded:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context 
{
    if ([finished boolValue]) 
    {
        UIView* item = (UIView *)context;
        item.transform = CGAffineTransformIdentity;
    }
}
    




@end
