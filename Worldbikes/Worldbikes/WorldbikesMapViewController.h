//
//  WorldbikesMapViewController.h
//  Worldbikes
//
//  Created by a亲爱的 我自己 on 08/04/2012.
//  Copyright (c) 2012 Ericsson Software Campus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@class WorldbikesFavoriteModel;
@class WorldbikesCoreServiceModel;

@interface WorldbikesMapViewController : UIViewController<MKMapViewDelegate,CLLocationManagerDelegate>
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet WorldbikesCoreServiceModel *coreServiceModel;
@property (strong, nonatomic) IBOutlet WorldbikesFavoriteModel *favoriteModel;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityProgress;

@end
