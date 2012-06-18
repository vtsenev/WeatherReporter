//
//  CustomAnimationUtilities.m
//  WeatherReporter
//
//  Created by Victor Hristoskov on 6/18/12.
//  Copyright (c) 2012 MentorMate. All rights reserved.
//

#import "CustomAnimationUtilities.h"

@interface CustomAnimationUtilities ()

+ (void)removeFromSuperviewView:(id)sender;

@end

@implementation CustomAnimationUtilities

#pragma mark - Appear/Disapear View animations

+ (void)appearView:(UIView *)appearView FromBottomOfView:(UIView *)parentView  withHeight:(NSInteger)height withDuration:(float)duration {
    
    [parentView addSubview:appearView];
    
    CGRect viewFrame = appearView.frame;
    // Set the popup view's frame so that it is off the bottom of the screen
    viewFrame.origin.y = CGRectGetMaxY(parentView.bounds);
    appearView.frame  = viewFrame; 
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:duration];
    viewFrame.origin.y -= height;
    appearView.frame = viewFrame;
    [UIView commitAnimations];    
}

+ (void)hideViewToBottom:(UIView *)view withHeight:(NSInteger)height withDuration:(float)duration{
    
    CGRect viewFrame = view.frame;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:duration];
    viewFrame.origin.y += height;
    view.frame = viewFrame;
    [UIView commitAnimations];
    [self performSelector:@selector(removeFromSuperviewView:) withObject:view afterDelay:0.5];    
}

+ (void)removeFromSuperviewView:(id)sender {
    [sender removeFromSuperview]; 
}

@end
