//
//  LoginViewControllerDelegate.h
//  WeatherReporter
//
//  Created by Vladimir Tsenev on 6/12/12.
//  Copyright (c) 2012 MentorMate. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@protocol LoginViewControllerDelegate <NSObject>

- (void)loginDidSucceedWithUser:(User *)theUser;

@end
