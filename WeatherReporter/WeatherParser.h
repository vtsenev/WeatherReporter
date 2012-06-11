//
//  WeatherParser.h
//  WeatherReporter
//
//  Created by Vladimir Tsenev on 6/8/12.
//  Copyright (c) 2012 MentorMate. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BasicParser.h"
@class WeatherResponse;

@interface WeatherParser : BasicParser

- (WeatherResponse *)parseResponseWithString:(NSString *)dataString
                              withDelegate:(id<BasicParserDelegate>)delegate;


@end
