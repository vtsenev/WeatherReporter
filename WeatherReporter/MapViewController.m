//
//  MapViewController.m
//  WeatherReporter
//
//  Created by Vladimir Tsenev on 6/11/12.
//  Copyright (c) 2012 MentorMate. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()

- (void)initializeMapView;

@end

@implementation MapViewController
@synthesize city;
@synthesize theMapView;

- (void)dealloc {
    [city release];
    [theMapView release];
    [super dealloc];
}

- (void)viewDidUnload {
    [self setCity:nil];
    [self setTheMapView:nil];
    [super viewDidUnload];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self initializeMapView];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)initializeMapView {    
    CLLocationCoordinate2D mapCenter = CLLocationCoordinate2DMake([self.city.latitude doubleValue], [self.city.longitude doubleValue]);
    MKCoordinateSpan mapSpan = MKCoordinateSpanMake(0.200, 0.200);
    MKCoordinateRegion mapRegion = MKCoordinateRegionMake(mapCenter, mapSpan);
    
    self.theMapView.region = mapRegion;
    self.theMapView.mapType = MKMapTypeHybrid;
    self.theMapView.userTrackingMode = YES;
}

@end
