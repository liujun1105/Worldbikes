//
//  Station.h
//  Worldbikes
//
//  Created by a亲爱的 我自己 on 06/04/2012.
//  Copyright (c) 2012 Ericsson Software Campus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class City;

@interface Station : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSDecimalNumber * available;
@property (nonatomic, retain) NSDecimalNumber * free;
@property (nonatomic, retain) NSString * fullAddress;
@property (nonatomic, retain) NSNumber * lat;
@property (nonatomic, retain) NSNumber * lng;
@property (nonatomic, retain) NSDecimalNumber * stationID;
@property (nonatomic, retain) NSDecimalNumber * ticket;
@property (nonatomic, retain) NSDecimalNumber * total;
@property (nonatomic, retain) City *city;

@end
