//
//  BasicParser.m
//  WeatherReporter
//
//  Created by Vladimir Tsenev on 6/8/12.
//  Copyright (c) 2012 MentorMate. All rights reserved.
//

#import "BasicParser.h"
#import "BasicResponse.h"

@implementation BasicParser
@synthesize basicResponse, parsedData;

- (void)dealloc {
    [parsedData release];
    [basicResponse release];
    [super dealloc];
}

- (id)init {
    self = [super init];
    if (self) {
        self.basicResponse = [[BasicResponse alloc] init];
    }
    return self;
}

- (void)parseResponseWithString:(NSString *)dataString
                              withDelegate:(id<BasicParserDelegate>)delegate
                         withConnectionTag:(NSString *)connectionTag {
    
    NSError *error = nil;
    self.parsedData = [self objectWithString:dataString error:&error];
    
    id errorDict = [[self.parsedData objectForKey:@"response"] objectForKey:@"error"];
    if (!errorDict) {
        self.basicResponse.errorMessage = nil;
        self.basicResponse.isSuccessful = YES;
    } else {
        self.basicResponse.errorMessage = [errorDict objectForKey:@"description"];
        self.basicResponse.isSuccessful = NO;
    }
}

@end
