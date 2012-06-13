//
//  MapViewController.h
//  WeatherReporter
//
//  Created by Vladimir Tsenev on 6/11/12.
//  Copyright (c) 2012 MentorMate. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "City.h"

@interface MapViewController : UIViewController

@property (nonatomic, retain) City *city;
@property (retain, nonatomic) IBOutlet UILabel *testLabel;

@end
