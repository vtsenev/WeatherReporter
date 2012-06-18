//
//  CustomAnimationUtilities.h
//  WeatherReporter
//
//  Created by Victor Hristoskov on 6/18/12.
//  Copyright (c) 2012 MentorMate. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomAnimationUtilities : NSObject

+ (void)hideViewToBottom:(UIView *)view withHeight:(NSInteger)height withDuration:(float)duration;
+ (void)appearView:(UIView *)appearView FromBottomOfView:(UIView *)parentView  withHeight:(NSInteger)height withDuration:(float)duration;
+ (void)shakeView:(UIView *)view onAngle:(NSInteger)angle;

@end
