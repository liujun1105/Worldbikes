//
//  Station.h
//  Worldbikes
//
//  Created by a亲爱的 我自己 on 07/04/2012.
//  Copyright (c) 2012 Ericsson Software Campus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class City;

@interface Station : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSNumber * available;
@property (nonatomic, retain) NSNumber * free;
@property (nonatomic, retain) NSString * fullAddress;
@property (nonatomic, retain) NSNumber * lat;
@property (nonatomic, retain) NSNumber * lng;
@property (nonatomic, retain) NSNumber * stationID;
@property (nonatomic, retain) NSNumber * ticket;
@property (nonatomic, retain) NSNumber * total;
@property (nonatomic, retain) City *city;

@end
