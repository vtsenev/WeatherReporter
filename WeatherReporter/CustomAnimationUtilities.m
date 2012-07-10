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
+ (void)shakeViewEnded:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context;

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

+ (void)hideViewToBottom:(UIView *)view withHeight:(NSInteger)height withDuration:(float)duration {
    
    CGRect viewFrame = view.frame;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:duration];
    viewFrame.origin.y += height;
    view.frame = viewFrame;
    [UIView commitAnimations];
    [self performSelector:@selector(removeFromSuperviewView:) withObject:view afterDelay:duration];
}

+ (void)removeFromSuperviewView:(id)sender {
    [sender removeFromSuperview]; 
}

+ (void)shakeView:(UIView *)view onAngle:(NSInteger)angle {
    
    float radiansAngle = (angle / 180.0 * M_PI);
    
    CGAffineTransform leftRotate = CGAffineTransformMakeRotation( radiansAngle);
    CGAffineTransform rightRotate = CGAffineTransformMakeRotation(-radiansAngle);
    
    //rotate first to the left and then to the right 3 times
    //the rotation autoreverses
    view.transform = leftRotate;  
    [UIView beginAnimations:@"shakeView" context:view];
    [UIView setAnimationRepeatAutoreverses:YES];
    [UIView setAnimationRepeatCount:3];
    [UIView setAnimationDuration:0.09];
    [UIView setAnimationDelegate:self];
    view.transform = rightRotate;
    
    //When finish set the view to it's identity posiotion
    [UIView setAnimationDidStopSelector:@selector(shakeViewEnded:finished:context:)];
    [UIView commitAnimations];
    
}

+ (void)shakeViewEnded:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context  {
    if ([finished boolValue]) {
        UIView* item = (UIView *)context;
        item.transform = CGAffineTransformIdentity;
    }
}

@end
