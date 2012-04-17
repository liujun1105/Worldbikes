//
//  TestSettingModel.m
//  Worldbikes
//
//  Created by a亲爱的 我自己 on 08/04/2012.
//  Copyright (c) 2012 Ericsson Software Campus. All rights reserved.
//

#import "TestWorldbikesPreferenceModel.h"
#import "WorldbikesPreferenceModel.h"
#import "XObjCity.h"
#import "ModelContextTestDelegate.h"
#import "WorldbikesCoreServiceModel.h"
#import "WorldbikesCoreService.h"

@interface TestWorldbikesPreferenceModel ()

@property (nonatomic,strong) WorldbikesPreferenceModel *preference;
@property (nonatomic,strong) ModelContextTestDelegate *delegate;
@end

@implementation TestWorldbikesPreferenceModel
@synthesize preference = _preference;
@synthesize delegate = _delegate;

- (void) setUp
{
    self.preference = [[WorldbikesPreferenceModel alloc] init];   
    self.delegate = [[ModelContextTestDelegate alloc] init];
//    self.preference.worldbikesCoreService.delegate = self.delegate;
    [self.preference setup];
}

- (void) testNumberOfCountries
{
    STAssertEquals([self.preference countrySize], 9, @"incorrect country size");
}

- (void) testNumberOfCities
{
    int index = [self.preference indexOfCountry:@"Ireland"];
    STAssertEquals([self.preference numberOfCitiesInCountryAtIndex:index], 1, @"invalide city size");
}

- (void) testGetCitiesWitCountryName
{
    NSArray *cities = [self.preference citiesOfCountry:@"Ireland"];
    STAssertTrue([cities count]==1, @"incorrect number of cities");
    XObjCity *city = [cities lastObject];
    STAssertTrue([city.cityName isEqualToString:@"Dublin"], @"incorrect city name");
}

- (void) testGetCitiesWitCountryIndex
{
    int index = [self.preference indexOfCountry:@"Ireland"];
    NSArray *cities = [self.preference citiesOfCountryAtIndex:index];
    STAssertTrue([cities count]==1, @"incorrect number of cities");
    XObjCity *city = [cities lastObject];
    STAssertTrue([city.cityName isEqualToString:@"Dublin"], @"incorrect city name");
}

@end
