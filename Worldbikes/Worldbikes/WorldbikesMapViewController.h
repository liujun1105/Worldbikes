//
//  WorldbikesMapViewController.h
//  Worldbikes
//
//  Created by a亲爱的 我自己 on 08/04/2012.
//  Copyright (c) 2012 Ericsson Software Campus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#define METERS_PER_MILE 1609.344

@interface WorldbikesMapViewController : UIViewController
@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@end
