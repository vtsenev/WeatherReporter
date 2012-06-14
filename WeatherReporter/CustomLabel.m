//
//  CustomLabel.m
//  WeatherReporter
//
//  Created by Vladimir Tsenev on 6/14/12.
//  Copyright (c) 2012 MentorMate. All rights reserved.
//

#import "CustomLabel.h"

@implementation CustomLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGRect frame = [self frame];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1);
    [[UIColor lightGrayColor] setStroke];
    CGContextMoveToPoint(context, 5, frame.size.height - 5);
    CGContextAddLineToPoint(context, frame.size.width - 5, frame.size.height - 5);
    
    CGContextStrokePath(context);
    
    [super drawRect: rect];
}

@end
