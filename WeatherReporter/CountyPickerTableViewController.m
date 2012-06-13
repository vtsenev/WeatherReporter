//
//  CountyPickerTableViewController.m
//  WeatherReporter
//
//  Created by Vladimir Tsenev on 6/11/12.
//  Copyright (c) 2012 MentorMate. All rights reserved.
//

#import "CountyPickerTableViewController.h"
#import "DataManager.h"

@interface CountyPickerTableViewController ()

@end

@implementation CountyPickerTableViewController
@synthesize tableData, delegate;

- (void)dealloc {
    [tableData release];
    [super dealloc];
}

- (void)viewDidUnload {
    [self setTableData:nil];
    [super viewDidUnload];
}

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableData = [[DataManager defaultDataManager] countries];
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
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"] autorelease];
    }
    NSString *cityName = [self.tableData objectAtIndex:[indexPath row]];
    UIImage *image = [UIImage imageNamed:cityName];
    cell.imageView.image = image;
    [cell.textLabel setText:cityName];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *country = [self.tableData objectAtIndex:[indexPath row]];
    if ([delegate respondsToSelector:@selector(didSelectCountry:)]) {
        [self.delegate didSelectCountry:country];
    }
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
