//
//  XObjStation.m
//  Worldbikes
//
//  Created by a亲爱的 我自己 on 14/04/2012.
//  Copyright (c) 2012 Ericsson Software Campus. All rights reserved.
//

#import "XObjStation.h"

@implementation XObjStation
@synthesize stationID = _stationID;
@synthesize stationName = _stationName;
@synthesize stationAddress = _stationAddress;
@synthesize stationFullAddress = _stationFullAddress;
@synthesize stationLatitude = _stationLatitude;
@synthesize stationLongitude = _stationLongitude;

- (NSString*) description
{
    return [NSString stringWithFormat:@"%d,%@,%@,%@,%f,%f", self.stationID, self.stationName, self.stationAddress, self.stationFullAddress, self.stationLatitude, self.stationLongitude];
}

@end
