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
@synthesize initialLocation = _initialLocation;
@synthesize cities = _cities;
@synthesize annotation = _annotation;


- (void)setCities:(NSArray *)cities
{
    if (_cities != cities) {
        _cities = cities;
    }
    else {
        Log(@"->> setCities(), same cities");
    }
}

// private method, which registers all observers;
- (void) registerAsObserver 
{
    /* this obersver monitoring the status of the persist store, 
     * whether it is opened or not */
    [self.coreServiceModel addObserver:self 
                            forKeyPath:@"isPersistentStoreOpened" 
                               options:NSKeyValueObservingOptionNew 
                               context:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(updateAnnotations:) 
                                                 name:@"isPersistentStoreContentChanged" 
                                               object:nil];     
}

- (void) deregisterAsObserver
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"isPersistentStoreContentChanged" object:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath 
                      ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([@"isPersistentStoreOpened" isEqualToString:keyPath]) {
        /* no longer need this observer */
        [self.coreServiceModel removeObserver:self forKeyPath:@"isPersistentStoreOpened"];
        /* as the persist store is opened, 
         * we can not read station informations from the persist store */
        [self loadAnnotations];    
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    CLLocationCoordinate2D userCoordinate = CLLocationCoordinate2DMake(53.344104,-6.267494);
    dispatch_queue_t nearest = dispatch_queue_create("nearest", NULL);
    dispatch_async(nearest, ^{
        NSArray *annotations = [self.mapView annotations];
        double min = NSIntegerMax;
        WorldbikesStationAnnotation *minimum;
        for (WorldbikesStationAnnotation *annotation in annotations) {
            if ([annotation respondsToSelector:@selector(cityName)]) {
                double curr = sqrt(pow((userCoordinate.latitude - annotation.coordinate.latitude), 2.0) + 
                                   pow((userCoordinate.longitude - annotation.coordinate.longitude), 2.0));
                if (min > curr) {
                    minimum = annotation;
                    min = curr;
                }
            }
        }
        NSLog(@"nearest station is [%@]",minimum.stationName);
    });
}

- (void)viewDidAppear:(BOOL)animated
{
    Log(@"viewDidAppear");
    [super viewDidAppear:animated]; 
}

- (void)updateAnnotations:(NSNotification *) notification
{
    NSDictionary *dict = [notification userInfo];
    [self loadAnnotations:[dict valueForKey:@"cityName"] withOption:[[dict valueForKey:@"isForDeletion"] boolValue]];
}

- (void)loadAnnotations:(NSString*) cityName withOption:(BOOL) isForDeletion
{
    /* THIS IS NOT A GOOD SOLUTION, BUT I WILL USE IT FOR THE MOMENT*/
    Log(@"City Name %@, isForDeletion %d", cityName, isForDeletion);
    if (isForDeletion) {
        
        dispatch_queue_t deleteAnnotations = dispatch_queue_create("Delete Annotations", NULL);
        dispatch_async(deleteAnnotations, ^{
            NSArray *annotations = [self.mapView annotations];
           
            NSMutableArray *toBeRemoved = [NSMutableArray array];
            for (WorldbikesStationAnnotation *annotation in annotations) {
                if ([annotation respondsToSelector:@selector(cityName)]) {
                    if ([annotation.cityName isEqualToString:cityName]) {
                        [toBeRemoved addObject:annotation];
                    }
                }
            }
            [self.mapView removeAnnotations:toBeRemoved];
        });

    }
    else {
        dispatch_queue_t loadSingleAnnotation = dispatch_queue_create("Loading Single Annotation", NULL);
        dispatch_async(loadSingleAnnotation, ^{
            // to avoid uncaught exception "... was mutated while being enumerated"
            NSArray *stationData = [NSArray arrayWithArray:[self.coreServiceModel allStationsInCity:cityName]];
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
        });
        dispatch_release(loadSingleAnnotation);
    }
}

- (void)loadAnnotations
{
    Log(@"Start loadAnnotation");
  
    self.cities = [self.coreServiceModel cityPreferences];
    
    // get station information for each city and create an annotation for each station.
    for (NSString *cityName in self.cities) {
        Log(@"get station information from [%@]", cityName);
        [self loadAnnotations:cityName withOption:NO];
    }
    
    Log(@"END loadAnnotation");
}

- (void)viewDidLoad
{
    NSLog(@"view did load");
    [super viewDidLoad];
    
    [self.coreServiceModel initAlertPoolWithDelegate];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Refresh" 
                                                                             style:UIBarButtonSystemItemAdd 
                                                                            target:self 
                                                                            action:nil];

    
    if (nil == self.locationManager) {
        NSLog(@"initlise CLLocationManager");
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.mapView.delegate = self;
    }

    [self.coreServiceModel setup];    
    [self registerAsObserver];
    
    [self.mapView setZoomEnabled:YES];
    [self.mapView setScrollEnabled:YES];
    [self.mapView setShowsUserLocation:YES];
    
//    if (![CLLocationManager locationServicesEnabled]) {
        NSLog(@"location service not enabled");
        UIAlertView *alertView = [[UIAlertView alloc] 
                                  initWithTitle:@"Warning" 
                                  message:@"Location Service Not Enabled" 
                                  delegate:self
                                  cancelButtonTitle:@"OK" 
                                  otherButtonTitles: nil];
        [alertView show];
        MKCoordinateSpan span;
        span.latitudeDelta = 0.076614;
        span.longitudeDelta = 0.146599;
        MKCoordinateRegion region;
        region.center = CLLocationCoordinate2DMake(53.344104,-6.267494);
        region.span = span;
        [self.mapView setRegion:region animated:FALSE];
        [self.mapView regionThatFits:region];
//    }   
//    else {
    
        CLLocation *userLoc = self.mapView.userLocation.location;
        CLLocationCoordinate2D userCoordinate = 
                    CLLocationCoordinate2DMake(userLoc.coordinate.latitude, userLoc.coordinate.longitude);
        
        NSLog(@"user latitude = %f",userCoordinate.latitude);
        NSLog(@"user longitude = %f",userCoordinate.longitude);
//    }
    

}

- (void)viewDidUnload
{
    [self.coreServiceModel stopAlertPoolService];
    [self deregisterAsObserver];
    [self setMapView:nil];
    [self setLocationManager:nil];
    [self setCoreServiceModel:nil];
    [self setFavoriteModel:nil];
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
    self.annotation = view.annotation;
    [self performSegueWithIdentifier:@"DetailedStationInformation" sender:self];
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

}

#pragma mark - cllocationdelegate
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    Log(@"location updated");
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"error: %@", [error localizedDescription]);
    [self.locationManager stopUpdatingLocation];
}

@end
