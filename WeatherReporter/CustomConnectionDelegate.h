//
//  CustomConnectionDelegate.h
//  WeatherReporter
//
//  Created by Vladimir Tsenev on 6/8/12.
//  Copyright (c) 2012 MentorMate. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WeatherResponse;

@protocol CustomConnectionDelegate <NSObject>

- (void)connectionDidFailWithError:(NSString *)errorMessage;
- (void)connectionDidSucceedWithParsedData:(NSObject *)parsedData;

@end
