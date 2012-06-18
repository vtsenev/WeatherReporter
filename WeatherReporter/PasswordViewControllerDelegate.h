//
//  PasswordViewControllerDelegate.h
//  WeatherReporter
//
//  Created by Victor Hristoskov on 6/14/12.
//  Copyright (c) 2012 MentorMate. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PasswordViewControllerDelegate <NSObject>

- (void) confirmPassword:(NSString *)password;

@end
