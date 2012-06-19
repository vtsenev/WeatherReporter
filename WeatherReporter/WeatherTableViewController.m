//
//  WeatherTableViewController.m
//  WeatherReporter
//
//  Created by Vladimir Tsenev on 6/8/12.
//  Copyright (c) 2012 MentorMate. All rights reserved.
//

#import "WeatherTableViewController.h"
#import "DataManager.h"
#import "City.h"
#import "User.h"
#import "LoginViewController.h"
#import "AddCityViewController.h"
#import "MapButton.h"
#import "MapViewController.h"
#import "WeatherPeriodsViewController.h"
#import "Constants.h"
#import "Helpers.h"

@interface WeatherTableViewController ()

@property (nonatomic, retain) UIView *disableViewOverlay;
@property (retain, nonatomic) NSMutableArray *tableData;
@property (retain, nonatomic) UISearchBar *theSearchBar;

- (void)addCity;
- (IBAction)showMapForCity:(id)sender;
- (void)sortCities:(NSArray *)cities;

@end

@implementation WeatherTableViewController

@synthesize tableData;
@synthesize theSearchBar;
@synthesize user;
@synthesize disableViewOverlay;

- (void)dealloc {
    [disableViewOverlay release];
    [user release];
    [tableData release];
    [theSearchBar release];
    [super dealloc];
}

- (void)viewDidUnload {
    [self setDisableViewOverlay:nil];
    [self setUser:nil];
    [self setTableData:nil];
    [self setTheSearchBar:nil];
    [super viewDidUnload];
}

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        UIImage *tabBarImage = [UIImage imageNamed:@"weather.png"];
        [self.tabBarItem setImage:tabBarImage];
        [self.tabBarItem setTitle:@"Weather Report"];
        
        [self.navigationItem setTitle:@"Cities"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *addCityBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addCity)];
    [self.navigationItem setRightBarButtonItem:addCityBtn];
    [addCityBtn release];

    CGRect searchBarFrame = self.view.frame;
    searchBarFrame.size.height = 44;
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:searchBarFrame];
    self.theSearchBar = searchBar;
    self.theSearchBar.delegate = self;
    
    [self.tableView setTableHeaderView:searchBar];
    [searchBar release];
    
    tableData = [[NSMutableArray alloc] init];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.user) {
        [self sortCities:[self.user.cities allObjects]];
    }
}

- (void)addCity {
    City *newCity = [[DataManager defaultDataManager] addCityForUsername:self.user.username];
    AddCityViewController *addCityViewController = [[AddCityViewController alloc] initWithNibName:@"AddCityViewController" bundle:nil];
    addCityViewController.city = newCity;
    addCityViewController.delegate = self;
    
    [self.navigationController pushViewController:addCityViewController animated:YES];
    [addCityViewController release];
}

- (void)sortCities:(NSArray *)cities {    
    NSString *sortBy = [[NSUserDefaults standardUserDefaults] valueForKey:userDefaultsSortByKey];
    if (sortBy) {
        if ([sortBy isEqualToString:sortByCity]) {
            NSArray *sortedCities = [[DataManager defaultDataManager] sortCitiesByCityName:cities];
            self.tableData = [NSMutableArray arrayWithArray:sortedCities];
        } else {
            NSArray *sortedCities = [[DataManager defaultDataManager] sortCitiesByCountry:cities];
            self.tableData = [NSMutableArray arrayWithArray:sortedCities];
        }
    } else {
        [[NSUserDefaults standardUserDefaults] setValue:sortByDefault forKey:userDefaultsSortByKey];
        NSArray *sortedCities = [[DataManager defaultDataManager] sortCitiesByCountry:cities];
        self.tableData = [NSMutableArray arrayWithArray:sortedCities];
    }
    
    [self.tableView reloadData];
}

# pragma mark - AddCityDelegate methods

- (void)didUpdateCity:(City *)theCity {
    for (City *anyCity in self.tableData) {
        NSLog(@"1 - %@, %@, %@, %@", anyCity.name, anyCity.country, anyCity.latitude, anyCity.longitude);
        NSLog(@"2 - %@, %@, %@, %@", theCity.name, theCity.country, theCity.latitude, theCity.longitude);
        if ([anyCity.name isEqualToString:theCity.name] && [anyCity.country isEqualToString:theCity.country] &&
            [anyCity.latitude isEqual:theCity.latitude] && [anyCity.longitude isEqual:theCity.longitude]) {
            
            [Helpers showAlertViewWithTitle:invalidCityErrorType withMessage:duplicateCityError withDelegate:self];
            [self didCancelCity:theCity];
            return;
        }
    }
    
    [self.tableData addObject:theCity];
    NSArray *sortedCities = [[DataManager defaultDataManager] sortCitiesByCountry:self.tableData];
    self.tableData = [NSMutableArray arrayWithArray:sortedCities];
    NSLog(@"%@, %@, %@, %@", theCity.name, theCity.country, theCity.latitude, theCity.longitude);
    
    [self.tableView reloadData];
}

- (void)didCancelCity:(City *)theCity {
    [[DataManager defaultDataManager] removeObject:theCity];
    [self.tableView reloadData];
}

# pragma mark - LoginViewControllerDelegate methods

- (void)loginDidSucceedWithUser:(User *)theUser {
    self.user = theUser;
    NSArray *citiesForCurrentUser = [[[DataManager defaultDataManager] fetchCitiesForUserWithUsername:self.user.username] allObjects];
    [self sortCities:citiesForCurrentUser];
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
    
    City *city = [self.tableData objectAtIndex:[indexPath row]];
    NSString *cityName = city.name;
    NSString *country = city.country;
    [cell.textLabel setText:cityName];
    [cell.detailTextLabel setText:country];
    UIImage *flagImage = [UIImage imageNamed:country];
    [cell.imageView setImage:flagImage];

    CGRect showMapBtnFrame = CGRectMake(cell.frame.origin.x + cell.frame.size.width - 68, 5, 30, 30);
    
    MapButton *showMapBtn = [MapButton buttonWithType:UIButtonTypeCustom];
    [showMapBtn setTableRow:[indexPath row]];
    [showMapBtn addTarget:self action:@selector(showMapForCity:) forControlEvents:UIControlEventTouchUpInside];
    UIImage *mapImage = [UIImage imageNamed:@"map"];
    [showMapBtn setImage:mapImage forState:UIControlStateNormal];
    showMapBtn.frame = showMapBtnFrame;
    [cell addSubview:showMapBtn];
        
    return cell;
}

- (IBAction)showMapForCity:(id)sender {
    MapButton *mapButton = (MapButton *)sender;
    City *city = [self.tableData objectAtIndex:mapButton.tableRow];
    
    MapViewController *mapViewController = [[MapViewController alloc] initWithNibName:@"MapViewController" bundle:nil];
    mapViewController.city = city;
    [self.navigationController pushViewController:mapViewController animated:YES];
    [mapViewController release];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        City *city = [tableData objectAtIndex:[indexPath row]];
        [[DataManager defaultDataManager] removeObject:city];
        [tableData removeObjectAtIndex:[indexPath row]];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WeatherPeriodsViewController *weatherPeriodsViewController = [[WeatherPeriodsViewController alloc] initWithStyle:UITableViewStylePlain];
    City *city = [self.tableData objectAtIndex:[indexPath row]];
    weatherPeriodsViewController.cityName = city.name;
    weatherPeriodsViewController.country = city.country;
    
    [self.navigationController pushViewController:weatherPeriodsViewController animated:YES];
    [weatherPeriodsViewController release];
}

# pragma mark - UISearchBarDelegate methods

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [self searchBar:searchBar activate:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.text = emptyString;
    [self searchBar:searchBar activate:NO];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSArray *results = [[DataManager defaultDataManager] searchCitiesForCity:searchBar.text forUsername:self.user.username];
	results = [[DataManager defaultDataManager] sortCitiesByCountry:results];
    [self searchBar:searchBar activate:NO];
	
    [self.tableData removeAllObjects];
    [self.tableData addObjectsFromArray:results];
    [self.tableView reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar activate:(BOOL)active {	
    self.tableView.allowsSelection = !active;
    self.tableView.scrollEnabled = !active;
    if (!active) {
        [searchBar resignFirstResponder];
    }
    [searchBar setShowsCancelButton:active animated:YES];
}

- (void)searchBar:(UISearchBar *)searchBar
    textDidChange:(NSString *)searchText {
    NSArray *results = [[DataManager defaultDataManager] searchCitiesForCity:searchText forUsername:self.user.username];
    results = [[DataManager defaultDataManager] sortCitiesByCountry:results];
    
    [self.tableData removeAllObjects];
    [self.tableData addObjectsFromArray:results];
    [self.tableView reloadData];
}

@end
