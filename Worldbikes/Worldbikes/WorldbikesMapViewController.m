//
//  WorldbikesMapViewController.m
//  Worldbikes
//
//  Created by a亲爱的 我自己 on 08/04/2012.
//  Copyright (c) 2012 Ericsson Software Campus. All rights reserved.
//

#import "WorldbikesMapViewController.h"
#import "Worldbikes.h"
#import "WorldbikesCoreServiceModel.h"
#import "WorldbikesStationAnnotation.h"
#import "DetailedStationViewController.h"
#import "WorldbikesFavoriteModel.h"

@interface WorldbikesMapViewController ()

@property (nonatomic,strong) CLLocationManager *locationManager;
@property (nonatomic,retain) CLLocation* initialLocation;
@property (nonatomic,strong) NSArray *cities;
@property (nonatomic,strong) WorldbikesStationAnnotation *annotation;
@end

@implementation WorldbikesMapViewController
@synthesize mapView = _mapView;
@synthesize locationManager = _locationManager;
@synthesize coreServiceModel = _coreServiceModel;
@synthesize favoriteModel = _favoriteModel;
@synthesize activityProgress = _activityProgress;
@synthesize initialLocation = _initialLocation;
@synthesize cities = _cities;
@synthesize annotation = _annotation;

- (void)setCities:(NSArray *)cities
{
    if (_cities != cities) {
        _cities = cities;
    }
}

// private method, which registers all observers;
- (void) registerAsObserver 
{
    /* this obersver monitoring the status of the persist store, 
     * whether it is opened or not */
    [self.coreServiceModel addObserver:self 
                            forKeyPath:@"isPersistStoreOpened" 
                               options:NSKeyValueObservingOptionNew 
                               context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath 
                      ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([@"isPersistStoreOpened" isEqualToString:keyPath]) {
        /* no longer need this observer */
        [self.coreServiceModel removeObserver:self forKeyPath:@"isPersistStoreOpened"];
        /* as the persist store is opened, 
         * we can not read station informations from the persist store */
        [self.activityProgress startAnimating];
        [self loadAnnotationView];    
        [self.activityProgress stopAnimating];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [self.activityProgress startAnimating];
    [self loadAnnotationView];    
    [self.activityProgress stopAnimating];
}

- (void)loadAnnotationView
{
    NSLog(@"loadAnnotation-->>");
    // locates all URL for XML documents of cities that users are interested in,
    // each XML document contains GPS coordinates and metadata for stations of that city.   
    self.cities = [self.coreServiceModel cityPreferences];
    
    // get station information for each city and create an annotation for each station.
    for (NSString *cityName in self.cities) {
        NSLog(@"get station information from [%@]", cityName);
        NSArray *stationData = [self.coreServiceModel allStationsInCity:cityName];
        for (NSDictionary *stationDict in stationData) {            
            double latitude = [[stationDict valueForKey:@"stationLatitude"] doubleValue];
            double longitude = [[stationDict valueForKey:@"stationLongitude"] doubleValue];                    
            CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(latitude, longitude);                        
            WorldbikesStationAnnotation *annotation = [[WorldbikesStationAnnotation alloc] initWithLocation:coord];
            annotation.stationName = [stationDict valueForKey:@"stationName"];
            annotation.stationAddress = [stationDict valueForKey:@"stationAddress"];
            annotation.stationFullAddress = [stationDict valueForKey:@"stationFullAddress"];
            annotation.stationID = [[stationDict valueForKey:@"stationID"] intValue];
            annotation.isFavorite = [self.favoriteModel isFavoriteStation:[[stationDict valueForKey:@"stationID"] intValue] 
                                                                      ofCity:cityName];
            annotation.cityName = cityName;
            NSMutableString *title = [NSMutableString stringWithString:[stationDict valueForKey:@"stationName"]];
            [title appendFormat:@" (%d)", annotation.stationID];
            annotation.title = title;
            annotation.subtitle = [stationDict valueForKey:@"stationFullAddress"];            
            [self.mapView addAnnotation:annotation];
        }
    }
    NSLog(@"<<--loadAnnotation");
}

- (void)viewDidLoad
{
    NSLog(@"view did load");
    [super viewDidLoad];
    
    if (nil == self.locationManager) {
        NSLog(@"initlise CLLocationManager");
        self.locationManager = [[CLLocationManager alloc] init];
    }
    
    self.locationManager.delegate = self;
    self.mapView.delegate = self;
    

    [self.coreServiceModel setup];    
    [self registerAsObserver];
    
    if (![CLLocationManager locationServicesEnabled]) {
        NSLog(@"location service not enabled");
        UIAlertView *alertView = [[UIAlertView alloc] 
                                  initWithTitle:@"Warning" 
                                  message:@"Location Service Not Enabled" 
                                  delegate:self
                                  cancelButtonTitle:@"OK" 
                                  otherButtonTitles: nil];
        [alertView setTag:-1];
        [alertView show];
    }
    MKCoordinateSpan span;
    span.latitudeDelta = 0.076614;
    span.longitudeDelta = 0.146599;
    MKCoordinateRegion region;
    region.center = CLLocationCoordinate2DMake(53.424936,-7.94494);
    region.span = span;
    [self.mapView setRegion:region animated:FALSE];
    [self.mapView regionThatFits:region];   
    
    
    //    }
    //    else {
    //        self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    //        self.locationManager.distanceFilter = 50;
    //        [self.locationManager startUpdatingLocation];
    //    }
}

- (void)viewDidUnload
{
    [self setMapView:nil];
    [self setLocationManager:nil];
    [self setCoreServiceModel:nil];
    [self setFavoriteModel:nil];
    [self setCities:nil];
    [self setLocationManager:nil];
    [self setInitialLocation:nil];
    [self setActivityProgress:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - View lifecycle
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView tag] == -1) {
        if (buttonIndex == 0) {
            // pop the top view controller, which is the current view controller
            // and go back to the calculator interface
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

#pragma mark - MKMapViewDelegate
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
//    DetailedStationViewController *detailedViewController = [[DetailedStationViewController alloc] init];
//    
//    WorldbikesStationAnnotation *annotation = view.annotation;
//    NSDictionary *realtimeInfoDict = [self.coreServiceModel realtimeInfoOfStation:annotation.stationID inCity:annotation.cityName];
//
//    detailedViewController.favoriteModel = self.favoriteModel;
//    detailedViewController.annotation = annotation;
//    detailedViewController.realtimeInfoDict = realtimeInfoDict;

    self.annotation = view.annotation;
    [self performSegueWithIdentifier:@"DetailedStationInformation" sender:self];
    
//    [self.navigationController pushViewController:detailedViewController animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"DetailedStationInformation"]) {
        DetailedStationViewController *detailedViewController = [segue destinationViewController];
        
        WorldbikesStationAnnotation *annotation = self.annotation;
        NSDictionary *realtimeInfoDict = [self.coreServiceModel realtimeInfoOfStation:annotation.stationID inCity:annotation.cityName];
        
        detailedViewController.favoriteModel = self.favoriteModel;
        detailedViewController.annotation = annotation;
        detailedViewController.realtimeInfoDict = realtimeInfoDict;
    }

}

- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    static NSString *identifier = @"WorldbikesStationAnnotationIdentifier";
    
    if ([annotation isKindOfClass:[WorldbikesStationAnnotation class]]) {
        MKPinAnnotationView *pinView = nil;
        pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (!pinView) {
            pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation 
                                                      reuseIdentifier:identifier];
            pinView.canShowCallout = YES;   
            pinView.animatesDrop = FALSE;
            
            UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            [rightButton setTitle:@"Detail" forState:UIControlStateNormal];
            pinView.rightCalloutAccessoryView  = rightButton;            
        }
        else pinView.annotation = annotation;
        
        return pinView;
    }
    
    return nil;
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    CLGeocoder *gecoder = [[CLGeocoder alloc] init];
    [gecoder reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray *placemarks, NSError *error) {
        // load Station GPS coordinates, create a MKAnnotation for each station and 
        // add MKAnnotation to the MKMapView object
//        [self loadAnnotationView];
    }];
}

#pragma mark - cllocationdelegate
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"error: %@", [error localizedDescription]);
    [self.locationManager stopUpdatingLocation];
}

@end
