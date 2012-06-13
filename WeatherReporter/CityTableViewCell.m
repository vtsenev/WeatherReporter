//
//  CityTableViewCell.m
//  WeatherReporter
//
//  Created by Vladimir Tsenev on 6/13/12.
//  Copyright (c) 2012 MentorMate. All rights reserved.
//

#import "CityTableViewCell.h"

@implementation CityTableViewCell
@synthesize flagImageView;
@synthesize cityLabel;
@synthesize countryLabel;

- (void)dealloc {
    [flagImageView release];
    [cityLabel release];
    [countryLabel release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)showMap:(id)sender {
    
}

@end
