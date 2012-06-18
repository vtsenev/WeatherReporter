//
//  Constants.h
//  WeatherReporter
//
//  Created by Vladimir Tsenev on 6/18/12.
//  Copyright (c) 2012 MentorMate. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Constants : NSObject

extern NSInteger const saltLength;
extern NSInteger const minPassLength;

extern NSInteger const dontRememberMe;
extern NSInteger const doRememberMe;

extern float const defaultMapSpan;

extern NSString *const dateFormat;

extern NSString *const userDefaultsUsernameKey;
extern NSString *const userDefaultsPasswordKey;
extern NSString *const userDefaultsRememberMeKey;
extern NSString *const userDefaultsSortByKey;

extern NSString *const sortByDefault;
extern NSString *const sortByCountry;
extern NSString *const sortByCity;

extern NSString *const loginErrorType;
extern NSString *const wrongPasswordError;
extern NSString *const missingUsernameOrPasswordError;
extern NSString *const userWithThisUsernameExistsError;
extern NSString *const requeredFieldAreEmptyError;
extern NSString *const passwordTooShortError;
extern NSString *const missingFieldsError;
extern NSString *const invalidCityErrorType;
extern NSString *const invalidCityError;
extern NSString *const cityNotFoundError;
extern NSString *const profileUpdatedTitle;
extern NSString *const profileUpdatedMessage;

@end
