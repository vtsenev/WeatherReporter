//
//  ConnectionManager.m
//  WeatherReporter
//
//  Created by Vladimir Tsenev on 6/8/12.
//  Copyright (c) 2012 MentorMate. All rights reserved.
//

#import "ConnectionManager.h"

@interface ConnectionManager()

@property (retain, nonatomic) NSMutableData *receivedData;
@property (retain, nonatomic) NSMutableSet *connectionSet;

- (NSString *)prepareRequestStringForLocation:(NSString *)theLocation;

@end

@implementation ConnectionManager

@end
