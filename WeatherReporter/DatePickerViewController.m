//
//  DatePickerViewController.m
//  WeatherReporter
//
//  Created by Vladimir Tsenev on 6/11/12.
//  Copyright (c) 2012 MentorMate. All rights reserved.
//

#import "DatePickerViewController.h"

@interface DatePickerViewController ()
- (IBAction)removeFromSuperviewView:(id)sender;

@end

@implementation DatePickerViewController
@synthesize datePickerController, delegate;

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
    [self setDatePickerController:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [datePickerController release];
    [super dealloc];
}
- (IBAction)cancelDatePicker:(id)sender {
    
    [self hideToBottom];
//    [self.delegate dismissDatePickerView:self.view];
}

- (IBAction)addDate:(id)sender {
    
    [self.delegate datePickerController:self didPickDate:[self.datePickerController date]];
    [self hideToBottom];
    
}


#pragma mark - Appear/Disapear View animations

- (void)appearFromBottomOfVeiw:(UIView *)view{
    int height = 480;
    
    [view addSubview:self.view];
    
    CGRect viewFrame = self.view.frame;
    // Set the popup view's frame so that it is off the bottom of the screen
    viewFrame.origin.y = CGRectGetMaxY(self.view.bounds);
    self.view.frame  = viewFrame; 
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.4];
    viewFrame.origin.y -= height;
    self.view.frame = viewFrame;
    [UIView commitAnimations];
    
}
- (void)hideToBottom{
    
    CGRect viewFrame = self.view.frame;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.4];
    viewFrame.origin.y += 480;
    self.view.frame = viewFrame;
    [UIView commitAnimations];
    [self performSelector:@selector(removeFromSuperviewView:) withObject:self.view afterDelay:0.5];    
}

- (IBAction)removeFromSuperviewView:(id)sender {
    [sender removeFromSuperview]; 
}


@end
