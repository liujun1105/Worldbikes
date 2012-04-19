//
//  WorldbikesFavoriteModel.m
//  Worldbikes
//
//  Created by a亲爱的 我自己 on 16/04/2012.
//  Copyright (c) 2012 Ericsson Software Campus. All rights reserved.
//

#import "WorldbikesFavoriteModel.h"
#import "WorldbikesCoreService.h"
#import "Worldbikes.h"
#import "WorldbikesServiceProvider.h"

@interface WorldbikesFavoriteModel ()

@property (nonatomic,readonly) WorldbikesCoreService *coreService;

@end

@implementation WorldbikesFavoriteModel
@synthesize coreService = _coreService;

- (id) init
{
    self = [super init];
    if (self) {
        self->_coreService = [WorldbikesServiceProvider CoreService];
    }
    return self;
}

- (BOOL) addToFavoriteListOfStation:(int)stationID inCity:(NSString *) cityName
{
    BOOL isAdded = [self.coreService updateStation:stationID inCity:cityName asFavorite:YES];
    if (!isAdded) {
        Log(@"failed to add station [%d] of city [%@] into favorite list", stationID, cityName);
    }
    return isAdded;
}

- (BOOL) removeFromFavoriteListOfStation:(int)stationID inCity:(NSString *) cityName
{
    BOOL isRemoved = [self.coreService updateStation:stationID inCity:cityName asFavorite:NO];
    if (!isRemoved) {
        Log(@"failed to remove station [%d] of city [%@] into favorite list", stationID, cityName);
    }    
    return isRemoved;
}

- (BOOL) isFavoriteStation:(int) stationID ofCity:(NSString *) cityName
{
    return [self.coreService isFavoriteStation:stationID ofCity:cityName];
}

- (id) fetchedResultsController
{
    return [self.coreService fetchedResultsController];
}

- (NSDictionary *) grabCellRelatedInfomationFrom:(id) data
{
    return [self.coreService grabCellRelatedInfomationFrom:data];
}

@end
