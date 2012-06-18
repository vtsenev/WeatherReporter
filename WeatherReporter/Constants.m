//
//  Constants.m
//  WeatherReporter
//
//  Created by Vladimir Tsenev on 6/18/12.
//  Copyright (c) 2012 MentorMate. All rights reserved.
//

#import "Constants.h"

@implementation Constants

NSString *const sortByDefault = @"country";
NSString *const sortByCountry = @"country";
NSString *const sortByCity = @"city";

NSString *const userDefaultsPasswordKey = @"password";
NSString *const userDefaultsUsernameKey = @"username";
NSString *const userDefaultsSortByKey = @"sortBy";
NSString *const userDefaultsRememberMeKey = @"rememberMe";

NSString *const loginErrorType = @"Login error";
NSString *const wrongPasswordError = @"Incorrect Password!\n Try Again!";
NSString *const missingUsernameOrPasswordError = @"Enter your username and password.";
NSString *const userWithThisUsernameExistsError = @"Username Already Exists";
NSString *const requeredFieldAreEmptyError = @"Required Fields Empty!";
NSString *const passwordTooShortError = @"Password is too short. Minimum 4 chars!";
NSString *const missingFieldsError = @"Please, fill in fields!";
NSString *const invalidCityErrorType = @"Insufficient Information";
NSString *const invalidCityError = @"Type a city name and select a country.";
NSString *const cityNotFoundError = @"One of the fields is missing or city is not in database.";
NSString *const profileUpdatedTitle = @"Profile Updated";
NSString *const profileUpdatedMessage = @"Your settings have been updated.";

NSString *const dateFormat = @"yyyy-MMMM-dd";

NSString *const emptyString =  @"";

NSInteger const saltLength = 29;
NSInteger const minPassLength = 4;

NSInteger const dontRememberMe = 0;
NSInteger const doRememberMe = 1;

float const defaultMapSpan = 0.200;

@end
