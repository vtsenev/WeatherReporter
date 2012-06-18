//
//  DataManager.h
//  WeatherReporter
//
//  Created by Vladimir Tsenev on 6/8/12.
//  Copyright (c) 2012 MentorMate. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;
@class City;

@interface DataManager : NSObject {
    NSManagedObjectModel *model;
    NSManagedObjectContext *context;
    
    NSArray *countries;
}

+ (DataManager *)defaultDataManager;

- (NSSet *)fetchCitiesForUserWithUsername:(NSString *)username;
- (BOOL)checkIfUserExistsWithUsername:(NSString *)username;
- (BOOL)checkPass:(NSString *)passHash forUsername:(NSString *)username;
- (User *)fetchUserForUsername:(NSString *)username;
- (City *)addCityForUsername:(NSString *)username;
- (User *)addUser;
- (BOOL)removeObject:(NSManagedObject *)managedObj;

- (BOOL)saveChanges;

- (NSString *)pathInDocumentDirectory:(NSString *)fileName;

- (NSArray *)countries;
- (NSArray *)searchCitiesForCity:(NSString *)cityName forUsername:(NSString *)username;
- (NSArray *)sortCitiesByCityName:(NSArray *)cities;
- (NSArray *)sortCitiesByCountry:(NSArray *)cities;

@end
