//
//  SettingTableViewController.m
//  Worldbikes
//
//  Created by a亲爱的 我自己 on 08/04/2012.
//  Copyright (c) 2012 Ericsson Software Campus. All rights reserved.
//

#import "CountrySettingTableViewController.h"
#import "XMLParserDelegate.h"
#import "CitySettingViewController.h"

@interface CountrySettingTableViewController ()

@end

@implementation CountrySettingTableViewController
@synthesize countrySettingModel = _settingModel;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadSupportedCountries
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:TRUE];
    dispatch_queue_t downloadQ = dispatch_queue_create("Bycicle Scheme Supported Countries Download", NULL);
    dispatch_async(downloadQ, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.countrySettingModel setup];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:FALSE];
        });
    });
    dispatch_release(downloadQ);
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadSupportedCountries];
}

- (void)viewDidUnload
{
    [self setCountrySettingModel:nil];
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
    
    return [self.countrySettingModel countrySize];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SupportedCountryCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    cell.textLabel.text = [self.countrySettingModel nameOfCountryAtIndex:indexPath.row];
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
     NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    
    CitySettingViewController *citySettingViewController = [segue destinationViewController];
    [citySettingViewController setCountryName:[self.countrySettingModel nameOfCountryAtIndex:indexPath.row]];
    [citySettingViewController setCountryIndex:indexPath.row];
    [citySettingViewController setCitySettingModel:self.countrySettingModel];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
