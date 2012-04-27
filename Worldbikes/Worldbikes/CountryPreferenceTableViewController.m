//
//  SettingTableViewController.m
//  Worldbikes
//
//  Created by a亲爱的 我自己 on 08/04/2012.
//  Copyright (c) 2012 Ericsson Software Campus. All rights reserved.
//

#import "CountryPreferenceTableViewController.h"

@interface CountryPreferenceTableViewController ()
@property (nonatomic,strong) NSMutableArray *displayItems;
@end

@implementation CountryPreferenceTableViewController
@synthesize displayItems = _displayItems;
@synthesize preference = _preference;
@synthesize countrySearchBar = _countrySearchBar;
@synthesize countryTableView = _countryTableView;

- (void)loadSupportedCountries
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:TRUE];
    dispatch_queue_t downloadQ = dispatch_queue_create("Bycicle Scheme Supported Countries Download", NULL);
    dispatch_async(downloadQ, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.preference setup];
            self.displayItems = [NSMutableArray array];
            int numberOfCountry = [self.preference countrySize];
            for (int i=0; i<numberOfCountry; i++) {
                [self.displayItems addObject:[self.preference nameOfCountryAtIndex:i]];
            }
            [self.countryTableView reloadData];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:FALSE];
        });
    });
    dispatch_release(downloadQ);
    
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // not need for it, hide it
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.countrySearchBar.delegate = self;
    self.countryTableView.delegate = self;
    self.countryTableView.dataSource = self;
    
    [self loadSupportedCountries];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShown:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void) keyboardShown:(NSNotification *) notification
{
    CGRect keyboardFrame;
    [[[notification userInfo] objectForKey:UIKeyboardDidShowNotification] getValue:&keyboardFrame];
    CGRect tableViewFrame = self.countryTableView.frame;
    tableViewFrame.size.height -= keyboardFrame.size.height;
    [self.countryTableView setFrame:tableViewFrame];
}

- (void) keyboardHidden:(NSNotification *) notification
{
    CGRect keyboardFrame;
    [[[notification userInfo] objectForKey:UIKeyboardDidHideNotification] getValue:&keyboardFrame];
    CGRect tableViewFrame = self.countryTableView.frame;
    tableViewFrame.size.height += keyboardFrame.size.height;    
    [self.countryTableView setFrame:tableViewFrame];
}

- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    [self setPreference:nil];
    [self setCountrySearchBar:nil];
    [self setCountryTableView:nil];
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
    return [self.displayItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SupportedCountryCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell.textLabel.text = [self.displayItems objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.countryTableView indexPathForCell:sender];
 
    if ([segue.identifier isEqualToString:@"CountryPreferenceToCityPreferenceSegue"]) {
        CityPreferenceTableViewController *citySettingViewController = [segue destinationViewController];

        
        int numberOfCountry = [self.preference countrySize];
        NSLog(@"%d",indexPath.row);
        for (int i=0; i<numberOfCountry; i++) {
            if ([[self.displayItems objectAtIndex:indexPath.row] isEqualToString:[self.preference nameOfCountryAtIndex:i]]) {
                [citySettingViewController setCountryName:[self.preference nameOfCountryAtIndex:i]];
                [citySettingViewController setCountryIndex:i];
                break;
            }
        }
        [citySettingViewController setPreference:self.preference];
    }
    
    
}

#pragma mark - Search bar delegate methods
- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    Log(@"search for %@", searchText);
    if (searchText.length == 0) {
        assert(nil != self.displayItems);
        [self.displayItems removeAllObjects];
        int numberOfCountry = [self.preference countrySize];
        for (int i=0; i<numberOfCountry; i++) {
            [self.displayItems addObject:[self.preference nameOfCountryAtIndex:i]];
        }

    }
    else {
        [self.displayItems removeAllObjects];
        int numberOfCountry = [self.preference countrySize];
        for (int i=0; i<numberOfCountry; i++) {
            NSString* countryName = [self.preference nameOfCountryAtIndex:i];
            NSRange range = [countryName rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if (range.location != NSNotFound) {
                [self.displayItems addObject:countryName];
            }
        }
    }
    [self.countryTableView reloadData];
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (void) searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.countrySearchBar setText:@""];
    [searchBar resignFirstResponder];
}


@end
