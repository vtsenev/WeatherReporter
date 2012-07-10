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
#import "Constants.h"

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
    return [[self defaultDataManager] retain];
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
    if (self) {
        model = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];
        
        NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
        
        NSString *path = [self pathInDocumentDirectory:@"db.sqlite"];
        NSURL *storeURL = [NSURL fileURLWithPath:path];
        
        NSError *error = nil;
        
        if (![psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
            [NSException raise:@"Open failed" format:@"Reason: %@", [error localizedDescription]];
        }
        
        context = [[NSManagedObjectContext alloc] init];
        [context setPersistentStoreCoordinator:psc];
        [psc release];
        
        [context setUndoManager:nil];
        
        countries = [[NSArray alloc] initWithObjects:@"Austria", @"Bulgaria", @"Denmark", @"France",
                     @"Germany", @"Italy", @"Netherlands", @"Poland", @"Spain", @"Sweden",
                     @"Switzerland", @"UK", nil];
    }
    
    return self;
}

- (NSString *)pathInDocumentDirectory:(NSString *)fileName {
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    return [documentDirectory stringByAppendingPathComponent:fileName];
}

- (NSSet *)fetchCitiesForUserWithUsername:(NSString *)username {
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

- (BOOL)checkPass:(NSString *)passHash forUsername:(NSString *)username {
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

- (BOOL)checkIfUserExistsWithUsername:(NSString *)username {
    return [self fetchUserForUsername:username] != nil;
}

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
    
    if ([result count] == 1) {
        return [result lastObject];
    } else {
        return nil;
    }
}

- (City *)addCityForUsername:(NSString *)username {
    City *c = [NSEntityDescription insertNewObjectForEntityForName:@"City" inManagedObjectContext:context];
    User *user = [self fetchUserForUsername:username];
    
    NSMutableSet *cities = [user mutableSetValueForKey:@"cities"];
    [cities addObject:c];
    
    return c;
}

- (User *)addUser {
    User *u = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:context];
    return u;
}

- (BOOL)removeObject:(NSManagedObject *)managedObj {
    [context deleteObject:managedObj];
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

- (NSArray *)countries {
    return countries;
}

- (NSArray *)searchCitiesForCity:(NSString *)cityName forUsername:(NSString *)username {
    User *user = [self fetchUserForUsername:username];
    NSSet *allCities = user.cities;

    NSMutableArray *searchedCities = [[[NSMutableArray alloc] init] autorelease];
    if (![cityName isEqualToString:emptyString]) {
        for (City *city in allCities) {
            if ([city.name hasPrefix:cityName] || [city.country hasPrefix:cityName]) {
                [searchedCities addObject:city];
            }
        }
    } else {
        [searchedCities addObjectsFromArray:[allCities allObjects]];
    }
    
    return searchedCities;
}

- (NSArray *)sortCitiesByCityName:(NSArray *)cities {
    NSSortDescriptor *sd = [[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES] autorelease];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sd];
    NSArray *sortedCities = [cities sortedArrayUsingDescriptors:sortDescriptors];
    return sortedCities;
}

- (NSArray *)sortCitiesByCountry:(NSArray *)cities {
    NSSortDescriptor *sdByCountry = [[[NSSortDescriptor alloc] initWithKey:@"country" ascending:YES] autorelease];
    NSSortDescriptor *sdByName = [[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES] autorelease];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sdByCountry, sdByName, nil];
    NSArray *sortedCities = [cities sortedArrayUsingDescriptors:sortDescriptors];
    return sortedCities;
}

@end
