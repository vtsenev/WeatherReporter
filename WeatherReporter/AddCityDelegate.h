//
//  AddCityDelegate.h
//  WeatherReporter
//
//  Created by Vladimir Tsenev on 6/12/12.
//  Copyright (c) 2012 MentorMate. All rights reserved.
//

#import <Foundation/Foundation.h>

@class City;

@protocol AddCityDelegate <NSObject>

- (void)didUpdateCity:(City *)theCity;
- (void)didCancelCity:(City *)theCity;

@end
