//
//  DatePickerControllerDelegate.h
//  WeatherReporter
//
//  Created by Victor Hristoskov on 6/13/12.
//  Copyright (c) 2012 MentorMate. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DatePickerViewController;
@protocol DatePickerControllerDelegate <NSObject>

-(void)datePickerController:(DatePickerViewController *) datePickerViewController didPickDate:(NSDate *)date; 



@end
