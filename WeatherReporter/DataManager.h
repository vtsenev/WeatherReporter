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
}

+ (DataManager *)defaultDataManager;

- (NSSet *)fetchCitiesForUser:(NSString *)username;
- (BOOL)checkPass:(NSString *)pass forUser:(NSString *)username;
- (User *)fetchUserInfoForUser:(NSString *)username;
- (City *)addCity:(City *)cityName;
- (BOOL)addUser:(User *)username;
- (BOOL)removeObject:(NSManagedObject *)managedObj;
- (BOOL)updateUser:(NSString *)username;

- (BOOL)saveChanges;

- (NSString *)pathInDocumentDirectory:(NSString *)filename;

@end
