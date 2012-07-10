//
//  WeatherParser.m
//  WeatherReporter
//
//  Created by Vladimir Tsenev on 6/8/12.
//  Copyright (c) 2012 MentorMate. All rights reserved.
//

#import "WeatherParser.h"
#import "WeatherResponse.h"
#import "WeatherPeriod.h"

@implementation WeatherParser

- (id)init {
    self = [super init];
    return self;
}

- (void)parseResponseWithString:(NSString *)dataString withDelegate:(id<BasicParserDelegate>)delegate withConnectionTag:(NSString *)connectionTag {
    [super parseResponseWithString:dataString withDelegate:delegate withConnectionTag:connectionTag];
    
    if (self.basicResponse.isSuccessful) {
        WeatherResponse *weatherResponse = [[WeatherResponse alloc] init];
        weatherResponse.basicResponse = self.basicResponse;
        
        NSArray *forecastInfoArray = [[[self.parsedData objectForKey:@"forecast"] objectForKey:@"simpleforecast"] objectForKey:@"forecastday"];
        NSArray *forecastDetailsArray = [[[self.parsedData objectForKey:@"forecast"] objectForKey:@"txt_forecast"] objectForKey:@"forecastday"];
        
        NSString *currentTemp = [NSString stringWithFormat:@"%@ °C",[[self.parsedData objectForKey:@"current_observation"] objectForKey:@"temp_c"]];
        NSString *currentLocation = [[[self.parsedData objectForKey:@"current_observation"] objectForKey:@"display_location"] objectForKey:@"full"];
        
        if (!(forecastInfoArray && forecastDetailsArray && currentTemp && currentLocation)) {
            weatherResponse.isSuccessful = NO;
            NSLog(@"Data: %@", dataString);
            [delegate parserDidFailWithError:@"Response is not of the expected format." withConnectionTag:connectionTag];
        }
        
        int period = 0;
        for (NSDictionary* forecastInfo in forecastInfoArray) {
            WeatherPeriod *weatherPeriod = [[WeatherPeriod alloc] init];
            weatherPeriod.currentTemp = currentTemp;
            weatherPeriod.location = currentLocation;
            NSString *monthName = [[forecastInfo objectForKey:@"date"] objectForKey:@"monthname"];
            NSString *day = [NSString stringWithFormat:@"%@", [[forecastInfo objectForKey:@"date"] objectForKey:@"day"]];
            NSString *year = [NSString stringWithFormat:@"%@", [[forecastInfo objectForKey:@"date"] objectForKey:@"year"]];
            
            weatherPeriod.date = [NSString stringWithFormat:@"%@ %@, %@", monthName, day, year];
            weatherPeriod.maxTemp = [NSString stringWithFormat:@"%@ °C", [[forecastInfo objectForKey:@"high"] objectForKey:@"celsius"]];
            weatherPeriod.minTemp = [NSString stringWithFormat:@"%@ °C", [[forecastInfo objectForKey:@"low"] objectForKey:@"celsius"]];
            weatherPeriod.conditions = [forecastInfo objectForKey:@"conditions"];
            weatherPeriod.iconURL = [forecastInfo objectForKey:@"icon_url"];
            
            NSDictionary *detailForecastDict = [forecastDetailsArray objectAtIndex:period]; 
            NSString *dayDetails = [NSString stringWithFormat:@"%@: %@ \n", [detailForecastDict objectForKey:@"title"],
                                    [detailForecastDict objectForKey:@"fcttext_metric"]];
            
            detailForecastDict = [forecastDetailsArray objectAtIndex:period+1]; 
            NSString *nightDetails = [NSString stringWithFormat:@"%@: %@ \n", [detailForecastDict objectForKey:@"title"],
                                    [detailForecastDict objectForKey:@"fcttext_metric"]];
            
            weatherPeriod.detailedForecast =  [NSString stringWithFormat:@"%@\n%@", dayDetails, nightDetails];
            
            [weatherResponse.weatherPeriods addObject:weatherPeriod];
            [weatherPeriod release];
            period += 2;
        }
        
        if ([delegate respondsToSelector:@selector(parserDidSucceedWithData:withConnectionTag:)]) {
            [delegate parserDidSucceedWithData:weatherResponse withConnectionTag:connectionTag];
        }
        [weatherResponse release];
    }
    
}

@end
