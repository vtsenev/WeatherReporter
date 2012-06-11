//
//  BasicParserDelegate.h
//  WeatherReporter
//
//  Created by Vladimir Tsenev on 6/8/12.
//  Copyright (c) 2012 MentorMate. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BasicParser;
@class WeatherResponse;

@protocol BasicParserDelegate <NSObject>

- (void)parserDidSucceedWithData:(NSObject *)parsedData;
- (void)parserDidFailWithError:(NSString *)errorMessage;

@end
