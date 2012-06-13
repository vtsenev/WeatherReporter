//
//  CountyPickerTableViewController.h
//  WeatherReporter
//
//  Created by Vladimir Tsenev on 6/11/12.
//  Copyright (c) 2012 MentorMate. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CountryPickerDelegate.h"

@interface CountyPickerTableViewController : UITableViewController

@property (nonatomic, retain) NSArray *tableData;
@property (nonatomic, assign) id<CountryPickerDelegate> delegate;

@end
