//
//  Helpers.h
//  WeatherReporter
//
//  Created by Vladimir Tsenev on 6/18/12.
//  Copyright (c) 2012 MentorMate. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "City.h"

@interface Helpers : NSObject

+ (void)showAlertViewWithTitle:(NSString *)title withMessage:(NSString *)message withDelegate:(id)delegate;

@end
