//
//  CustomConnection.h
//  WeatherReporter
//
//  Created by Vladimir Tsenev on 6/8/12.
//  Copyright (c) 2012 MentorMate. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BasicParserDelegate.h"
#import "CustomConnectionDelegate.h"
@class CustomRequest;

@interface CustomConnection : NSURLConnection

@property (nonatomic, retain) CustomRequest *customRequest;
@property (nonatomic, retain) NSMutableArray *delegates;
@property (nonatomic, retain) NSString *connectionTag;
@property (nonatomic, assign) id<BasicParserDelegate> delegate;

- (id)initWithRequest:(NSURLRequest *)request startImmediately:(BOOL)startImmediately;

@end
