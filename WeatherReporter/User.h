//
//  User.h
//  WeatherReporter
//
//  Created by Vladimir Tsenev on 6/8/12.
//  Copyright (c) 2012 MentorMate. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User : NSManagedObject

@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSDate * birthdayDate;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSSet *cities;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addCitiesObject:(NSManagedObject *)value;
- (void)removeCitiesObject:(NSManagedObject *)value;
- (void)addCities:(NSSet *)values;
- (void)removeCities:(NSSet *)values;

@end
