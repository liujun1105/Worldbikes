//
//  TestMOCountry.m
//  Worldbikes
//
//  Created by a亲爱的 我自己 on 07/04/2012.
//  Copyright (c) 2012 Ericsson Software Campus. All rights reserved.
//

#import "TestMOCountry.h"
#import "Country+CRUD.h"
#import "City+CRUD.h"
#import "Station.h"

@interface TestMOCountry ()

@property (nonatomic,strong) Country *country;
@property (nonatomic,strong) City *city;
@property (nonatomic,strong) Station *station;
@property (nonatomic,strong) NSManagedObjectModel *model;
@property (nonatomic,strong) NSPersistentStoreCoordinator *coordinator;
@property (nonatomic,strong) NSManagedObjectContext *context;

@end

@implementation TestMOCountry

@synthesize country = _country;
@synthesize city = _city;
@synthesize station = _station;
@synthesize model = _model;
@synthesize coordinator = _coordinator;
@synthesize context = _context;

- (void)setUp
{
    [super setUp];
    self.model = [NSManagedObjectModel mergedModelFromBundles:[NSBundle allBundles]];    
    self.coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.model];
    self.context = [[NSManagedObjectContext alloc] init];
    self.context.persistentStoreCoordinator = self.coordinator;
}

-(void) tearDown
{
    [super tearDown];
    [self setModel:nil];
    [self setContext:nil];
    [self setCoordinator:nil];
}

-(void) testCountry_AddCity
{
    self.country = [NSEntityDescription insertNewObjectForEntityForName:@"Country" inManagedObjectContext:self.context];
    self.country.countryName = @"Ireland";
    self.city = [NSEntityDescription insertNewObjectForEntityForName:@"City" inManagedObjectContext:self.context];
    self.city.cityName = @"Dublin";
    [self.country addCitiesObject:self.city];    
    STAssertTrue([self.country.cities count]==1, @"failed to add city");   
    self.city = [[self.country.cities allObjects] objectAtIndex:0];    
    STAssertTrue([self.city.cityName isEqualToString:@"Dublin"], @"wrong assignment");
}

-(void) testCountry_SetCity
{
    int loopNumber = 10;
    
    self.country = [NSEntityDescription insertNewObjectForEntityForName:@"Country" inManagedObjectContext:self.context];
    
    NSMutableSet *set = [NSMutableSet set];
    for (int i=0; i<loopNumber; i++) {
        [set addObject:[NSEntityDescription insertNewObjectForEntityForName:@"City" inManagedObjectContext:self.context]];
    }
    STAssertTrue([set count] == loopNumber, @"invalid set count number");
    [self.country addCities:set];
    
    STAssertTrue([self.country.cities count] == loopNumber, @"invalid city number");
    
}

-(void) testCity_AddCity
{
    self.city = [NSEntityDescription insertNewObjectForEntityForName:@"City" inManagedObjectContext:self.context];
    self.city.cityName = @"Dublin";
    self.station = [NSEntityDescription insertNewObjectForEntityForName:@"Station" inManagedObjectContext:self.context];
    self.station.stationID = [NSNumber numberWithInt:1];
    [self.city addStationsObject:self.station];
    STAssertTrue([self.city.stations count]==1, @"failed to add station");   
    self.station = [[self.city.stations allObjects] objectAtIndex:0];    
    STAssertEquals([self.station.stationID intValue], 1, @"wrong assignment");
}

-(void) testCity_SetStation
{
    int loopNumber = 10;
    
    self.city = [NSEntityDescription insertNewObjectForEntityForName:@"City" inManagedObjectContext:self.context];
    
    NSMutableSet *set = [NSMutableSet set];
    for (int i=0; i<loopNumber; i++) {
        [set addObject:[NSEntityDescription insertNewObjectForEntityForName:@"Station" inManagedObjectContext:self.context]];
    }
    STAssertTrue([set count] == loopNumber, @"invalid set count number");
    [self.city addStations:set];
    
    STAssertTrue([self.city.stations count] == loopNumber, @"invalid station number");
    
}

@end
