//
//  CityTableViewCell.h
//  WeatherReporter
//
//  Created by Vladimir Tsenev on 6/13/12.
//  Copyright (c) 2012 MentorMate. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CityTableViewCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UIImageView *flagImageView;
@property (retain, nonatomic) IBOutlet UILabel *cityLabel;
@property (retain, nonatomic) IBOutlet UILabel *countryLabel;
//@property (assign, nonatomic) id<> delegate;

- (IBAction)showMap:(id)sender;

@end
