//
//  TestWorldbikesCoreService.m
//  Worldbikes
//
//  Created by a亲爱的 我自己 on 09/04/2012.
//  Copyright (c) 2012 Ericsson Software Campus. All rights reserved.
//

#import "TestWorldbikesCoreService.h"
#import "City+CRUD.h"
#import "Country+CRUD.h"
#import "CountryDAO.h"
#import "CityDAO.h"
#import "WorldbikesCoreService.h"

@interface TestWorldbikesCoreService ()
@property (nonatomic,strong) NSManagedObjectModel *model;
@property (nonatomic,strong) NSPersistentStoreCoordinator *coordinator;
@property (nonatomic,strong) NSManagedObjectContext *context;
@property (nonatomic,strong) CountryDAO *countryDAO;
@property (nonatomic,strong) CityDAO *cityDAO;
@property (nonatomic,strong) WorldbikesCoreService *coreService;
@property (nonatomic,strong) NSString *cityName;
@property (nonatomic,strong) NSString *countryName;

@end

@implementation TestWorldbikesCoreService
@synthesize countryDAO = _countryDAO;
@synthesize cityDAO = _cityDAO;
@synthesize coreService = _coreService;
@synthesize model = _model;
@synthesize coordinator = _coordinator;
@synthesize context = _context;
@synthesize cityName = _cityName;
@synthesize countryName = _countryName;

- (void) setUp
{
    self.countryName = @"Ireland";
    self.cityName = @"Dublin";
    self.model = [NSManagedObjectModel mergedModelFromBundles:[NSBundle allBundles]];
    self.coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.model];
    self.context = [[NSManagedObjectContext alloc] init];
    self.context.persistentStoreCoordinator = self.coordinator;
    self.countryDAO = [[CountryDAO alloc] init];
    self.cityDAO = [[CityDAO alloc] init];
    self.coreService = [[WorldbikesCoreService alloc] init];
}

- (void) tearDown
{
    [self setModel:nil];
    [self setContext:nil];
    [self setCoordinator:nil];
    [self setCountryDAO:nil];
    [self setCityDAO:nil];
    [self setCoreService:nil];
}

- (void) testCoreService_AddCityToCountry
{
    City *city = [self.coreService addCity:self.cityName toCountry:self.countryName inManagedObjectContext:self.context];
    STAssertNotNil(city, @"failed to add city using WorldbikesCoreService");
    
    int numberOfCountries = [self.countryDAO numberOfCountryInManagedObjectContext:self.context];    
    STAssertEquals(numberOfCountries, 1, @"failed to create country object using WorldbikesCoreService");
    
    STAssertNotNil([city country], @"city-country mapping is not setup");
    STAssertTrue([city.country.countryName isEqualToString:self.countryName], @"%@ is not a city of %@", city.cityName, self.countryName);    
}

- (void) testCoreService_RemoveCity
{
    [self.coreService addCity:self.cityName toCountry:self.countryName inManagedObjectContext:self.context];
    [self.coreService addCity:@"Athlone" toCountry:self.countryName inManagedObjectContext:self.context];
    
    Country *country = [self.countryDAO country:self.countryName inManagedObjectContext:self.context];
    
    STAssertTrue([country.cities count] == 2, @"incorrect number of cities");
    
    [self.coreService removeCity:self.cityName inManagedObjectContext:self.context];
    
    STAssertTrue([country.cities count] == 1, @"incorrect number of cities");
}

- (void) testCoreService_RemoveAllCities
{
    [self.coreService addCity:self.cityName toCountry:self.countryName inManagedObjectContext:self.context];
    [self.coreService addCity:@"Athlone" toCountry:self.countryName inManagedObjectContext:self.context];
    
    Country *country = [self.countryDAO country:self.countryName inManagedObjectContext:self.context];
    
    STAssertTrue([country.cities count] == 2, @"incorrect number of cities");
    
    [self.coreService removeCity:self.cityName inManagedObjectContext:self.context];
    [self.coreService removeCity:@"Athlone" inManagedObjectContext:self.context];
    
    STAssertTrue([country.cities count] == 0, @"incorrect number of cities");
    
    country = [self.countryDAO country:self.countryName inManagedObjectContext:self.context];
    STAssertNil(country, @"");
}

@end
