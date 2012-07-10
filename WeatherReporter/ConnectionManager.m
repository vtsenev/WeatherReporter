//
//  ConnectionManager.m
//  WeatherReporter
//
//  Created by Vladimir Tsenev on 6/8/12.
//  Copyright (c) 2012 MentorMate. All rights reserved.
//

#import "ConnectionManager.h"
#import "CustomConnection.h"
#import "CustomRequest.h"
#import "WeatherParser.h"
#import "GeoLocationParser.h"
#import "BasicResponse.h"

// connection tags
NSString * const kGetForecastTag = @"GetForecast+%@";
NSString * const kGetGeoLocationTag = @"GetGeoLocation+%@";

@interface ConnectionManager()

@property (nonatomic, retain) NSMutableData *receivedData;
@property (retain, nonatomic) NSMutableDictionary *connectionDict;

- (NSURL *)createForecastURLForCity:(NSString *)city inCountry:(NSString *)country;

@end

static ConnectionManager *defaultConnectionManager = nil;

@implementation ConnectionManager
@synthesize connectionDict, receivedData;

+ (ConnectionManager *)defaultConnectionManager {
    if (!defaultConnectionManager) {
        @synchronized(self) {
            if (!defaultConnectionManager) {
                defaultConnectionManager = [[super allocWithZone:NULL] init];
            }
        }
    }
    return defaultConnectionManager;
}

+ (id)allocWithZone:(NSZone *)zone {
    return [[self defaultConnectionManager] retain];
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
    if (defaultConnectionManager) {
        return defaultConnectionManager;
    }
    self = [super init];
    connectionDict = [[NSMutableDictionary alloc] init];
    return self;
}

- (NSURL *)createForecastURLForCity:(NSString *)city inCountry:(NSString *)country {
    NSString *requestKey = @"93ab1f111d91a7bd";
    NSString *requestStr = [NSString stringWithFormat:@"http://api.wunderground.com/api/%@/conditions/forecast/q/%@/%@.json", requestKey, country, city];
    NSURL *url = [NSURL URLWithString:requestStr];
    return url;
}

- (NSURL *)createGeoLocationURLForCity:(NSString *)city inCountry:(NSString *)country {
    NSString *requestKey = @"93ab1f111d91a7bd";
    NSString *requestStr = [NSString stringWithFormat:@"http://api.wunderground.com/api/%@/geolookup/q/%@/%@.json", requestKey, country, city];
    NSURL *url = [NSURL URLWithString:requestStr];
    return url;
} 

- (void)getForecastForCity:(NSString *)city inCountry:(NSString *)country
              withDelegate:(id<CustomConnectionDelegate>)delegate {
    NSString *tagString = [NSString stringWithFormat:kGetForecastTag, city];
    CustomConnection *customConnection = [connectionDict objectForKey:tagString];
    
    if (!customConnection) {
        WeatherParser *weatherParser = [[WeatherParser alloc] init];

        CustomRequest *newRequest = [[CustomRequest alloc] initWithURL:[self createForecastURLForCity:city inCountry:country] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10 parser:weatherParser];
        [weatherParser release];
        
//        CustomConnection *newConnection = [[CustomConnection alloc] initWithRequest:newRequest delegate:self startImmediately:YES];
        CustomConnection *newConnection = [[CustomConnection alloc] initWithRequest:newRequest startImmediately:YES];
        newConnection.delegate = self;
        [newRequest release];
        [newConnection.delegates addObject:delegate];
        newConnection.connectionTag = tagString;
        
        [connectionDict setObject:newConnection forKey:tagString];
        [newConnection release];
    } else {
        [customConnection.delegates addObject:delegate];
    }
}

- (void)getGeoLocationInformationForCity:(NSString *)city inCountry:(NSString *)country
              withDelegate:(id<CustomConnectionDelegate>)delegate {
    NSString *tagString = [NSString stringWithFormat:kGetGeoLocationTag, city];
    CustomConnection *customConnection = [connectionDict objectForKey:tagString];
    
    if (!customConnection) {
        GeoLocationParser *geoLocationParser = [[GeoLocationParser alloc] init];
        
        CustomRequest *newRequest = [[CustomRequest alloc] initWithURL:[self createGeoLocationURLForCity:city inCountry:country] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10 parser:geoLocationParser];
        [geoLocationParser release];
        
//        CustomConnection *newConnection = [[CustomConnection alloc] initWithRequest:newRequest delegate:self startImmediately:YES];
        CustomConnection *newConnection = [[CustomConnection alloc] initWithRequest:newRequest startImmediately:YES];
        newConnection.delegate = self;
        [newRequest release];
        [newConnection.delegates addObject:delegate];
        newConnection.connectionTag = tagString;
        
        [connectionDict setObject:newConnection forKey:tagString];
        [newConnection release];
    } else {
        [customConnection.delegates addObject:delegate];
    }
}

# pragma mark - BasicParserDelegate methods

- (void)parserDidSucceedWithData:(NSObject *)parsedData withConnectionTag:(NSString *)connectionTag {
    CustomConnection *customConnection = [self.connectionDict objectForKey:connectionTag];

    for (id<CustomConnectionDelegate> delegate in customConnection.delegates) {
        if ([delegate respondsToSelector:@selector(connectionDidSucceedWithParsedData:)]) {
//            GeoLocationResponse *gr = (GeoLocationResponse *)parsedData;
//            BasicResponse *br = [gr basicResponse];
//            
//            NSLog(@"Success! BOOL: %i", [br isSuccessful]);
            [delegate connectionDidSucceedWithParsedData:parsedData];
        }
    }
    
    [self.connectionDict removeObjectForKey:connectionTag];
}

- (void)parserDidFailWithError:(NSString *)errorMessage withConnectionTag:(NSString *)connectionTag {
    CustomConnection *customConnection = [self.connectionDict objectForKey:connectionTag];
    
    for (id<CustomConnectionDelegate> delegate in customConnection.delegates) {
        if ([delegate respondsToSelector:@selector(connectionDidFailWithError:)]) {
            NSLog(@"Failure! Error message: %@", errorMessage);
            [delegate connectionDidFailWithError:errorMessage];
        }
    }
    
    [self.connectionDict removeObjectForKey:connectionTag];
}

@end
