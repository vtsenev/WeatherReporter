//
//  PasswordViewController.m
//  WeatherReporter
//
//  Created by Victor Hristoskov on 6/13/12.
//  Copyright (c) 2012 MentorMate. All rights reserved.
//

#import "PasswordViewController.h"

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
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
    
    [self.delegate dismissPasswordView:self.view];
    
}

- (IBAction)confirmPassword:(id)sender {
    
    NSString *password = self.passwordTextField.text;
    NSString *confirmPass = self.confirmPassTextField.text;
    
    if([password isEqualToString:@""] || [confirmPass isEqualToString:@""]){
        self.warningLabel.text = @"Please, fill in fields!";
    }
    else if([ password isEqualToString:confirmPass]){
        self.warningLabel.text = @"";
        [self.delegate dismissPasswordView:self.view];
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
    [UIView setAnimationDuration:0.1];
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
