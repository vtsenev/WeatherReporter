//
//  WeatherPeriod.h
//  WeatherReporter
//
//  Created by Vladimir Tsenev on 6/11/12.
//  Copyright (c) 2012 MentorMate. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherPeriod : NSObject

@property (nonatomic, retain) NSString *location;
@property (nonatomic, retain) NSString *date;
@property (nonatomic, retain) NSString *currentTemp;
@property (nonatomic, retain) NSString *minTemp;
@property (nonatomic, retain) NSString *maxTemp;
@property (nonatomic, retain) NSString *conditions;
@property (nonatomic, retain) NSString *iconURL;
@property (nonatomic, retain) NSString *detailedForecast;

@end
