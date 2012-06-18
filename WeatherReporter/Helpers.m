//
//  Helpers.m
//  WeatherReporter
//
//  Created by Vladimir Tsenev on 6/18/12.
//  Copyright (c) 2012 MentorMate. All rights reserved.
//

#import "Helpers.h"
#import "Constants.h"

@implementation Helpers

+ (void)showAlertViewWithTitle:(NSString *)title withMessage:(NSString *)message withDelegate:(id)delegate {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}

@end
