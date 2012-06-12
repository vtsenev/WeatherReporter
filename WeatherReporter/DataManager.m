//
//  DataManager.m
//  WeatherReporter
//
//  Created by Vladimir Tsenev on 6/8/12.
//  Copyright (c) 2012 MentorMate. All rights reserved.
//

#import "DataManager.h"
#import "User.h"
#import "City.h"

static DataManager *defaultDataManager = nil;

@implementation DataManager

+ (DataManager *)defaultDataManager {
    if (!defaultDataManager) {
        @synchronized(self) {
            if (!defaultDataManager) {
                defaultDataManager = [[super allocWithZone:NULL] init];
            }
        }
    }
    return defaultDataManager;
}

+ (id)allocWithZone:(NSZone *)zone {
    return [self defaultDataManager];
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)retain {
    return self;
}

- (oneway void)release {
    // do nothing
}

- (NSUInteger)retainCount {
    return NSUIntegerMax;
}

- (id)init {
    if (defaultDataManager) {
        return defaultDataManager;
    }
    self = [super init];
    
    model = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];
    
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    
    NSString *path = [self pathInDocumentDirectory:@"db.data"];
    NSURL *storeURL = [NSURL fileURLWithPath:path];
    
    NSError *error = nil;
    
    if (![psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        [NSException raise:@"Open failed" format:@"Reason: %@", [error localizedDescription]];
    }
    
    context = [[NSManagedObjectContext alloc] init];
    [context setPersistentStoreCoordinator:psc];
    [psc release];
    
    [context setUndoManager:nil];
    
    return self;
}

- (NSString *)pathInDocumentDirectory:(NSString *)fileName {
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    return [documentDirectory stringByAppendingPathComponent:fileName];
}

- (NSSet *)fetchCitiesForUser:(NSString *)username {
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription *e = [[model entitiesByName] objectForKey:@"User"];
    [request setEntity:e];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"username LIKE %@", username];
    [request setPredicate:predicate];
    
    NSError *error;
    NSArray *result = [context executeFetchRequest:request error:&error];
    if (!result) {
        [NSException raise:@"Fetch failed" format:@"Reason: %@", [error localizedDescription]];
    }
    User *user = [result lastObject];
    return [user cities];
}

- (BOOL)checkPass:(NSString *)passHash forUser:(NSString *)username {
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription *e = [[model entitiesByName] objectForKey:@"User"];
    [request setEntity:e];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(username LIKE %@) AND (password LIKE %@)", username, passHash];
    [request setPredicate:predicate];
    
    NSError *error;
    NSArray *result = [context executeFetchRequest:request error:&error];
    if(!result) {
        [NSException raise:@"Fetch failed" format:@"Reason %@", [error localizedDescription]];
    }
    
    if([result count] == 0) {
        return NO;
    }
    return YES;
}

//- (BOOL)validateValue:(id *)ioValue forKey:(NSString *)inKey error:(NSError **)outError{

- (User *)fetchUserForUsername:(NSString *)username {
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription *e = [[model entitiesByName] objectForKey:@"User"];
    [request setEntity:e];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"username LIKE %@", username];
    [request setPredicate:predicate];
    
    NSError *error;
    NSArray *result = [context executeFetchRequest:request error:&error];
    if(!result) {
        [NSException raise:@"Fetch failed" format:@"Reason %@", [error localizedDescription]];
    }
    
    return [result lastObject];
}

- (BOOL)addCity:(City *)newCity
      forUsername:(NSString *)username {
    City *c = [NSEntityDescription insertNewObjectForEntityForName:@"City" inManagedObjectContext:context];
    c = [[newCity retain] autorelease];
    User *user = [self fetchUserForUsername:username];
    
    NSMutableSet *cities = [user mutableSetValueForKey:@"cities"];
    [cities addObject:c];
    
    return [self saveChanges];
}

- (BOOL)addUser:(User *)newUser {
    User *u = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:context];
    u = [[newUser retain] autorelease];
    
    return [self saveChanges];
}

- (BOOL)removeObject:(NSManagedObject *)managedObj {
    [context deleteObject:managedObj];
    return [self saveChanges];
}

- (BOOL)updateUser:(User *)user {
    User *u = [self fetchUserForUsername:user.userName];
    u = [[user retain] autorelease];
    return [self saveChanges];
}

- (BOOL)saveChanges {
    NSError *err = nil;
    BOOL successful = [context save:&err];
    if (!successful) {
        NSLog(@"Error saving: %@", [err localizedDescription]);
    }
    return successful;
}

@end
