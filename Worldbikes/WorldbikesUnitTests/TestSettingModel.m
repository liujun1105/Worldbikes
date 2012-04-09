//
//  TestSettingModel.m
//  Worldbikes
//
//  Created by a亲爱的 我自己 on 08/04/2012.
//  Copyright (c) 2012 Ericsson Software Campus. All rights reserved.
//

#import "TestSettingModel.h"
#import "SettingModel.h"
#import "XObjCity.h"
@interface TestSettingModel ()

@property (nonatomic,strong) SettingModel *settingModel;

@end

@implementation TestSettingModel
@synthesize settingModel = _settingModel;

- (void) setUp
{
    self.settingModel = [[SettingModel alloc] init];    
    [self.settingModel setup];
}

- (void) testNumberOfCountries
{
    STAssertEquals([self.settingModel countrySize], 9, @"incorrect country size");
}

- (void) testNumberOfCities
{
    int index = [self.settingModel indexOfCountry:@"Ireland"];
    STAssertEquals([self.settingModel numberOfCitiesInCountryAtIndex:index], 1, @"invalide city size");
}

- (void) testGetCitiesWitCountryName
{
    NSArray *cities = [self.settingModel citiesOfCountry:@"Ireland"];
    STAssertTrue([cities count]==1, @"incorrect number of cities");
    XObjCity *city = [cities lastObject];
    STAssertTrue([city.cityName isEqualToString:@"Dublin"], @"incorrect city name");
}

- (void) testGetCitiesWitCountryIndex
{
    int index = [self.settingModel indexOfCountry:@"Ireland"];
    NSArray *cities = [self.settingModel citiesOfCountryAtIndex:index];
    STAssertTrue([cities count]==1, @"incorrect number of cities");
    XObjCity *city = [cities lastObject];
    STAssertTrue([city.cityName isEqualToString:@"Dublin"], @"incorrect city name");
}

@end
