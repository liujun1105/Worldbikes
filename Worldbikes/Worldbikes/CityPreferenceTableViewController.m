//
//  CitySettingViewController.m
//  Worldbikes
//
//  Created by a亲爱的 我自己 on 08/04/2012.
//  Copyright (c) 2012 Ericsson Software Campus. All rights reserved.
//

#import "CityPreferenceTableViewController.h"


@interface CityPreferenceTableViewController ()
@property (nonatomic,strong) NSArray *cities;

@end

@implementation CityPreferenceTableViewController
@synthesize preference = _preference;
@synthesize countryName = _countryName;
@synthesize countryIndex = _countryIndex;
@synthesize cities = _cities;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) loadCities
{
    self.cities = [self.preference cityPreferences];
    Log(@"%d", [self.cities count]);
}

- (void) setCities:(NSArray *)cities
{
    if (_cities != cities) {
        _cities = cities;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [self loadCities];
    [super viewWillAppear:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}


- (void)viewDidUnload
{
    [self setPreference:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.preference numberOfCitiesInCountryAtIndex:self.countryIndex];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.countryName;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SupportedCityCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell.textLabel.text = [self.preference nameOfCityAtIndex:indexPath.row OfCountryAtIndex:self.countryIndex];
    // reading stored data, check if cities have been selected before
    if ([self.cities containsObject:cell.textLabel.text]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cityName = [self.preference nameOfCityAtIndex:indexPath.row OfCountryAtIndex:self.countryIndex];    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:TRUE];
        dispatch_queue_t removeQ = dispatch_queue_create("Remove Stations", NULL);
        dispatch_async(removeQ, ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"remove stations of city %@", cityName);
//                [self.preference removeStationDataOfCity:cityName];
                [self.preference removeCity:cityName];
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:FALSE];
            });
        });
        dispatch_release(removeQ);
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        NSString *url = [self.preference urlOfCityAtIndex:indexPath.row ofcountryAtIndex:self.countryIndex];
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:TRUE];
        dispatch_queue_t downloadQ = dispatch_queue_create("Download Stations", NULL);
        dispatch_async(downloadQ, ^{
            dispatch_async(dispatch_get_main_queue(), ^{     
                [self.preference addCity:cityName withURLPath:url toCountry:self.countryName];
                NSLog(@"download stations of city %@", cityName);
                [self.preference downloadStationDataOfCity:cityName];
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:FALSE];
            });
        });
        dispatch_release(downloadQ);
    }
}


@end
