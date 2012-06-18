//
//  GeoLocationParser.m
//  WeatherReporter
//
//  Created by Vladimir Tsenev on 6/14/12.
//  Copyright (c) 2012 MentorMate. All rights reserved.
//

#import "GeoLocationParser.h"
#import "BasicResponse.h"
#import "GeoLocationResponse.h"

@implementation GeoLocationParser

- (id)init {
    self = [super init];
    return self;
}

- (void)parseResponseWithString:(NSString *)dataString withDelegate:(id<BasicParserDelegate>)delegate withConnectionTag:(NSString *)connectionTag {
    [super parseResponseWithString:dataString withDelegate:delegate withConnectionTag:connectionTag];
    
    if (self.basicResponse.isSuccessful) {
        
        GeoLocationResponse *geoLocationResponse = [[GeoLocationResponse alloc] init];
        geoLocationResponse.basicResponse = self.basicResponse;
        
        NSString *latitude = [[self.parsedData objectForKey:@"location"] objectForKey:@"lat"];
        NSString *longitude = [[self.parsedData objectForKey:@"location"] objectForKey:@"lon"];
        
        if (latitude && longitude) {
            [geoLocationResponse.geoLocationInformation setValue:latitude forKey:@"latitude"];
            [geoLocationResponse.geoLocationInformation setValue:longitude forKey:@"longitude"];
            
            if ([delegate respondsToSelector:@selector(parserDidSucceedWithData:withConnectionTag:)]) {
                [delegate parserDidSucceedWithData:geoLocationResponse withConnectionTag:connectionTag];
            }
        } else {
            self.basicResponse.isSuccessful = NO;
            if ([delegate respondsToSelector:@selector(parserDidFailWithError:withConnectionTag:)]) {
                NSLog(@"Data: %@", dataString);
                [delegate parserDidFailWithError:@"Response is not of the expected format." withConnectionTag:connectionTag];
            }
        }
        [geoLocationResponse release];
    }
    else {
        
        if ([delegate respondsToSelector:@selector(parserDidFailWithError:withConnectionTag:)]){
            NSLog(@"Data: %@", dataString);
            [delegate parserDidFailWithError:self.basicResponse.errorMessage withConnectionTag:connectionTag];
        }     
    }
    
}

@end
