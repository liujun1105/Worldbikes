//
//  TestCityDAO.m
//  Worldbikes
//
//  Created by a亲爱的 我自己 on 09/04/2012.
//  Copyright (c) 2012 Ericsson Software Campus. All rights reserved.
//

#import "TestCityDAO.h"
#import "City+CRUD.h"
#import "Country+CRUD.h"
#import "CityDAO.h"
#import <CoreData/CoreData.h>

@interface TestCityDAO ()

@property (nonatomic,strong) NSString *countryName;
@property (nonatomic,strong) NSString *cityName;
@property (nonatomic,strong) NSManagedObjectModel *model;
@property (nonatomic,strong) NSPersistentStoreCoordinator *coordinator;
@property (nonatomic,strong) NSManagedObjectContext *context;
@property (nonatomic,strong) CityDAO *cityDAO;

@end

@implementation TestCityDAO
@synthesize model = _model;
@synthesize coordinator = _coordinator;
@synthesize context = _context;
@synthesize cityDAO = _cityDAO;
@synthesize countryName = _countryName;
@synthesize cityName = _cityName;

- (void) setUp
{
    [super setUp];
    self.cityName = @"Dublin";
    self.countryName = @"Ireland";
    self.model = [NSManagedObjectModel mergedModelFromBundles:[NSBundle allBundles]];
    self.coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.model];
    self.context = [[NSManagedObjectContext alloc] init];
    self.context.persistentStoreCoordinator = self.coordinator;
    self.cityDAO = [[CityDAO alloc] init];
}

- (void) tearDown
{
    [self setModel:nil];
    [self setContext:nil];
    [self setCoordinator:nil];
    [self setCityDAO:nil];
}

- (void) testCityDAO_AddCity
{
    City *city = [self.cityDAO addCity:self.cityName withUrlPath:nil inManagedObjectContext:self.context];
    STAssertNotNil(city, @"city object initialisation failed");
    STAssertNil(city.country, @"");
}

- (void) testCityDAO_DeleteCity
{
    City *city = [self.cityDAO addCity:self.cityName withUrlPath:nil inManagedObjectContext:self.context];
    
    city = [self.cityDAO city:self.cityName inManagedObjectContext:self.context];
    STAssertNotNil(city, [NSString stringWithFormat:@"city %@ not found", self.cityName]);
    BOOL isDeleted = [self.cityDAO deleteCity:self.cityName inManagedObjectContext:self.context];
    STAssertTrue(isDeleted, @"deletion failed");
    city = [self.cityDAO city:self.cityName inManagedObjectContext:self.context];
    STAssertNil(city, @"deletion failed %@", self.cityName);
}

- (void) testCityDAO_DeleteCityFromCountry
{
    Country *country = [NSEntityDescription insertNewObjectForEntityForName:@"Country" inManagedObjectContext:self.context];
    country.countryName = self.countryName;
    City *city = [self.cityDAO addCity:self.cityName withUrlPath:nil inManagedObjectContext:self.context];
    [country addCitiesObject:city];
    
    STAssertTrue([country.cities count] == 1, @"Country %@ should has %@", self.countryName, self.cityName);
    STAssertTrue([city.country.countryName isEqualToString:country.countryName], @"incorrect country name, [%@][%@]", city.country.countryName, country.countryName);
    
    BOOL isDeleted = [self.cityDAO deleteCity:self.cityName inManagedObjectContext:self.context];
    STAssertTrue(isDeleted, @"deletion failed");    

    // flush the deletion work
    [self.context processPendingChanges];
    
    city = [[country.cities allObjects] lastObject];
    NSLog(@"%@", city.cityName);
    
    STAssertTrue([country.cities count] == 0, @"Country %@ should has an empty set of cities", self.countryName);
}

- (void) testCityDAO_GetCountryNameOfCity
{
    Country *country = [NSEntityDescription insertNewObjectForEntityForName:@"Country" inManagedObjectContext:self.context];
    country.countryName = self.countryName;
    City *city = [self.cityDAO addCity:self.cityName withUrlPath:nil inManagedObjectContext:self.context];
    
    NSString *countryOfCity = [self.cityDAO countryOfCity:self.cityName inManagedObjectContext:self.context];
    STAssertNil(countryOfCity, @"");
    
    [country addCitiesObject:city];
    
    countryOfCity = [self.cityDAO countryOfCity:self.cityName inManagedObjectContext:self.context];
    STAssertTrue([countryOfCity isEqualToString:country.countryName], @"country name [%@] [%@] does not match", countryOfCity, country.countryName);
}

- (void) testCityDAO_GetAllCities
{
    [self.cityDAO addCity:self.cityName withUrlPath:nil inManagedObjectContext:self.context];
    [self.cityDAO addCity:@"Athlone" withUrlPath:nil inManagedObjectContext:self.context];
    [self.cityDAO addCity:@"Shanghai" withUrlPath:nil inManagedObjectContext:self.context];
    [self.cityDAO addCity:@"Paris" withUrlPath:nil inManagedObjectContext:self.context];
    
    NSArray *cities = [self.cityDAO allCitiesInManagedObjectContext:self.context];
    STAssertTrue([cities count]==4, @"incorrect number of cities added");
}

@end

