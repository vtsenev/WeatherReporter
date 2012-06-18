//
//  SortOptionsViewController.h
//  WeatherReporter
//
//  Created by Vladimir Tsenev on 6/15/12.
//  Copyright (c) 2012 MentorMate. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SortOptionsDelegate.h"

@interface SortOptionsViewController : UIViewController <UIPickerViewDelegate>

@property (retain, nonatomic) IBOutlet UIPickerView *thePickerView;
@property (retain, nonatomic) NSMutableArray *sortingOptions;
@property (nonatomic) NSInteger choice;
@property (assign, nonatomic) id<SortOptionsDelegate> delegate;

- (IBAction)done:(id)sender;
- (IBAction)cancel:(id)sender;

@end
