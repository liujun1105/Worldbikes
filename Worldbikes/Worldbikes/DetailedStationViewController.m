//
//  DetailedStationViewController.m
//  Worldbikes
//
//  Created by a亲爱的 我自己 on 15/04/2012.
//  Copyright (c) 2012 Ericsson Software Campus. All rights reserved.
//

#import "DetailedStationViewController.h"
#import "WorldbikesFavoriteModel.h"

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
@synthesize favoriteModel = _favoriteModel;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {        

    }
    return self;
}

- (void) stopAnimating:(NSNotification *) notification
{
    NSLog(@"stop animating");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:notification.name object:nil];
    [self.savingProgress stopAnimating];
    [self.navigationItem setHidesBackButton:NO];
    [self.navigationItem.rightBarButtonItem setEnabled:YES];
}

- (IBAction)addToFavorite:(UIBarButtonItem *)sender
{
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(stopAnimating:) 
                                                 name:@"FavoriteListUpdated" 
                                               object:nil];
    [self.savingProgress setHidden:NO];
    [self.savingProgress startAnimating];
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
    [self.favoriteModel addToFavoriteListOfStation:[self.stationID.text intValue] inCity:self.city.text];
    [self.annotation setIsFavorite:YES];
    [self.navigationItem.rightBarButtonItem setTitle:@"Remove"];
}

- (IBAction)removeFromFavorite:(UIBarButtonItem *)sender
{
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(stopAnimating:) 
                                                 name:@"FavoriteListUpdated" 
                                               object:nil]; 
    [self.savingProgress setHidden:NO];    
    [self.savingProgress startAnimating];
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationItem.rightBarButtonItem setEnabled:NO];    

    [self.favoriteModel removeFromFavoriteListOfStation:[self.stationID.text intValue] inCity:self.city.text];  
    [self.annotation setIsFavorite:NO];    
    [self.navigationItem.rightBarButtonItem setTitle:@"Add"];     
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.savingProgress = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.savingProgress.center = self.view.center;
    [self.view addSubview:self.savingProgress];
    [self.savingProgress setColor:[UIColor blackColor]];
    [self.savingProgress setHidden:YES];
    
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
    
    if (!self.annotation.isFavorite) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Add" 
                                                                                  style:UIBarButtonSystemItemAdd 
                                                                                 target:self 
                                                                                 action:@selector(addToFavorite:)];
    }
    else {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Remove" 
                                                                                  style:UIBarButtonSystemItemUndo 
                                                                                 target:self 
                                                                                 action:@selector(removeFromFavorite:)];
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
    [self setFavoriteModel:nil];
    [self setSavingProgress:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
