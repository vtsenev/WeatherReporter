//
//  RegisterUserDelegate.h
//  WeatherReporter
//
//  Created by Vladimir Tsenev on 6/15/12.
//  Copyright (c) 2012 MentorMate. All rights reserved.
//

#import <Foundation/Foundation.h>
@class User;

@protocol RegisterUserDelegate <NSObject>

- (void)newUserIsRegistered:(User *)user;

@end
