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
#import "ModelContextTestDelegate.h"

@interface TestWorldbikesCoreService ()
@property (nonatomic,strong) CountryDAO *countryDAO;
@property (nonatomic,strong) CityDAO *cityDAO;
@property (nonatomic,strong) WorldbikesCoreService *coreService;
@property (nonatomic,strong) NSString *cityName;
@property (nonatomic,strong) NSString *countryName;
@property (nonatomic,strong) ModelContextTestDelegate *delegate;
@end

@implementation TestWorldbikesCoreService
@synthesize countryDAO = _countryDAO;
@synthesize cityDAO = _cityDAO;
@synthesize coreService = _coreService;
@synthesize cityName = _cityName;
@synthesize countryName = _countryName;
@synthesize delegate = _delegate;

- (void) setUp
{
    self.countryName = @"Ireland";
    self.cityName = @"Dublin";
    self.countryDAO = [[CountryDAO alloc] init];
    self.cityDAO = [[CityDAO alloc] init];
    self.coreService = [[WorldbikesCoreService alloc] init];
    self.delegate = [[ModelContextTestDelegate alloc] init];
//    self.coreService.delegate = self.delegate;
}

- (void) tearDown
{
    [self setCountryDAO:nil];
    [self setCityDAO:nil];
    [self setCoreService:nil];
}

- (void) testCoreService_AddCityToCountry
{
    City *city = [self.coreService addCity:self.cityName withURLPath:nil toCountry:self.countryName];
    STAssertNotNil(city, @"failed to add city using WorldbikesCoreService");
    
    int numberOfCountries = [self.countryDAO numberOfCountryInManagedObjectContext:[self.delegate managedObjectContext]];    
    STAssertEquals(numberOfCountries, 1, @"failed to create country object using WorldbikesCoreService");
    
    STAssertNotNil([city country], @"city-country mapping is not setup");
    STAssertTrue([city.country.countryName isEqualToString:self.countryName], @"%@ is not a city of %@", city.cityName, self.countryName);    
}

- (void) testCoreService_RemoveCity
{
    [self.coreService addCity:self.cityName withURLPath:nil toCountry:self.countryName];
    [self.coreService addCity:@"Athlone" withURLPath:nil toCountry:self.countryName];
    
    Country *country = [self.countryDAO country:self.countryName inManagedObjectContext:[self.delegate managedObjectContext]];
    
    STAssertTrue([country.cities count] == 2, @"incorrect number of cities");
    
    [self.coreService removeCity:self.cityName];
    
    STAssertTrue([country.cities count] == 1, @"incorrect number of cities");
}

- (void) testCoreService_RemoveAllCities
{
    [self.coreService addCity:self.cityName withURLPath:nil toCountry:self.countryName];
    [self.coreService addCity:@"Athlone" withURLPath:nil toCountry:self.countryName];
    
    Country *country = [self.countryDAO country:self.countryName inManagedObjectContext:[self.delegate managedObjectContext]];
    
    STAssertTrue([country.cities count] == 2, @"incorrect number of cities");
    
    [self.coreService removeCity:self.cityName];
    [self.coreService removeCity:@"Athlone"];
    
    STAssertTrue([country.cities count] == 0, @"incorrect number of cities");
    
    country = [self.countryDAO country:self.countryName inManagedObjectContext:[self.delegate managedObjectContext]];
    STAssertNil(country, @"");
}

- (void) testCoreService_UserCities
{
    [self.cityDAO addCity:self.cityName withUrlPath:nil inManagedObjectContext:[self.delegate managedObjectContext]];
    [self.cityDAO addCity:@"Athlone" withUrlPath:nil inManagedObjectContext:[self.delegate managedObjectContext]];
    [self.cityDAO addCity:@"Shanghai" withUrlPath:nil inManagedObjectContext:[self.delegate managedObjectContext]];
    [self.cityDAO addCity:@"Paris" withUrlPath:nil inManagedObjectContext:[self.delegate managedObjectContext]];
    
    NSArray *cityNames = [self.coreService userCities];
    
    STAssertTrue([cityNames count]==4, @"incorrect number of cities added");
    
    int index=0;
    for (NSString *cityName in cityNames) {
        STAssertNotNil(cityName, @"index [%d] is nil", index);
        index++;
    }    
}

@end
