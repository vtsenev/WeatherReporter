//
//  WeatherPeriodsViewController.h
//  WeatherReporter
//
//  Created by Vladimir Tsenev on 6/13/12.
//  Copyright (c) 2012 MentorMate. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomConnectionDelegate.h"

@interface WeatherPeriodsViewController : UITableViewController <CustomConnectionDelegate>

@property (nonatomic, retain) NSString *cityName;
@property (nonatomic, retain) NSString *country;
@property (nonatomic, retain) NSArray *tableData;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;

@end
