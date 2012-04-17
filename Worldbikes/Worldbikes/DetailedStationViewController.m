//
//  DetailedStationViewController.m
//  Worldbikes
//
//  Created by a亲爱的 我自己 on 15/04/2012.
//  Copyright (c) 2012 Ericsson Software Campus. All rights reserved.
//

#import "DetailedStationViewController.h"
#import "WorldbikesFavouriteModel.h"

@interface DetailedStationViewController ()

@end

@implementation DetailedStationViewController
@synthesize savingProgress = _savingProgress;
@synthesize stationID = _stationID;
@synthesize stationName = _stationName;
@synthesize stationLatitude = _stationLatitude;
@synthesize stationLongitude = _stationLongitude;
@synthesize stationFullAddress = _stationFullAddress;
@synthesize availableBikes = _availableBikes;
@synthesize freeStands = _freeStands;
@synthesize total = _total;
@synthesize city = _city;
@synthesize realtimeInfoDict = _realtimeInfoDict;
@synthesize annotation = _annotation;
@synthesize favouriteModel = _favouriteModel;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {          
    }
    return self;
}

- (IBAction)addToFavourite:(UIBarButtonItem *)sender
{
    [self.savingProgress startAnimating];

    [self.favouriteModel addToFavouriteListOfStation:[self.stationID.text intValue] inCity:self.city.text];
    [self.navigationItem.rightBarButtonItem setTitle:@"Remove"];
    [self.savingProgress stopAnimating];
}

- (IBAction)removeFromFavourite:(UIBarButtonItem *)sender
{
    [self.savingProgress startAnimating];
    [self.favouriteModel removeFromFavouriteListOfStation:[self.stationID.text intValue] inCity:self.city.text];    
    [self.navigationItem.rightBarButtonItem setTitle:@"Add"];    
    [self.savingProgress stopAnimating];    
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    [self.city setText:self.annotation.cityName];
    
    self.stationID.text = [NSString stringWithFormat:@"%d",self.annotation.stationID];
    self.stationName.text = self.annotation.stationName;
    self.stationFullAddress.text = self.annotation.stationFullAddress;
    self.stationLatitude.text = [NSString stringWithFormat:@"%f", self.annotation.coordinate.latitude];
    self.stationLongitude.text = [NSString stringWithFormat:@"%f", self.annotation.coordinate.longitude];
    self.freeStands.text = [NSString stringWithFormat:@"%d", [[self.realtimeInfoDict valueForKey:@"stands"] intValue]];
    self.availableBikes.text = [NSString stringWithFormat:@"%d", [[self.realtimeInfoDict valueForKey:@"available"] intValue]];
    self.total.text = [NSString stringWithFormat:@"%d", [[self.realtimeInfoDict valueForKey:@"total"] intValue]];
    
    if (!self.annotation.isFavourite) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Add" 
                                                                                  style:UIBarButtonSystemItemAdd 
                                                                                 target:self 
                                                                                 action:@selector(addToFavourite:)];
    }
    else {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Remove" 
                                                                                  style:UIBarButtonSystemItemUndo 
                                                                                 target:self 
                                                                                 action:@selector(removeFromFavourite:)];
    }
    
}

- (void)viewDidUnload
{
    [self setStationID:nil];
    [self setStationName:nil];
    [self setStationLatitude:nil];
    [self setStationLongitude:nil];
    [self setStationFullAddress:nil];
    [self setAvailableBikes:nil];
    [self setFreeStands:nil];
    [self setTotal:nil];
    [self setCity:nil];
    [self setFavouriteModel:nil];
    [self setSavingProgress:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
