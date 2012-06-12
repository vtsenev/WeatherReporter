//
//  DatePickerViewController.h
//  WeatherReporter
//
//  Created by Vladimir Tsenev on 6/11/12.
//  Copyright (c) 2012 MentorMate. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DatePickerViewController : UIViewController
@property (retain, nonatomic) IBOutlet UIDatePicker *datePickerController;
- (IBAction)cancelDatePicker:(id)sender;
- (IBAction)addDate:(id)sender;

@end
