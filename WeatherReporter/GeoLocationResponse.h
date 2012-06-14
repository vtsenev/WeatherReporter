//
//  GeoLocationResponse.h
//  WeatherReporter
//
//  Created by Vladimir Tsenev on 6/14/12.
//  Copyright (c) 2012 MentorMate. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BasicResponse.h"

@interface GeoLocationResponse : BasicResponse

@property (nonatomic, retain) BasicResponse *basicResponse;
@property (nonatomic, retain) NSMutableDictionary *geoLocationInformation;

@end
