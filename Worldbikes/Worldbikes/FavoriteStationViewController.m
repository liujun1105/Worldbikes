//
//  FavoriteStationViewController.m
//  Worldbikes
//
//  Created by a亲爱的 我自己 on 16/04/2012.
//  Copyright (c) 2012 Ericsson Software Campus. All rights reserved.
//

#import "FavoriteStationViewController.h"
#import "AlertViewController.h"

@interface FavoriteStationViewController ()

@end

@implementation FavoriteStationViewController
@synthesize favoriteModel = _favoriteModel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupFetchedResultsController];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)setupFetchedResultsController {  
    self.fetchedResultsController = [self.favoriteModel fetchedResultsController];
    assert(nil != self.fetchedResultsController);
}

- (void)viewDidUnload
{
    [self setFavoriteModel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FavoriteCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSDictionary *dict = [self.favoriteModel grabCellRelatedInfomationFrom:[self.fetchedResultsController objectAtIndexPath:indexPath]];

    cell.textLabel.text = [dict objectForKey:@"title"];
    cell.detailTextLabel.text = [dict objectForKey:@"detail"];

    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *path = [self.tableView indexPathForSelectedRow];
    NSDictionary *dict = [self.favoriteModel grabCellRelatedInfomationFrom:[self.fetchedResultsController objectAtIndexPath:path]];

    AlertViewController *alertViewController = [segue destinationViewController];
    alertViewController.favoriteModel = self.favoriteModel;
    alertViewController.cityName = [dict objectForKey:@"cityName"];
    alertViewController.stationID = [[dict objectForKey:@"stationID"] intValue];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
