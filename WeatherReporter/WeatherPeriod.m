//
//  WeatherPeriod.m
//  WeatherReporter
//
//  Created by Vladimir Tsenev on 6/11/12.
//  Copyright (c) 2012 MentorMate. All rights reserved.
//

#import "WeatherPeriod.h"

@implementation WeatherPeriod

@synthesize location, currentTemp, minTemp, maxTemp, date, conditions, iconURL, detailedForecast;

- (void)dealloc {
    [location release];
    [currentTemp release];
    [minTemp release];
    [maxTemp release];
    [date release];
    [conditions release];
    [iconURL release];
    [detailedForecast release];
    [super dealloc];
}

- (id)init {
    self = [super init];
    return self;
}

@end
