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
#import "WorldbikesAppDelegate.h"
#import "MKMapView+ZoomLevel.h"

@interface WorldbikesMapViewController ()

@property (nonatomic,strong) CLLocationManager *locationManager;
@property (nonatomic,retain) CLLocation* initialLocation;
@property (nonatomic,strong) NSArray *cities;
@property (nonatomic,strong) WorldbikesStationAnnotation *annotation;
@property (nonatomic,strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic,strong) MKPinAnnotationView *userDefaultLocation;
@property (nonatomic,strong) NSMutableDictionary *regionBoundaryDict;
@end

@implementation WorldbikesMapViewController
@synthesize mapView = _mapView;
@synthesize locationButton = _locationButton;
@synthesize locationManager = _locationManager;
@synthesize coreServiceModel = _coreServiceModel;
@synthesize favoriteModel = _favoriteModel;
@synthesize initialLocation = _initialLocation;
@synthesize cities = _cities;
@synthesize annotation = _annotation;
@synthesize activityIndicator = _activityIndicator;
@synthesize userDefaultLocation = _userDefaultLocation;
@synthesize regionBoundaryDict = _regionBoundaryDict;


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
                        [self.regionBoundaryDict removeObjectForKey:cityName];
                    }
                }
            }
            [self.mapView removeAnnotations:toBeRemoved];
        });
        dispatch_release(deleteAnnotations);
    }
    else {

        dispatch_queue_t loadSingleAnnotation = dispatch_queue_create("Loading Single Annotation", NULL);
        dispatch_async(loadSingleAnnotation, ^{
            
            NSDictionary *regionBoundary = [self.coreServiceModel regionBoundary:cityName];
            
            double minLat = [[regionBoundary valueForKey:@"minLat"] doubleValue];
            double minLng = [[regionBoundary valueForKey:@"minLng"] doubleValue];
            double maxLat = [[regionBoundary valueForKey:@"maxLat"] doubleValue];
            double maxLng = [[regionBoundary valueForKey:@"maxLng"] doubleValue];
            
            MKCoordinateRegion region;
            
            float latitude = (minLat+maxLat)/2;
            float longitude = (minLng+maxLng)/2;
            
            region.center = CLLocationCoordinate2DMake(latitude, longitude);
            
            MKCoordinateSpan span;
            span.latitudeDelta = fabs(minLat-maxLat);
            span.longitudeDelta = fabs(minLng-maxLng);
            region.span = span;
            
            NSValue *valueForRegion = [NSValue valueWithBytes:&region objCType:@encode(MKCoordinateRegion)];
            [self.regionBoundaryDict setObject:valueForRegion forKey:cityName];

            // to avoid uncaught exception "... was mutated while being enumerated"
            NSArray *stationData = [self.coreServiceModel allStationsInCity:cityName];
            NSMutableArray *annotations = [NSMutableArray array];
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
                [annotations addObject:annotation];
            }
            [self.mapView addAnnotations:annotations];
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


- (void) viewDidLoad
{
    [super viewDidLoad];
    
    // this dictionary stores the boundary values of each city
    // stations are all located within these boundary values (region)
    self.regionBoundaryDict = [NSMutableDictionary dictionary];

    [self.coreServiceModel initAlertPoolWithDelegate];
    
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
    
    if (![CLLocationManager locationServicesEnabled]) {        
        NSLog(@"location service not enabled");
        UIAlertView *alertView = [[UIAlertView alloc] 
                                  initWithTitle:@"Warning" 
                                  message:@"Location Service Not Enabled" 
                                  delegate:self
                                  cancelButtonTitle:@"OK" 
                                  otherButtonTitles: nil];
        [alertView show];
        
        
        /* set default location to Dublin */
        
        MKCoordinateRegion region;
        
        float latitude = (53.330091 + 53.359246)/2;
        float longitude = (-6.278214 + -6.245575)/2;
        
        region.center = CLLocationCoordinate2DMake(latitude, longitude);
        
        MKCoordinateSpan span;
        span.latitudeDelta = fabs(53.330091 - 53.359246);
        span.longitudeDelta = fabs(-6.278124 - -6.245575);
        region.span = span;
        
        [self.mapView setRegion:region animated:YES];
        [self.mapView regionThatFits:region];
    }   
    else {
        [self.locationManager startUpdatingLocation];
    }
    

}

- (void)viewDidUnload
{
    [self.locationManager stopUpdatingLocation];
    [self.coreServiceModel stopAlertPoolService];
    [self deregisterAsObserver];
    [self setMapView:nil];
    [self setLocationManager:nil];
    [self setCoreServiceModel:nil];
    [self setFavoriteModel:nil];
    [self setCities:nil];
    [self setLocationManager:nil];
    [self setInitialLocation:nil];
    [self setLocationButton:nil];
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
    else if ([alertView tag] == 10) {
        if (buttonIndex == 0) {
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs://"]];
            }
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

- (void) mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    if (error.code ==  kCLErrorDenied) {    
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Warning" 
                                                            message:@"failed to locate location, make sure location service is turned on" 
                                                           delegate:self 
                                                  cancelButtonTitle:@"OK" 
                                                  otherButtonTitles:nil];
        alertView.tag = 10;
        [alertView show];
        

    }
}    

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    Log(@"User location update %f,%f", userLocation.coordinate.latitude, userLocation.coordinate.longitude);
    if ([self.mapView showsUserLocation]) {        
        [self.mapView setCenterCoordinate:self.mapView.userLocation.location.coordinate zoomLevel:10 animated:NO];
    }
    
    // the following code block checks whether users are within the region of a city
    // my original idea was to only present station information of stations in a city when
    // user enters that city, however, as users should be able to set alert to stations to monitor
    // their status, therefore, they should see the station iormation (Annotation) even when they are 
    // far from the stations. For the moment, this block of code is left here only for testing purpose.
    for (NSString *key in self.regionBoundaryDict) {
        NSValue *value = [self.regionBoundaryDict objectForKey:key];
        MKCoordinateRegion region;
        [value getValue:&region];
        
        double latDelta = fabs(region.center.latitude - userLocation.coordinate.latitude);
        double lngDelta = fabs(region.center.longitude - userLocation.coordinate.longitude);

        NSLog(@"%f,%f,%f,%f", latDelta,lngDelta, region.span.latitudeDelta,region.span.longitudeDelta);
        
        if (latDelta < region.span.latitudeDelta && lngDelta < region.span.longitudeDelta) {
            NSLog(@"within region of %@", key);
        }
    }    
}

#pragma mark - cllocationdelegate
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    Log(@"location updated from (%f,%f) to (%f,%f)", oldLocation.coordinate.latitude, oldLocation.coordinate.longitude, newLocation.coordinate.latitude, newLocation.coordinate.longitude);
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"error: %@", [error localizedDescription]);
    [self.locationManager stopUpdatingLocation];
}


- (IBAction)locateNearestStationPressed:(UIBarButtonItem *)sender 
{
    BOOL foundNearestStation = NO;
    Log(@"finding user current location");
    [[WorldbikesAppDelegate sharedAppDelegate] showActivityView];

    for (NSString *key in self.regionBoundaryDict) {
        NSValue *value = [self.regionBoundaryDict objectForKey:key];
        MKCoordinateRegion region;
        [value getValue:&region];
        
        double latDelta = fabs(region.center.latitude - self.mapView.userLocation.coordinate.latitude);
        double lngDelta = fabs(region.center.longitude - self.mapView.userLocation.coordinate.longitude);
        
        if (latDelta < region.span.latitudeDelta && lngDelta < region.span.longitudeDelta) {
            double minimumDistance = MAXFLOAT;
            WorldbikesStationAnnotation *nearestStation;
            for (WorldbikesStationAnnotation *annotation in self.mapView.annotations) {
                if ([annotation respondsToSelector:@selector(cityName)]) {
                    if ([annotation.cityName isEqualToString:key]) {
                        double distance = sqrt(pow((self.mapView.userLocation.coordinate.latitude - annotation.coordinate.latitude), 2.0) + 
                                           pow((self.mapView.userLocation.coordinate.longitude - annotation.coordinate.longitude), 2.0));
                        if (minimumDistance > distance) {
                            minimumDistance = distance;
                            nearestStation = annotation;
                        }
                    }
                }
            }
            
            [[WorldbikesAppDelegate sharedAppDelegate] hideActivityView];
            
            [self.mapView selectAnnotation:nearestStation animated:NO];
            [self.mapView setCenterCoordinate:nearestStation.coordinate zoomLevel:14 animated:YES];

            foundNearestStation = YES;
            
            break;
        }
    }   
    
    if (foundNearestStation) {
        [self.locationManager startUpdatingLocation];
        return;
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Info" 
                                                        message:@"either no cities selected or none of the stations is close to your current location" 
                                                       delegate:self 
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles:nil];
    [alertView show];    
    
    [[WorldbikesAppDelegate sharedAppDelegate] hideActivityView];
}

@end
