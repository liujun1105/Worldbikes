//
//  WorldbikesStationAnnotation.h
//  Worldbikes
//
//  Created by a亲爱的 我自己 on 14/04/2012.
//  Copyright (c) 2012 Ericsson Software Campus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface WorldbikesStationAnnotation : NSObject <MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title, *subtitle;

@property (nonatomic, copy) NSString *stationName;
@property (nonatomic) int stationID;
@property (nonatomic, copy) NSString *stationAddress;
@property (nonatomic, copy) NSString *stationFullAddress;
@property (nonatomic, copy) NSString *cityName;

@property (nonatomic) BOOL isFavorite;

- (id)initWithLocation:(CLLocationCoordinate2D) cood;

@end
