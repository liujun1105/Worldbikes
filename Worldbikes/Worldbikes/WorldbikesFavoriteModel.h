//
//  WorldbikesFavoriteModel.h
//  Worldbikes
//
//  Created by a亲爱的 我自己 on 16/04/2012.
//  Copyright (c) 2012 Ericsson Software Campus. All rights reserved.
//

#import "WorldbikesCoreServiceModel.h"

@interface WorldbikesFavoriteModel : WorldbikesCoreServiceModel

- (BOOL) addToFavoriteListOfStation:(int)stationID inCity:(NSString *) cityName;
- (BOOL) removeFromFavoriteListOfStation:(int)stationID inCity:(NSString *) cityName;
- (BOOL) isFavoriteStation:(int) stationID ofCity:(NSString *) cityName;

- (id) fetchedResultsController;
- (NSDictionary *) grabCellRelatedInfomationFrom:(id) data;

-(void) addAlertWithID:(NSString*) alertID andType:(NSString*) alertType toStation:(int) stationID inCity:(NSString*) cityName;
-(BOOL) deleteAlertWithID:(NSString*) alertID andType:(NSString*) alertType;
-(BOOL) hasAlertSet:(NSString*) alertID;
@end
