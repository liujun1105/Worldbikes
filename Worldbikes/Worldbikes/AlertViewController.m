//
//  AlertViewController.m
//  Worldbikes
//
//  Created by a亲爱的 我自己 on 19/04/2012.
//  Copyright (c) 2012 Ericsson Software Campus. All rights reserved.
//

#import "AlertViewController.h"
#import "WorldbikesFavoriteModel.h"
#import "WorldbikesAlertPool.h"
#import "Alert+EXT.h"
#import "Worldbikes.h"
@interface AlertViewController ()

@end

@implementation AlertViewController
@synthesize freeStandsSwitch = _freeStandsSwitch;
@synthesize availableBikesSwitch = _availableBikesSwitch;
@synthesize alertTableView = _alertTableView;
@synthesize favoriteModel = _favoriteModel;
@synthesize stationID = _stationID;
@synthesize cityName = _cityName;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(updateSwitches:) 
                                                 name:@"UpdateAlertSwitch" 
                                               object:nil];    
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSString *alertID = [NSString stringWithFormat:@"%@_%d_%@",self.cityName,self.stationID,BikeAvailableAlert];
    if ([self.favoriteModel hasAlertSet:alertID]) {
        [self.availableBikesSwitch setOn:YES];
    }
    alertID = [NSString stringWithFormat:@"%@_%d_%@",self.cityName,self.stationID,FreeStandsAlert];
    if ([self.favoriteModel hasAlertSet:alertID]) {
        [self.freeStandsSwitch setOn:YES];
    }
}

- (void)viewDidUnload
{
    [self setFreeStandsSwitch:nil];
    [self setAvailableBikesSwitch:nil];
    [self setAlertTableView:nil];
    [self setFavoriteModel:nil];
    [super viewDidUnload];

    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:@"UpdateAlertSwitch" 
                                                  object:nil];
}

- (void)updateSwitches:(NSNotification *) notification
{
    NSDictionary *dict = notification.userInfo;
    if ([[dict valueForKey:@"alertType"] isEqualToString:BikeAvailableAlert]) {
        [self.availableBikesSwitch setOn:NO];
    }
    else if ([[dict valueForKey:@"alertType"] isEqualToString:FreeStandsAlert]) {
        [self.freeStandsSwitch setOn:NO];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)availableBikeAlertStatusChanged:(UISwitch *)sender 
{
    NSString *alertID = [NSString stringWithFormat:@"%@_%d_%@",self.cityName,self.stationID,BikeAvailableAlert];
    Log(@"%@",alertID);
    if (sender.on) {
        [self.favoriteModel addAlertWithID:alertID andType:BikeAvailableAlert toStation:self.stationID inCity:self.cityName];    
    }
    else {
        [self.favoriteModel deleteAlertWithID:alertID andType:BikeAvailableAlert];
    }
    
}

- (IBAction)freeStandsAlertStatusChanged:(UISwitch *)sender 
{
    NSString *alertID = [NSString stringWithFormat:@"%@_%d_%@",self.cityName,self.stationID,FreeStandsAlert];
    Log(@"%@",alertID);
    if (sender.on) {
        [self.favoriteModel addAlertWithID:alertID andType:FreeStandsAlert toStation:self.stationID inCity:self.cityName];
    }
    else {
        [self.favoriteModel deleteAlertWithID:alertID andType:FreeStandsAlert];
    }
}
@end
