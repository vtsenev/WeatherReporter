//
//  ConnectionManager.h
//  WeatherReporter
//
//  Created by Vladimir Tsenev on 6/8/12.
//  Copyright (c) 2012 MentorMate. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BasicParserDelegate.h"
#import "CustomConnectionDelegate.h"

@interface ConnectionManager : NSObject <BasicParserDelegate>

+ (ConnectionManager *)defaultConnectionManager;

- (void)getForecastForCity:(NSString *)city inCountry:(NSString *)country
              withDelegate:(id<CustomConnectionDelegate>)delegate;
- (void)getGeoLocationInformationForCity:(NSString *)city inCountry:(NSString *)country
                            withDelegate:(id<CustomConnectionDelegate>)delegate;

@end
