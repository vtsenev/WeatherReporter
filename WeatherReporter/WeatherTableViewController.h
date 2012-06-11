//
//  WeatherTableViewController.h
//  WeatherReporter
//
//  Created by Vladimir Tsenev on 6/8/12.
//  Copyright (c) 2012 MentorMate. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeatherTableViewController : UITableViewController <UISearchBarDelegate>

@property (retain, nonatomic) NSMutableArray *tableData;
@property (retain, nonatomic) UISearchBar *theSearchBar;

@end
