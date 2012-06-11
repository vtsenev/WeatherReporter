//
//  BasicResponse.m
//  WeatherReporter
//
//  Created by Vladimir Tsenev on 6/8/12.
//  Copyright (c) 2012 MentorMate. All rights reserved.
//

#import "BasicResponse.h"

@implementation BasicResponse
@synthesize errorMessage, isSuccessful;

- (void)dealloc{

    [errorMessage release];
    [super dealloc];
}


- (id)init {
    self = [super init];
    return self;
}

@end
