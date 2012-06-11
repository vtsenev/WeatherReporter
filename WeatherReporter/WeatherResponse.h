//
//  WeatherResponse.h
//  WeatherReporter
//
//  Created by Vladimir Tsenev on 6/8/12.
//  Copyright (c) 2012 MentorMate. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BasicResponse.h"

@interface WeatherResponse : BasicResponse

@property (nonatomic, retain) NSMutableArray *weatherPeriods;
@property (nonatomic, retain) BasicResponse *basicResponse;

@end
