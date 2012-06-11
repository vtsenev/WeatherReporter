//
//  BasicParser.h
//  WeatherReporter
//
//  Created by Vladimir Tsenev on 6/8/12.
//  Copyright (c) 2012 MentorMate. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBJson.h"
#import "BasicParserDelegate.h"
@class BasicResponse;

@interface BasicParser : SBJsonParser

- (BasicResponse *)parseResponseWithString:(NSString *)dataString
                                withDelegate:(id<BasicParserDelegate>)delegate;

@end