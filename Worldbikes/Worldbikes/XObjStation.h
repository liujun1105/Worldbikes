//
//  XObjStation.h
//  Worldbikes
//
//  Created by a亲爱的 我自己 on 14/04/2012.
//  Copyright (c) 2012 Ericsson Software Campus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XObjStation : NSObject
@property (nonatomic) int stationID;
@property (nonatomic) double stationLatitude;
@property (nonatomic) double stationLongitude;

@property (nonatomic,strong) NSString *stationName;
@property (nonatomic,strong) NSString *stationAddress;
@property (nonatomic,strong) NSString *stationFullAddress;
@end
