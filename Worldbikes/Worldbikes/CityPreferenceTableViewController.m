//
//  CitySettingViewController.m
//  Worldbikes
//
//  Created by a亲爱的 我自己 on 08/04/2012.
//  Copyright (c) 2012 Ericsson Software Campus. All rights reserved.
//

#import "CityPreferenceTableViewController.h"
#import "WorldbikesAppDelegate.h"

@interface CityPreferenceTableViewController ()
@property (nonatomic,strong) NSArray *cities;
@property (nonatomic,strong) NSString *cityName;
@end

@implementation CityPreferenceTableViewController
@synthesize preference = _preference;
@synthesize countryName = _countryName;
@synthesize countryIndex = _countryIndex;
@synthesize cities = _cities;
@synthesize cityName = _cityName;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {

    }
    return self;
}


- (void) loadCities
{
    self.cities = [self.preference cityPreferences];
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
    [self.navigationController setNavigationBarHidden:NO];
}


- (void)viewDidUnload
{
    [self setPreference:nil];
    [super viewDidUnload];
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
    
    [[WorldbikesAppDelegate sharedAppDelegate] showActivityView];
    [self.navigationItem setHidesBackButton:YES];
    
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {        
        /*
         * if a city is removed, the station informations are also deleted
         */
        
        dispatch_queue_t removeQ = dispatch_queue_create("Remove Stations", NULL);
        dispatch_async(removeQ, ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"remove stations of city %@", cityName);
                UIAlertView *alertView;
                BOOL success = [self.preference removeCity:cityName];
                if (success) {
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    self.cityName = cityName;
                    alertView.tag = 1;
                }
                else {
                    alertView = [[UIAlertView alloc] 
                                 initWithTitle:@"Remove City Preference"
                                 message:@"Remove Failed"
                                 delegate:self
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles: nil];
                    alertView.tag = 11;
                }
                [[WorldbikesAppDelegate sharedAppDelegate] hideActivityView];
                [self.navigationItem setHidesBackButton:NO];         
                [alertView show];                
            });
        });
        dispatch_release(removeQ);
    }
    else {
        
        /* 
         * when a new city is added, downloading station metadata for that city, e.g., geolocation data 
         */
        
        NSString *url = [self.preference urlOfCityAtIndex:indexPath.row ofcountryAtIndex:self.countryIndex];
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:TRUE];
        dispatch_queue_t downloadQ = dispatch_queue_create("Download Stations", NULL);
        dispatch_async(downloadQ, ^{
            dispatch_async(dispatch_get_main_queue(), ^{  
                BOOL success = YES;
                @try {
                    [self.preference addCity:cityName withURLPath:url toCountry:self.countryName];
                    NSLog(@"download stations of city %@", cityName);
                    [self.preference downloadStationDataOfCity:cityName];
                }
                @catch (NSException *exception) {
                    Log(@"%@", exception.reason);
                    [self.preference removeCity:cityName];
                    success = FALSE;
                }
                @finally {
                    UIAlertView *alertView;
                    if (success) {
                        alertView = [[UIAlertView alloc] 
                                                  initWithTitle:@"Station Data Download" 
                                                  message:@"Data downloaded"
                                                  delegate:self
                                                  cancelButtonTitle:@"OK" 
                                                  otherButtonTitles: nil];

                        // if success, update the cell
                        cell.accessoryType = UITableViewCellAccessoryCheckmark;
                        self.cityName = cityName;
                        alertView.tag = 2;                        
                    }
                    else {
                        alertView = [[UIAlertView alloc] 
                                                  initWithTitle:@"Station Data Download"
                                                  message:@"Download Failed"
                                                  delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles: nil];    
                        alertView.tag = 21;
                    }
                    [alertView show];
                }
                [[WorldbikesAppDelegate sharedAppDelegate] hideActivityView];
                [self.navigationItem setHidesBackButton:NO];
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:FALSE];
            });
        });
        dispatch_release(downloadQ);
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView tag] == 1) {
        Log(@"remove stations");
        if (buttonIndex == 0) {
            /* this updates the MKAnnotationViews */
            [[NSNotificationCenter defaultCenter] postNotificationName:@"isPersistentStoreContentChanged" 
                                                                object:nil 
                                                              userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                        self.cityName, @"cityName", 
                                                                        [NSNumber numberWithBool:YES], @"isForDeletion",
                                                                        nil]];
        }
    }
    else if ([alertView tag] == 2) {
        Log(@"add stations");        
        if (buttonIndex == 0) {
            /* this updates the MKAnnotationViews */
            [[NSNotificationCenter defaultCenter] postNotificationName:@"isPersistentStoreContentChanged" 
                                                                object:nil 
                                                              userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                        self.cityName, @"cityName", 
                                                                        [NSNumber numberWithBool:NO], @"isForDeletion",
                                                                        nil]];
        }
    }    
}

@end
