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

- (NSSet *)fetchCitiesForUserWithUsername:(NSString *)username;
- (BOOL)checkIfUserExistsWithUsername:(NSString *)username;
- (BOOL)checkPass:(NSString *)passHash forUsername:(NSString *)username;
- (User *)fetchUserForUsername:(NSString *)username;
- (BOOL)addCity:(City *)newCity forUsername:(NSString *)username;
- (User *)addUser;
- (BOOL)removeObject:(NSManagedObject *)managedObj;
- (void)updateUser:(User *)user;

- (BOOL)saveChanges;

- (NSString *)pathInDocumentDirectory:(NSString *)fileName;

@end
