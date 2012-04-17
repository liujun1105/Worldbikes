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
#import "WorldbikesFavouriteModel.h"

@interface WorldbikesMapViewController ()

@property (nonatomic,strong) CLLocationManager *locationManager;
@property (nonatomic,retain) CLLocation* initialLocation;
@property (nonatomic,strong) NSArray *cities;

@end

@implementation WorldbikesMapViewController
@synthesize mapView = _mapView;
@synthesize locationManager = _locationManager;
@synthesize coreServiceModel = _coreServiceModel;
@synthesize favouriteModel = _favouriteModel;
@synthesize initialLocation = _initialLocation;
@synthesize cities = _cities;

- (void)setCities:(NSArray *)cities
{
    if (_cities != cities) {
        _cities = cities;
    }
}

- (void)viewWillAppear:(BOOL)animated {      
    NSLog(@"view will appear");
    if (nil == self.locationManager) {
        NSLog(@"initlise CLLocationManager");
        self.locationManager = [[CLLocationManager alloc] init];
    }
    
    self.locationManager.delegate = self;
    self.mapView.delegate = self;
    
    
    [self loadAnnotationView];
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
            annotation.isFavourite = [self.favouriteModel isFavouriteStation:[[stationDict valueForKey:@"stationID"] intValue] 
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
        
    //    if (![CLLocationManager locationServicesEnabled]) {
    NSLog(@"location service not enabled");
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
    [self setFavouriteModel:nil];
    [self setCities:nil];
    [self setLocationManager:nil];
    [self setInitialLocation:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma MKMapViewDelegate
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    DetailedStationViewController *detailedViewController = [[DetailedStationViewController alloc] init];
    
    WorldbikesStationAnnotation *annotation = view.annotation;
    NSDictionary *realtimeInfoDict = [self.coreServiceModel realtimeInfoOfStation:annotation.stationID inCity:annotation.cityName];

    detailedViewController.favouriteModel = self.favouriteModel;
    detailedViewController.annotation = annotation;
    detailedViewController.realtimeInfoDict = realtimeInfoDict;
        
    [self.navigationController pushViewController:detailedViewController animated:YES];
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
        [self loadAnnotationView];
    }];
}

#pragma cllocationdelegate
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
