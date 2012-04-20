//
//  ;
//  Worldbikes
//
//  Created by a亲爱的 我自己 on 09/04/2012.
//  Copyright (c) 2012 Ericsson Software Campus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Worldbikes.h"
#import "WorldbikesAlertPoolDelegate.h"

@class City;
@class Country;
@class Station;
@class Alert;
@class WorldbikesAlertPool;

@interface WorldbikesCoreService : NSObject <WorldbikesAlertPoolDelegate>
@property (nonatomic) BOOL stopAlertPool;
@property (nonatomic,strong) WorldbikesAlertPool *alertPool;

- (void) setupAlertPoolWithDelegate:(id) delegate;

- (City *) addCity:(NSString*) cityName withURLPath:(NSString*) url toCountry:(NSString*) countryName;
- (City *) city:(NSString*) cityName;
- (BOOL) removeCity:(NSString*) cityName;
- (NSArray*) userCities;
//- (NSArray*) preferenceCityURLs;

- (Station *) addStation:(NSDictionary *) stationDict;
- (NSArray *) allStationsInCity:(NSString *) cityName;
- (BOOL) deleteStation:(int) stationID inCity:(NSString *) cityName;
- (Station *) station:(int) stationID inCity:(NSString *) cityName;

- (NSString*) realtimeInfoPathOfStation:(int) stationID inCity:(NSString*) cityName;

- (BOOL) updateStation:(int) stationID inCity:(NSString*) cityName asFavorite:(BOOL) isFavorite;
- (BOOL) isFavoriteStation:(int) stationID ofCity:(NSString *) cityName;

+ (NSString*) fullUrlPath:(NSString*) partial;
+ (NSString*) fullRealtimeInfoUrlPath:(NSString*) partial ofStation:(int) stationID;

- (UIManagedDocument *) openPersistentStore;

- (id) fetchedResultsController;
- (NSDictionary *) grabCellRelatedInfomationFrom:(id) data;

-(Alert*) addAlertWithID:(NSString*) alertID andType:(NSString*) alertType toStation:(int) stationID inCity:(NSString*) cityName;
-(BOOL) deleteAlertWithID:(NSString*) alertID andType:(NSString*) alertType;
-(BOOL) hasAlertSet:(NSString*) alertID;
@end
