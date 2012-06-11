//
//  ConnectionManager.h
//  WeatherReporter
//
//  Created by Vladimir Tsenev on 6/8/12.
//  Copyright (c) 2012 MentorMate. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BasicParserDelegate.h"
#import "CustomConnectionDelegate.h"

@interface ConnectionManager : NSObject <BasicParserDelegate>

+ (ConnectionManager *)defaultManager;

- (void)createConnectionForViewController:(id<CustomConnectionDelegate> *)viewController
                                 forLocation:(NSString *)location;

@end
