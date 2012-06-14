//
//  DetailedForecastViewController.m
//  WeatherReporter
//
//  Created by Vladimir Tsenev on 6/13/12.
//  Copyright (c) 2012 MentorMate. All rights reserved.
//

#import "DetailedForecastViewController.h"

@interface DetailedForecastViewController ()

- (void)refreshView;

@end

@implementation DetailedForecastViewController
@synthesize locationField;
@synthesize dateField;
@synthesize lowTempField;
@synthesize highTempField;
@synthesize detailedForecastView;
@synthesize weatherImageView;
@synthesize weatherPeriod;

- (void)dealloc {
    [weatherPeriod release];
    [locationField release];
    [dateField release];
    [lowTempField release];
    [highTempField release];
    [detailedForecastView release];
    [weatherImageView release];
    [super dealloc];
}

- (void)viewDidUnload {
    [self setWeatherPeriod:nil];
    [self setLocationField:nil];
    [self setDateField:nil];
    [self setLowTempField:nil];
    [self setHighTempField:nil];
    [self setDetailedForecastView:nil];
    [self setWeatherImageView:nil];
    [super viewDidUnload];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self refreshView];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)refreshView {
    [self.locationField setText:weatherPeriod.location];
    [self.dateField setText:weatherPeriod.date];
    [self.lowTempField setText:weatherPeriod.minTemp];
    [self.highTempField setText:weatherPeriod.maxTemp];
    [self.detailedForecastView setText:weatherPeriod.detailedForecast];
    
    NSURL *iconURL = [NSURL URLWithString:weatherPeriod.iconURL];
    NSData *iconData = [NSData dataWithContentsOfURL:iconURL];
    UIImage *weatherImage = [[UIImage alloc] initWithData:iconData];
    [self.weatherImageView setImage:weatherImage];
    [weatherImage release];
}

@end
