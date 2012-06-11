//
//  WeatherResponse.m
//  WeatherReporter
//
//  Created by Vladimir Tsenev on 6/8/12.
//  Copyright (c) 2012 MentorMate. All rights reserved.
//

#import "WeatherResponse.h"

@implementation WeatherResponse
@synthesize weatherPeriods, basicResponse;

- (void)dealloc {
    [weatherPeriods release];
    [basicResponse release];
    [super dealloc];
}

- (id)init {
    self = [super init];
    if (self) {
        weatherPeriods = [[NSMutableArray alloc] init];
    }
    return self;
}

@end
