//
//  TestWorldbikesFavoriteModel.m
//  Worldbikes
//
//  Created by a亲爱的 我自己 on 16/04/2012.
//  Copyright (c) 2012 Ericsson Software Campus. All rights reserved.
//

#import "TestWorldbikesFavoriteModel.h"
#import "WorldbikesFavoriteModel.h"
#import "StationDAO.h"
#import "Station.h"
#import "City+CRUD.h"
#import "CityDAO.h"
#import <CoreData/CoreData.h>

@interface TestWorldbikesFavoriteModel ()
@property (nonatomic,strong) WorldbikesFavoriteModel *favoriteModel;
@property (nonatomic,strong) CityDAO *cityDAO;
@property (nonatomic,strong) StationDAO *stationDAO;
@property (nonatomic,strong) NSDictionary *stationDict;
@property (nonatomic,strong) NSManagedObjectModel *model;
@property (nonatomic,strong) NSPersistentStoreCoordinator *coordinator;
@property (nonatomic,strong) NSManagedObjectContext *context;
@end

@implementation TestWorldbikesFavoriteModel
@synthesize favoriteModel = _favoriteModel;
@synthesize cityDAO = _cityDAO;
@synthesize stationDAO = _stationDAO;
@synthesize stationDict = _stationDict;
@synthesize model = _model;
@synthesize coordinator = _coordinator;
@synthesize context = _context;

- (void) setUp
{
    self.model = [NSManagedObjectModel mergedModelFromBundles:[NSBundle allBundles]];
    self.coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.model];
    self.context = [[NSManagedObjectContext alloc] init];
    self.context.persistentStoreCoordinator = self.coordinator;
    self.favoriteModel = [[WorldbikesFavoriteModel alloc] init];
    self.stationDAO = [[StationDAO alloc] init];
    self.cityDAO = [[CityDAO alloc] init];
    self.stationDict = [NSDictionary dictionaryWithObjectsAndKeys:
                        @"test station", @"stationName",
                        [NSNumber numberWithInt:1], @"stationID",
                        @"short address", @"stationAddress", 
                        @"full address", @"stationFullAddress", 
                        [NSNumber numberWithDouble:56.24358], @"stationLatitude",
                        [NSNumber numberWithDouble:-9.53687], @"stationLongitude",
                        nil];
}

- (void) testWorldbikesFavoriteModel_Init
{
    STAssertNotNil(self.favoriteModel, @"initialisation failure");
}

- (void) testWorldbikesFavoriteModel_AddStationToFavoriteList
{
    City *city = [self.cityDAO addCity:@"Dublin" withUrlPath:nil inManagedObjectContext:self.context];
    STAssertNotNil(city, nil);
    
    Station *station = [self.stationDAO addStation:self.stationDict inManagedObjectContext:self.context];
    [city addStationsObject:station];
    station.city = city;
    
    STAssertNotNil(station.city, nil);    
    STAssertFalse([station.isFavorite boolValue], @"%d", station.isFavorite);
    
    [self.favoriteModel addToFavoriteListOfStation:1 inCity:@"Dublin"];
    STAssertTrue([station.isFavorite boolValue], @"%d", station.isFavorite);
}

@end
