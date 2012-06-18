//
//  DetailedForecastViewController.h
//  WeatherReporter
//
//  Created by Vladimir Tsenev on 6/13/12.
//  Copyright (c) 2012 MentorMate. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeatherPeriod.h"

@interface DetailedForecastViewController : UIViewController

@property (retain, nonatomic) IBOutlet UILabel *locationField;
@property (retain, nonatomic) IBOutlet UILabel *dateField;
@property (retain, nonatomic) IBOutlet UILabel *lowTempField;
@property (retain, nonatomic) IBOutlet UILabel *highTempField;
@property (retain, nonatomic) IBOutlet UITextView *detailedForecastView;
@property (retain, nonatomic) IBOutlet UIImageView *weatherImageView;
@property (retain, nonatomic) WeatherPeriod *weatherPeriod;

@end
