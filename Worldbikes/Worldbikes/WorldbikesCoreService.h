//
//  ;
//  Worldbikes
//
//  Created by a亲爱的 我自己 on 09/04/2012.
//  Copyright (c) 2012 Ericsson Software Campus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Worldbikes.h"

@class City;
@class Country;
@class Station;


@interface WorldbikesCoreService : NSObject

- (City *) addCity:(NSString*) cityName withURLPath:(NSString*) url toCountry:(NSString*) countryName;
- (City *) city:(NSString*) cityName;
- (void) removeCity:(NSString*) cityName;
- (NSArray*) userCities;
//- (NSArray*) preferenceCityURLs;

- (Station *) addStation:(NSDictionary *) stationDict;
- (NSArray *) allStationsInCity:(NSString *) cityName;
- (BOOL) deleteStation:(int) stationID inCity:(NSString *) cityName;
- (Station *) station:(int) stationID inCity:(NSString *) cityName;

- (NSString*) realtimeInfoPathOfStation:(int) stationID inCity:(NSString*) cityName;

- (BOOL) updateStation:(int) stationID inCity:(NSString*) cityName asFavorite:(BOOL) isFavorite;
- (BOOL) isFavoriteStation:(int) stationID ofCity:(NSString *) cityName;

- (NSString*) fullUrlPath:(NSString*) partial;
- (NSString*) fullRealtimeInfoUrlPath:(NSString*) partial ofStation:(int) stationID;

- (UIManagedDocument *) openPersistStore;

- (id) fetchedResultsController;
- (NSDictionary *) grabCellRelatedInfomationFrom:(id) data;
@end
