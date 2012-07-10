//
//  CustomConnection.m
//  WeatherReporter
//
//  Created by Vladimir Tsenev on 6/8/12.
//  Copyright (c) 2012 MentorMate. All rights reserved.
//

#import "CustomConnection.h"
#import "CustomRequest.h"
#import "BasicParser.h"
#import "ConnectionManager.h"

@interface CustomConnection ()

@property (nonatomic, retain) NSMutableData *receivedData;

@end

@implementation CustomConnection
@synthesize customRequest;
@synthesize delegates;
@synthesize connectionTag;
@synthesize receivedData;

- (void)dealloc {
    [connectionTag release];
    [customRequest release];
    [delegates release];
    [receivedData release];
    [super dealloc];
}

//- (id)initWithRequest:(NSURLRequest *)request delegate:(id < NSURLConnectionDelegate >)delegate startImmediately:(BOOL)startImmediately {
//    self = [super initWithRequest:request delegate:delegate startImmediately:YES];
//    if (self) {
//        self.customRequest = (CustomRequest *)request;
//        delegates = [[NSMutableArray alloc] init];
//    }
//    return self;
//}

- (id)initWithRequest:(NSURLRequest *)request startImmediately:(BOOL)startImmediately {
    self = [super initWithRequest:request delegate:self startImmediately:YES];
    if (self) {
        self.customRequest = (CustomRequest *)request;
        delegates = [[NSMutableArray alloc] init];
    }
    return self;
}

# pragma mark - NSURLConnection methods

- (NSURLRequest *)connection:(NSURLConnection *)connection
 			 willSendRequest:(NSURLRequest *)request
 			redirectResponse:(NSURLResponse *)redirectResponse {
 	NSLog(@"Connection received data, retain count");
    return request;
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response  {
    NSLog(@"Request received response.");
    
    self.receivedData = [NSMutableData data];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data  {
    NSLog(@"Request received data.");
    [self.receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    self.receivedData = nil;
 	NSLog(@"Error receiving response: %@", error);
    if ([self.delegate respondsToSelector:@selector(parserDidFailWithError:withConnectionTag:)]) {
        [self.delegate parserDidFailWithError:error.description withConnectionTag:self.connectionTag];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection  {
    NSLog(@"Succeeded! Received %d bytes of data",[self.receivedData length]);
    
    NSString *dataStr = [[NSString alloc] initWithData:self.receivedData encoding:NSUTF8StringEncoding];
    self.receivedData = nil;
    [self.customRequest.basicParser parseResponseWithString:dataStr withDelegate:[ConnectionManager defaultConnectionManager] withConnectionTag:self.connectionTag];
    [dataStr release];
}

@end
