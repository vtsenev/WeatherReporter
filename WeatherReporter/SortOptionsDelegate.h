//
//  SortOptionsDelegate.h
//  WeatherReporter
//
//  Created by Vladimir Tsenev on 6/15/12.
//  Copyright (c) 2012 MentorMate. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SortOptionsDelegate <NSObject>

- (void)didChooseSortingOption:(NSInteger)sortingOption;
- (void)dismissSortingOptionsView:(UIView *)view;

@end
