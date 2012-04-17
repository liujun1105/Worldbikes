//
//  StationDAO.h
//  Worldbikes
//
//  Created by a亲爱的 我自己 on 15/04/2012.
//  Copyright (c) 2012 Ericsson Software Campus. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Station;

@interface StationDAO : NSObject
- (Station *) addStation:(NSDictionary *) stationDict inManagedObjectContext:(NSManagedObjectContext *)context;
- (Station *) station:(int) stationID inCity:(NSString *) cityName inManagedObjectContext:(NSManagedObjectContext *)context;
- (NSArray *) allStationsInCity:(NSString *) cityName inManagedObjectContext:(NSManagedObjectContext *)context;
- (BOOL) deleteStation:(int) stationID inCity:(NSString *) cityName inManagedObjectContext:(NSManagedObjectContext *)context;
- (BOOL) updateStation:(int) stationID inCity:(NSString *) cityName asFavourite:(BOOL) favourite inManagedObjectContext:(NSManagedObjectContext *)context;
- (BOOL) isFavouriteStation:(int) stationID ofCity:(NSString *) cityName inManagedObjectContext:(NSManagedObjectContext *)context;

@end
