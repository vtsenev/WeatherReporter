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

- (void)getForecastForLocation:(NSString *)location
                  withDelegate:(id<CustomConnectionDelegate>)delegate;

@end
