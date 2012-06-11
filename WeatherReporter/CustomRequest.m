//
//  BasicRequest.m
//  WeatherReporter
//
//  Created by Vladimir Tsenev on 6/8/12.
//  Copyright (c) 2012 MentorMate. All rights reserved.
//

#import "CustomRequest.h"

@implementation CustomRequest
@synthesize basicParser;

- (void)dealloc {
    [basicParser release];
    [super dealloc];
}

- (id)initWithURL:(NSURL *)URL cachePolicy:(NSURLRequestCachePolicy)cachePolicy timeoutInterval:(NSTimeInterval)timeoutInterval parser:(BasicParser *)parser {
    self = [super initWithURL:URL cachePolicy:cachePolicy timeoutInterval:timeoutInterval];
    if (self) {
        self.basicParser = parser;
    }
    return self;
}

@end
