//
//  WorldbikesFavouriteModel.h
//  Worldbikes
//
//  Created by a亲爱的 我自己 on 16/04/2012.
//  Copyright (c) 2012 Ericsson Software Campus. All rights reserved.
//

#import "WorldbikesCoreServiceModel.h"

@interface WorldbikesFavouriteModel : WorldbikesCoreServiceModel

- (BOOL) addToFavouriteListOfStation:(int)stationID inCity:(NSString *) cityName;
- (BOOL) removeFromFavouriteListOfStation:(int)stationID inCity:(NSString *) cityName;
- (BOOL) isFavouriteStation:(int) stationID ofCity:(NSString *) cityName;

@end
