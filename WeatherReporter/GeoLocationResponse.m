//
//  GeoLocationResponse.m
//  WeatherReporter
//
//  Created by Vladimir Tsenev on 6/14/12.
//  Copyright (c) 2012 MentorMate. All rights reserved.
//

#import "GeoLocationResponse.h"

@implementation GeoLocationResponse
@synthesize basicResponse, geoLocationInformation;

- (void)dealloc {
    [geoLocationInformation release];
    [basicResponse release];
    [super dealloc];
}

- (id)init {
    self = [super init];
    if (self) {
        geoLocationInformation = [[NSMutableDictionary alloc] init];
    }
    return self;
}

@end
