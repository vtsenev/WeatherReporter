//
//  BasicResponse.h
//  WeatherReporter
//
//  Created by Vladimir Tsenev on 6/8/12.
//  Copyright (c) 2012 MentorMate. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BasicResponse : NSObject

@property (nonatomic, assign) BOOL isSuccessful;
@property (nonatomic, retain) NSString *errorMessage;

@end
