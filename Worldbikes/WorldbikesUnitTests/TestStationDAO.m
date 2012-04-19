//
//  TestStationDAO.m
//  Worldbikes
//
//  Created by a亲爱的 我自己 on 15/04/2012.
//  Copyright (c) 2012 Ericsson Software Campus. All rights reserved.
//

#import "TestStationDAO.h"
#import "StationDAO.h"
#import "CityDAO.h"
#import "City+CRUD.h"
#import "Station.h"
#import <CoreData/CoreData.h>

@interface TestStationDAO ()

@property (nonatomic,strong) NSString *countryName;
@property (nonatomic,strong) NSString *cityName;
@property (nonatomic,strong) NSManagedObjectModel *model;
@property (nonatomic,strong) NSPersistentStoreCoordinator *coordinator;
@property (nonatomic,strong) NSManagedObjectContext *context;
@property (nonatomic,strong) StationDAO *stationDAO;
@property (nonatomic,strong) CityDAO *cityDAO;
@property (nonatomic,strong) NSDictionary *stationDict;
@end

@implementation TestStationDAO
@synthesize model = _model;
@synthesize coordinator = _coordinator;
@synthesize context = _context;
@synthesize countryName = _countryName;
@synthesize cityName = _cityName;
@synthesize stationDict = _stationDict;
@synthesize stationDAO = _stationDAO;
@synthesize cityDAO = _cityDAO;

- (void) setUp
{
    [super setUp];
    self.cityName = @"Dublin";
    self.countryName = @"Ireland";
    self.model = [NSManagedObjectModel mergedModelFromBundles:[NSBundle allBundles]];
    self.coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.model];
    self.context = [[NSManagedObjectContext alloc] init];
    self.context.persistentStoreCoordinator = self.coordinator;
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

- (void) tearDown
{
    [self setModel:nil];
    [self setContext:nil];
    [self setCoordinator:nil];
    [self setStationDAO:nil];
}

- (void) testStationDAO_AddStation
{
    Station *station = [self.stationDAO addStation:self.stationDict inManagedObjectContext:self.context];
    STAssertNotNil(station, @"failed to add a station");
    
    STAssertTrue([station.stationID intValue]==1, @"incorrect station id");
    STAssertTrue([station.stationName isEqualToString:@"test station"], @"incorrect station name");
    STAssertTrue([station.stationAddress isEqualToString:@"short address"], @"incorrect address");
    STAssertTrue([station.stationFullAddress isEqualToString:@"full address"], @"incorrect full address");    
    STAssertTrue([station.stationLatitude doubleValue]==56.24358, @"incorrect station latitude");
    STAssertTrue([station.stationLongitude doubleValue]==-9.53687, @"incorrect station longitude");
}

- (void) testStationDAO_UpdateStation
{
    City *city = [self.cityDAO addCity:self.cityName withUrlPath:nil inManagedObjectContext:self.context];
    STAssertNotNil(city, nil);
    
    Station *station = [self.stationDAO addStation:self.stationDict inManagedObjectContext:self.context];
    [city addStationsObject:station];
    station.city = city;
    
    STAssertNotNil(station.city, nil);
    
    STAssertFalse([station.isFavorite boolValue], @"%d", station.isFavorite);
    
    STAssertTrue([self.stationDAO updateStation:1 inCity:self.cityName asFavorite:YES inManagedObjectContext:self.context], nil);
    
    station = [self.stationDAO station:1 inCity:self.cityName inManagedObjectContext:self.context];
    
    STAssertTrue([station.isFavorite boolValue], @"%d", station.isFavorite);
}

@end
