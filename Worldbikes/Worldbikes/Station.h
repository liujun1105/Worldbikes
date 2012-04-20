//
//  Station.h
//  Worldbikes
//
//  Created by a亲爱的 我自己 on 20/04/2012.
//  Copyright (c) 2012 Ericsson Software Campus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Alert, City;

@interface Station : NSManagedObject

@property (nonatomic, retain) NSNumber * isFavorite;
@property (nonatomic, retain) NSString * stationAddress;
@property (nonatomic, retain) NSString * stationFullAddress;
@property (nonatomic, retain) NSNumber * stationID;
@property (nonatomic, retain) NSNumber * stationLatitude;
@property (nonatomic, retain) NSNumber * stationLongitude;
@property (nonatomic, retain) NSString * stationName;
@property (nonatomic, retain) City *city;
@property (nonatomic, retain) NSSet *alerts;
@end

@interface Station (CoreDataGeneratedAccessors)

- (void)addAlertsObject:(Alert *)value;
- (void)removeAlertsObject:(Alert *)value;
- (void)addAlerts:(NSSet *)values;
- (void)removeAlerts:(NSSet *)values;

@end
