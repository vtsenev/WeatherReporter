//
//  CustomConnection.m
//  WeatherReporter
//
//  Created by Vladimir Tsenev on 6/8/12.
//  Copyright (c) 2012 MentorMate. All rights reserved.
//

#import "CustomConnection.h"

@implementation CustomConnection
@synthesize customRequest, delegates, receivedData, connectionTag;

- (void)dealloc {
    [connectionTag release];
    [customRequest release];
    [delegates release];
    [receivedData release];
    [super dealloc];
}

- (id)initWithRequest:(NSURLRequest *)request delegate:(id < NSURLConnectionDelegate >)delegate startImmediately:(BOOL)startImmediately {
    self = [super initWithRequest:request delegate:delegate startImmediately:YES];
    if (self) {
        self.customRequest = (CustomRequest *)request;
        self.delegates = [[NSMutableArray alloc] init];
    }
    return self;
}

@end
