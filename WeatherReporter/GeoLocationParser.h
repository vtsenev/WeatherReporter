//
//  GeoLocationParser.h
//  WeatherReporter
//
//  Created by Vladimir Tsenev on 6/14/12.
//  Copyright (c) 2012 MentorMate. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BasicParser.h"
@class GeoLocationResponse;

@interface GeoLocationParser : BasicParser

- (void)parseResponseWithString:(NSString *)dataString
                   withDelegate:(id<BasicParserDelegate>)delegate
              withConnectionTag:(NSString *)connectionTag;

@end
