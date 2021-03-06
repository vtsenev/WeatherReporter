//
//  DatePickerViewController.m
//  WeatherReporter
//
//  Created by Vladimir Tsenev on 6/11/12.
//  Copyright (c) 2012 MentorMate. All rights reserved.
//

#import "DatePickerViewController.h"
#import "CustomAnimationUtilities.h"

@interface DatePickerViewController ()

@end

@implementation DatePickerViewController

@synthesize datePickerController, delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {}
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidUnload {
    [self setDatePickerController:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [datePickerController release];
    [super dealloc];
}

- (IBAction)cancelDatePicker:(id)sender {
    [CustomAnimationUtilities hideViewToBottom:self.view withHeight:480 withDuration:0.4];
}

- (IBAction)addDate:(id)sender {
    [self.delegate datePickerController:self didPickDate:[self.datePickerController date]];
    [CustomAnimationUtilities hideViewToBottom:self.view withHeight:480 withDuration:0.4];
}

@end
