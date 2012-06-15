//
//  SortOptionsViewController.m
//  WeatherReporter
//
//  Created by Vladimir Tsenev on 6/15/12.
//  Copyright (c) 2012 MentorMate. All rights reserved.
//

#import "SortOptionsViewController.h"

@interface SortOptionsViewController ()

@end

@implementation SortOptionsViewController
@synthesize thePickerView;
@synthesize sortingOptions;
@synthesize choice;
@synthesize delegate;

- (void)dealloc {
    [sortingOptions release];
    [thePickerView release];
    [super dealloc];
}

- (void)viewDidUnload {
    [self setSortingOptions:nil];
    [self setThePickerView:nil];
    [super viewDidUnload];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    sortingOptions = [[NSMutableArray alloc] init];
    [sortingOptions addObject:@"By city"];
    [sortingOptions addObject:@"By country"];
    [sortingOptions addObject:@"By city (desc)"];
    [sortingOptions addObject:@"By country (desc)"];
    
    [self.thePickerView selectRow:0 inComponent:0 animated:NO];
    self.choice = 0;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

# pragma mark - UIPickerViewDelegate methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.choice = row;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.sortingOptions count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self.sortingOptions objectAtIndex:row];
}

- (IBAction)done:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didChooseSortingOption:)]) {
        [self.delegate didChooseSortingOption:choice];
    }
}

- (IBAction)cancel:(id)sender {
    if ([self.delegate respondsToSelector:@selector(dismissSortingOptionsView:)]) {
        [self.delegate dismissSortingOptionsView:self.view];
    }
}

@end
