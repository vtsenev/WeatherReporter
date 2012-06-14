//
//  WeatherPeriodsViewController.m
//  WeatherReporter
//
//  Created by Vladimir Tsenev on 6/13/12.
//  Copyright (c) 2012 MentorMate. All rights reserved.
//

#import "DetailedForecastViewController.h"
#import "WeatherPeriodsViewController.h"
#import "ConnectionManager.h"
#import "WeatherResponse.h"
#import "WeatherPeriod.h"

@interface WeatherPeriodsViewController ()

@end

@implementation WeatherPeriodsViewController
@synthesize cityName, country, tableData;

- (void)dealloc {
    [tableData release];
    [cityName release];
    [country release];
    [super dealloc];
}

- (void)viewDidUnload {
    [self setTableData:nil];
    [self setCityName:nil];
    [self setCountry:nil];
    [super viewDidUnload];
}

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        tableData = [[NSArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *title = [NSString stringWithFormat:@"%@, %@", self.cityName, self.country];
    [self.navigationItem setTitle:title];
    
    [[ConnectionManager defaultConnectionManager] getForecastForCity:cityName inCountry:country withDelegate:self];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UITableViewCell"] autorelease];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    WeatherPeriod *weatherPeriod = [self.tableData objectAtIndex:[indexPath row]];
    [cell.textLabel setText:[weatherPeriod date]];
    NSString *minMaxTemp = [NSString stringWithFormat:@"Low: %@, High: %@", [weatherPeriod minTemp], [weatherPeriod maxTemp]];
    [cell.detailTextLabel setText:minMaxTemp];
    
    NSURL *iconURL = [NSURL URLWithString:[weatherPeriod iconURL]];
    NSData *iconData = [NSData dataWithContentsOfURL:iconURL];
    UIImage *img = [[UIImage alloc] initWithData:iconData];
    [cell.imageView setImage:img];
    [img release];

    CGRect labelFrame = CGRectMake(cell.frame.origin.x + cell.frame.size.width - 120, 7, 90, cell.frame.size.height - 14);
    UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setNumberOfLines:2];
    [label setFont:[UIFont boldSystemFontOfSize:13]];
    [label setTextColor:[UIColor darkGrayColor]];
    [label setText:[weatherPeriod conditions]];
    [cell addSubview:label];
    [label release];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailedForecastViewController *detailedForecastViewController = [[DetailedForecastViewController alloc] 
                                                                      initWithNibName:@"DetailedForecastViewController" bundle:nil];
    WeatherPeriod *weatherPeriod = [self.tableData objectAtIndex:[indexPath row]];
    detailedForecastViewController.weatherPeriod = weatherPeriod;
    
    [self.navigationController pushViewController:detailedForecastViewController animated:YES];
    [detailedForecastViewController release];
}

# pragma mark - CustomConnectionDelegate

- (void)connectionDidFailWithError:(NSString *)errorMessage {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Connection error"
                                                        message:errorMessage delegate:self
                                              cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}

- (void)connectionDidSucceedWithParsedData:(NSObject *)parsedData {
    WeatherResponse *weatherResponse = (WeatherResponse *)parsedData;
    self.tableData = weatherResponse.weatherPeriods;
    [self displayCurrentTemperature];
    [self.tableView reloadData];
}

- (void)displayCurrentTemperature {
    CGRect tableHeaderViewFrame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, 40);
    UILabel *currentTemperatureLabel = [[UILabel alloc] initWithFrame:tableHeaderViewFrame];
    NSString *currentTemp = [NSString stringWithFormat:@"Temperature now: %@", [[self.tableData lastObject] currentTemp]];
    [currentTemperatureLabel setText:currentTemp];
    [currentTemperatureLabel setFont:[UIFont boldSystemFontOfSize:20]];
    [currentTemperatureLabel setTextAlignment:UITextAlignmentCenter];
    
    [self.tableView setTableHeaderView:currentTemperatureLabel];
    [currentTemperatureLabel release];
}

@end
