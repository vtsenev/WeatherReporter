//
//  AddCityViewController.m
//  WeatherReporter
//
//  Created by Vladimir Tsenev on 6/11/12.
//  Copyright (c) 2012 MentorMate. All rights reserved.
//

#import "AddCityViewController.h"
#import "City.h"
#import "DataManager.h"

@interface AddCityViewController ()

@end

@implementation AddCityViewController
@synthesize city;
@synthesize cityNameField;
@synthesize countryField;
@synthesize latitudeField;
@synthesize longitudeField;
@synthesize delegate;

- (void)dealloc {
    [city release];
    [cityNameField release];
    [countryField release];
    [latitudeField release];
    [longitudeField release];
    [super dealloc];
}

- (void)viewDidUnload {
    [self setCity:nil];
    [self setCityNameField:nil];
    [self setCountryField:nil];
    [self setLatitudeField:nil];
    [self setLongitudeField:nil];
    [super viewDidUnload];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)addCity:(id)sender {
    [self updateCity];
    if ([self.delegate respondsToSelector:@selector(didUpdateCity:)]) {
        [self.delegate didUpdateCity:self.city];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)updateCity {
    self.city.name = self.cityNameField.text;
    self.city.country = self.countryField.text;
    self.city.latitude = [NSDecimalNumber decimalNumberWithString:self.latitudeField.text];
    self.city.longitude = [NSDecimalNumber decimalNumberWithString:self.longitudeField.text];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    BOOL success = [textField resignFirstResponder];
    return success;
}

@end
