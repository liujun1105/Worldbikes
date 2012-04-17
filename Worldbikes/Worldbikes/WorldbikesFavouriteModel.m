//
//  WorldbikesFavouriteModel.m
//  Worldbikes
//
//  Created by a亲爱的 我自己 on 16/04/2012.
//  Copyright (c) 2012 Ericsson Software Campus. All rights reserved.
//

#import "WorldbikesFavouriteModel.h"
#import "WorldbikesCoreService.h"
#import "Worldbikes.h"

@interface WorldbikesFavouriteModel ()

@property (nonatomic,readonly) WorldbikesCoreService *coreService;

@end

@implementation WorldbikesFavouriteModel
@synthesize coreService = _coreService;

- (id) init
{
    self = [super init];
    if (self) {
        self->_coreService = [WorldbikesFavouriteModel CoreService];
    }
    return self;
}

- (BOOL) addToFavouriteListOfStation:(int)stationID inCity:(NSString *) cityName
{
    BOOL isAdded = [self.coreService updateStation:stationID inCity:cityName asFavourite:YES];
    if (!isAdded) {
        Log(@"failed to add station [%d] of city [%@] into favourite list", stationID, cityName);
    }
    [self.coreService persist];    
    return isAdded;
}

- (BOOL) removeFromFavouriteListOfStation:(int)stationID inCity:(NSString *) cityName
{
    BOOL isRemoved = [self.coreService updateStation:stationID inCity:cityName asFavourite:NO];
    if (!isRemoved) {
        Log(@"failed to remove station [%d] of city [%@] into favourite list", stationID, cityName);
    }    
    [self.coreService persist];
    return isRemoved;
}

- (BOOL) isFavouriteStation:(int) stationID ofCity:(NSString *) cityName
{
    return [self.coreService isFavouriteStation:stationID ofCity:cityName];
}

@end
