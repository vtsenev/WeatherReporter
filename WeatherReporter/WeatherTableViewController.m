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

@interface WeatherTableViewController ()

@end

@implementation WeatherTableViewController

@synthesize tableData;
@synthesize theSearchBar;
@synthesize user;

- (void)dealloc {
    [user release];
    [tableData release];
    [theSearchBar release];
    [super dealloc];
}

- (void)viewDidUnload {
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
    
    [self.tableView setTableHeaderView:searchBar];
    [searchBar release];
    
    tableData = [[NSMutableArray alloc] init];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)addCity {
    City *newCity = [[DataManager defaultDataManager] addCityForUsername:self.user.username];
    AddCityViewController *addCityViewController = [[AddCityViewController alloc] initWithNibName:@"AddCityViewController" bundle:nil];
    addCityViewController.city = newCity;
    addCityViewController.delegate = self;
    
    [self.navigationController pushViewController:addCityViewController animated:YES];
    [addCityViewController release];
}

# pragma mark - AddCityDelegate methods

- (void)didUpdateCity:(City *)theCity {
    [self.tableData addObject:theCity];
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
    NSSet *citiesForCurrentUser = [[DataManager defaultDataManager] fetchCitiesForUserWithUsername:self.user.username];
    self.tableData = [NSMutableArray arrayWithArray:[citiesForCurrentUser allObjects]];
    
    [self.tableView reloadData];
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

    CGRect showMapBtnFrame = CGRectMake(cell.frame.origin.x + cell.frame.size.width - 70, 5, 30, 30);
    
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

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        City *city = [tableData objectAtIndex:[indexPath row]];
        [[DataManager defaultDataManager] removeObject:city];
        [tableData removeObjectAtIndex:[indexPath row]];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//     [self.navigationController pushViewController:detailViewController animated:YES];
//     [detailViewController release];
}

@end
