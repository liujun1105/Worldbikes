//
//  WorldbikesStationAnnotation.m
//  Worldbikes
//
//  Created by a亲爱的 我自己 on 14/04/2012.
//  Copyright (c) 2012 Ericsson Software Campus. All rights reserved.
//

#import "WorldbikesStationAnnotation.h"

@implementation WorldbikesStationAnnotation
@synthesize stationID = _stationID;
@synthesize stationName = _stationName;
@synthesize stationAddress = _stationAddress;
@synthesize stationFullAddress = _stationFullAddress;
@synthesize title = _title;
@synthesize subtitle = _subtitle;
@synthesize coordinate = _coordinate;
@synthesize cityName = _cityName;
@synthesize isFavorite = _isFavorite;

- (id) initWithLocation:(CLLocationCoordinate2D)cood
{
    self = [super init];
    if (self) {
        self->_coordinate = cood;
    }
    return self;
}

@end
