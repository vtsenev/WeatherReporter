//
//  AddCityViewController.m
//  WeatherReporter
//
//  Created by Vladimir Tsenev on 6/11/12.
//  Copyright (c) 2012 MentorMate. All rights reserved.
//

#import "AddCityViewController.h"
#import "City.h"
#import "DataManager.h"
#import "CountyPickerTableViewController.h"
#import "GeoLocationResponse.h"
#import "ConnectionManager.h"
#import "Constants.h"
#import "Helpers.h"
#import "User.h"

@interface AddCityViewController ()

@property (retain, nonatomic) IBOutlet UITextField *cityNameField;
@property (retain, nonatomic) IBOutlet UITextField *countryField;
@property (retain, nonatomic) IBOutlet UITextField *latitudeField;
@property (retain, nonatomic) IBOutlet UITextField *longitudeField;
@property (nonatomic, retain) UIView *activityIndicator;
@property (retain, nonatomic) IBOutlet UIButton *getLocationBtn;
@property (nonatomic, assign) BOOL isCityFound;
@property (nonatomic, assign) BOOL isGoingBackToParentView;

- (void)initializeActivityIndicator;
- (void)userInteractionEnabled:(BOOL)isEnabled;
- (BOOL)isCityValid;
- (void)updateCity;

- (IBAction)addCity:(id)sender;
- (IBAction)getLocation:(id)sender;

@end

@implementation AddCityViewController
@synthesize city;
@synthesize cityNameField;
@synthesize countryField;
@synthesize latitudeField;
@synthesize longitudeField;
@synthesize delegate;
@synthesize activityIndicator;
@synthesize getLocationBtn;
@synthesize isCityFound;
@synthesize isGoingBackToParentView;
@synthesize user;

- (void)dealloc {
    [activityIndicator release];
    [city release];
    [cityNameField release];
    [countryField release];
    [latitudeField release];
    [longitudeField release];
    [getLocationBtn release];
    [super dealloc];
}

- (void)viewDidUnload {
    [self setActivityIndicator:nil];
    [self setCity:nil];
    [self setCityNameField:nil];
    [self setCountryField:nil];
    [self setLatitudeField:nil];
    [self setLongitudeField:nil];
    [self setGetLocationBtn:nil];
    [super viewDidUnload];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self.navigationItem setTitle:@"Add City"];
        UIBarButtonItem *addBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(addCity:)];
        [self.navigationItem setRightBarButtonItem:addBtn];
        [addBtn release];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeActivityIndicator];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setIsCityFound:NO];
    self.isGoingBackToParentView = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    if (![self isCityValid] && isGoingBackToParentView) {
//        if ([self.delegate respondsToSelector:@selector(didCancelCity:)]) {
//            [self.delegate didCancelCity:self.city];
//        }
//    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)initializeActivityIndicator {
    self.activityIndicator = [[[NSBundle mainBundle] loadNibNamed:@"LoadingView" owner:nil options:nil] objectAtIndex:0];
    CGRect newFrame = self.activityIndicator.frame;
    newFrame.size.height = self.view.frame.size.height - 49.0f;
    self.activityIndicator.frame = newFrame;
}

- (void)userInteractionEnabled:(BOOL)isEnabled {
    [self.cityNameField setUserInteractionEnabled:isEnabled];
    [self.countryField setUserInteractionEnabled:isEnabled];
    [self.latitudeField setUserInteractionEnabled:isEnabled];
    [self.longitudeField setUserInteractionEnabled:isEnabled];
    [self.getLocationBtn setUserInteractionEnabled:isEnabled];
}

- (IBAction)getLocation:(id)sender {
    self.latitudeField.text = @"";
    self.longitudeField.text = @"";
    if (([self.cityNameField.text isEqualToString:emptyString]) || ([self.countryField.text isEqualToString:emptyString])) {
        self.isCityFound = NO;
        [Helpers showAlertViewWithTitle:invalidCityErrorType withMessage:invalidCityError withDelegate:self];
    } else {
        [self requestLatitudeAndLongitudeForCity:self.cityNameField.text inCountry:self.countryField.text];
    }
}

- (BOOL)isCityValid {
    BOOL validity = self.isCityFound;
    if ([self.cityNameField.text isEqualToString:emptyString] || [self.countryField.text isEqualToString:emptyString] ||
        [self.latitudeField.text isEqualToString:emptyString] || [self.longitudeField.text isEqualToString:emptyString]) {
        return NO;
    }
    return validity;
}

- (IBAction)addCity:(id)sender {
    if ([self isCityValid]) {
        self.city = [[DataManager defaultDataManager] addCityForUsername:self.user.username];
        [self updateCity];
        
        if ([self.delegate respondsToSelector:@selector(didUpdateCity:)]) {
            [self.delegate didUpdateCity:self.city];
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        self.isCityFound = NO;
        [Helpers showAlertViewWithTitle:invalidCityErrorType withMessage:cityNotFoundError withDelegate:self];
    }
}

- (void)updateCity {
    self.city.name = self.cityNameField.text;
    self.city.country = self.countryField.text;
    self.city.latitude = [NSDecimalNumber decimalNumberWithString:self.latitudeField.text];
    self.city.longitude = [NSDecimalNumber decimalNumberWithString:self.longitudeField.text];
}

# pragma mark - UITextFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    BOOL success = [textField resignFirstResponder];
    return success;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.isCityFound = NO;
    if (textField.tag == 1) {
        self.isGoingBackToParentView = NO;
        [textField resignFirstResponder];
        CountyPickerTableViewController *countryPickerViewController = [[CountyPickerTableViewController alloc] initWithStyle:UITableViewStylePlain];
        countryPickerViewController.delegate = self;
        [self presentViewController:countryPickerViewController animated:YES completion:NULL];
        [countryPickerViewController release];
    }
}

# pragma mark - CountryPickerDelegate methods

- (void)didSelectCountry:(NSString *)country {
    self.isGoingBackToParentView = YES;
    countryField.text = country;
    if (![self.cityNameField.text isEqualToString:emptyString]) {
        [self requestLatitudeAndLongitudeForCity:self.cityNameField.text inCountry:country];
    }
}

- (void)requestLatitudeAndLongitudeForCity:(NSString *)cityName inCountry:(NSString *)country {
    [self.view addSubview:self.activityIndicator];
    [self userInteractionEnabled:NO];
    [[ConnectionManager defaultConnectionManager] getGeoLocationInformationForCity:cityName inCountry:country withDelegate:self];
}

# pragma mark - CustomConnectionDelegate

- (void)connectionDidFailWithError:(NSString *)errorMessage {
    [self.activityIndicator removeFromSuperview];
    [self userInteractionEnabled:YES];
    self.isCityFound = NO;
    [Helpers showAlertViewWithTitle:invalidCityErrorType withMessage:cityNotFoundError withDelegate:self];
}

- (void)connectionDidSucceedWithParsedData:(NSObject *)parsedData {
    self.isCityFound = YES;
    GeoLocationResponse *geoLocationResponse = (GeoLocationResponse *)parsedData;
    [self.latitudeField setText:[geoLocationResponse.geoLocationInformation objectForKey:@"latitude"]];
    [self.longitudeField setText:[geoLocationResponse.geoLocationInformation objectForKey:@"longitude"]];
    [self.activityIndicator removeFromSuperview];
    [self userInteractionEnabled:YES];
}

@end
