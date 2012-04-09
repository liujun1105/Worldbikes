//
//  CitySettingViewController.m
//  Worldbikes
//
//  Created by a亲爱的 我自己 on 08/04/2012.
//  Copyright (c) 2012 Ericsson Software Campus. All rights reserved.
//

#import "CitySettingViewController.h"

@interface CitySettingViewController ()

@end

@implementation CitySettingViewController
@synthesize citySettingModel = _citySettingModel;
@synthesize countryName = _countryName;
@synthesize countryIndex = _countryIndex;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

//- (void)setEditing:(BOOL)editing animated:(BOOL)animate
//{
//    [super setEditing:editing animated:animate];
//    if(editing)
//    {
//        NSLog(@"editMode on");
//    }
//    else
//    {
//        NSLog(@"Done leave editmode");
//    }
//}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [self setCitySettingModel:nil];
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
    return [self.citySettingModel numberOfCitiesInCountryAtIndex:self.countryIndex];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.countryName;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SupportedCityCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell.textLabel.text = [self.citySettingModel nameOfCityAtIndex:indexPath.row OfCountryAtIndex:self.countryIndex];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        NSString *cityName = [self.citySettingModel nameOfCityAtIndex:indexPath.row OfCountryAtIndex:self.countryIndex];
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
}


@end
