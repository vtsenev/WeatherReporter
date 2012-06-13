//
//  CountryPickerDelegate.h
//  WeatherReporter
//
//  Created by Vladimir Tsenev on 6/13/12.
//  Copyright (c) 2012 MentorMate. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CountryPickerDelegate <NSObject>

- (void)didSelectCountry:(NSString *)country;

@end
