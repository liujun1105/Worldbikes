//
//  MKMapView+ZoomLevel.h
//  Worldbikes
//
//  Created by a亲爱的 我自己 on 26/04/2012.
//  Copyright (c) 2012 Ericsson Software Campus. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MKMapView (ZoomLevel)
- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
                  zoomLevel:(NSUInteger)zoomLevel
                   animated:(BOOL)animated;
@end
