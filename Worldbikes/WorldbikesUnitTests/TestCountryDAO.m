//
//  TestCountryDAO.m
//  Worldbikes
//
//  Created by a亲爱的 我自己 on 09/04/2012.
//  Copyright (c) 2012 Ericsson Software Campus. All rights reserved.
//

#import "TestCountryDAO.h"
#import <CoreData/CoreData.h>
#import "Country+CRUD.h"
#import "CountryDAO.h"
#import "City+CRUD.h"

@interface TestCountryDAO ()
@property (nonatomic,strong) NSManagedObjectModel *model;
@property (nonatomic,strong) NSPersistentStoreCoordinator *coordinator;
@property (nonatomic,strong) NSManagedObjectContext *context;
@property (nonatomic,strong) CountryDAO *countryDAO;
@end

@implementation TestCountryDAO
@synthesize model = _model;
@synthesize coordinator = _coordinator;
@synthesize context = _context;
@synthesize countryDAO = _countryDAO;

- (void)setUp
{
    [super setUp];
    self.model = [NSManagedObjectModel mergedModelFromBundles:[NSBundle allBundles]];
    self.coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.model];
    self.context = [[NSManagedObjectContext alloc] init];
    self.context.persistentStoreCoordinator = self.coordinator;
    self.countryDAO = [[CountryDAO alloc] init];
}

-(void) tearDown
{
    [self setModel:nil];
    [self setContext:nil];
    [self setCoordinator:nil];
    [self setCountryDAO:nil];
}

- (void)testCountryDAO_AddCountry
{
    Country *country = [self.countryDAO addCountry:@"Ireland" inManagedObjectContext:self.context];    
    STAssertNotNil(country, @"failed to create a Country object");
}

- (void)testCountryDAO_NumberOfCountries
{
    [self.countryDAO addCountry:@"Ireland" inManagedObjectContext:self.context];
    [self.countryDAO addCountry:@"France" inManagedObjectContext:self.context];
    [self.countryDAO addCountry:@"Ireland" inManagedObjectContext:self.context];
    STAssertEquals([self.countryDAO numberOfCountryInManagedObjectContext:self.context], 2, @"invalid number of countries");
}

- (void)testCountryDAO_GetCountry
{
    NSString *countryName = @"Ireland";
    [self.countryDAO addCountry:countryName inManagedObjectContext:self.context];    
    Country *country = [self.countryDAO country:countryName inManagedObjectContext:self.context];
    STAssertNotNil(country, @"");
    STAssertTrue([country.countryName isEqualToString:countryName], @"");
}

- (void)testCountryDAO_GetCountry_NilValue
{
    NSString *countryName = @"Ireland";
    Country *country = [self.countryDAO country:countryName inManagedObjectContext:self.context];
    STAssertNil(country, @"");    
}

- (void)testCountryDAO_DeleteAnExistingCountry
{
    NSString *countryName = @"Ireland";
    [self.countryDAO addCountry:countryName inManagedObjectContext:self.context]; 
    BOOL isDeleted = [self.countryDAO deleteCountry:countryName inManagedObjectContext:self.context];
    STAssertTrue(isDeleted, @"failed to delete country %@", countryName);
    Country *country = [self.countryDAO country:countryName inManagedObjectContext:self.context];
    STAssertNil(country, @"");
}

- (void)testCountryDAO_DeleteNullCountry
{
    BOOL isDeleted = [self.countryDAO deleteCountry:nil inManagedObjectContext:self.context];
    STAssertFalse(isDeleted, @"");
    isDeleted = [self.countryDAO deleteCountry:@"" inManagedObjectContext:self.context];
    STAssertFalse(isDeleted, @"");
}

- (void)testCountryDAO_HasCityMappedToCountry_YES
{
    NSString *cityName = @"Dublin";
    NSString *countryName = @"Ireland";
    City *city = [NSEntityDescription insertNewObjectForEntityForName:@"City" inManagedObjectContext:self.context];
    Country *country = [self.countryDAO addCountry:countryName inManagedObjectContext:self.context];
    [country addCitiesObject:city];
    
    BOOL hasCity = [self.countryDAO hasCityMappedToCountry:countryName inManagedObjectContext:self.context];
    STAssertTrue(hasCity, @"%@ should be mapped to %@", cityName, countryName);
}

- (void)testCountryDAO_HasCityMappedToCountry_NO
{
    NSString *countryName = @"Ireland";
    [self.countryDAO addCountry:countryName inManagedObjectContext:self.context];
    
    BOOL hasCity = [self.countryDAO hasCityMappedToCountry:countryName inManagedObjectContext:self.context]; 
    STAssertFalse(hasCity, @"no city has been mapped to %@", countryName);
}

@end
