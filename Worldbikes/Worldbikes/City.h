//
//  City.h
//  Worldbikes
//
//  Created by a亲爱的 我自己 on 25/04/2012.
//  Copyright (c) 2012 Ericsson Software Campus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Country, Station;

@interface City : NSManagedObject

@property (nonatomic, retain) NSString * cityName;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSNumber * minLat;
@property (nonatomic, retain) NSNumber * maxLat;
@property (nonatomic, retain) NSNumber * minLng;
@property (nonatomic, retain) NSNumber * maxLng;
@property (nonatomic, retain) Country *country;
@property (nonatomic, retain) NSSet *stations;
@end

@interface City (CoreDataGeneratedAccessors)

- (void)addStationsObject:(Station *)value;
- (void)removeStationsObject:(Station *)value;
- (void)addStations:(NSSet *)values;
- (void)removeStations:(NSSet *)values;

@end
