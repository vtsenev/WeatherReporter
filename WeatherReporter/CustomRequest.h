//
//  BasicRequest.h
//  WeatherReporter
//
//  Created by Vladimir Tsenev on 6/8/12.
//  Copyright (c) 2012 MentorMate. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BasicParser;

@interface CustomRequest : NSURLRequest

@property (nonatomic, retain) BasicParser *basicParser;

@end
