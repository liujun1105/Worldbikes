//
//  SettingModel.m
//  Worldbikes
//
//  Created by a亲爱的 我自己 on 08/04/2012.
//  Copyright (c) 2012 Ericsson Software Campus. All rights reserved.
//

#import "WorldbikesPreferenceModel.h"
#import "CityParserHandler.h"
#import "XObjCity.h"
#import "XObjCountry.h"
#import "XMLCrawler.h"
#import "City.h"
#import "Station.h"
#import "WorldbikesCoreService.h"
#import "WorldbikesServiceProvider.h"

@interface WorldbikesPreferenceModel ()
@property (nonatomic,strong) NSArray *countries;
@property (nonatomic,readonly) WorldbikesCoreService *coreService;
@end

@implementation WorldbikesPreferenceModel
@synthesize countries = _countries;
@synthesize coreService = _coreService;

- (id) init
{
    self = [super init];
    if (self) {
        self->_coreService = [WorldbikesServiceProvider CoreService];
    }
    return self;
}

- (void) setup
{
    NSURL *url = [NSURL URLWithString:@"http://www.drpangpang.com//worldbikes.xml"];
    self.countries = [self bicycleSchemes:url];
}

- (int) indexOfCountry:(NSString*) countryName
{
    int index = 0;
    for (XObjCountry *country in self.countries) {
        if ([country.countryName isEqualToString:countryName]) {
            return index;
        }
        index++;
    }
    return -1;
}

- (int) countrySize
{
    if (nil != self.countries) {
        return [self.countries count];
    }
    return 0;
}

- (int) numberOfCitiesInCountryAtIndex:(int) index
{
    if (nil != self.countries) {
        XObjCountry *country = [self.countries objectAtIndex:index];
        return [country.cities count];
    }
    return 0;
}

- (NSString*) nameOfCountryAtIndex:(int) index
{
    if (nil != self.countries) {
        XObjCountry *country = [self.countries objectAtIndex:index];
        return country.countryName;
    }
    
    return nil;
}

- (NSArray*) citiesOfCountry:(NSString*) countryName
{
    if (nil != self.countries) {
        for (XObjCountry *country in self.countries) {
            if ([country.countryName isEqualToString:countryName]) {
                return country.cities;
            }
        }
    }
    return nil;
}

- (NSArray*) citiesOfCountryAtIndex:(int) countryIndex
{
    if (nil != self.countries) {
        XObjCountry *country = [self.countries objectAtIndex:countryIndex];
        return country.cities;
    }
    return nil;
}

- (NSString*) nameOfCityAtIndex:(int) cityIndex OfCountryAtIndex:(int) countryIndex
{
    XObjCountry *country = [self.countries objectAtIndex:countryIndex];
    XObjCity *city = [country.cities objectAtIndex:cityIndex];
    return city.cityName;
}

- (NSString*) urlOfCityAtIndex:(int) cityIndex ofcountryAtIndex:(int) countryIndex
{
    XObjCountry *country = [self.countries objectAtIndex:countryIndex];
    XObjCity *city = [country.cities objectAtIndex:cityIndex];
    return city.url;
}

- (City *) addCity:(NSString*) cityName withURLPath:(NSString*) url toCountry:(NSString*) countryName
{
    return [self.coreService addCity:cityName withURLPath:url toCountry:countryName];
}

- (BOOL) removeCity:(NSString*) cityName
{
    return [self.coreService removeCity:cityName];
}

- (void) downloadStationDataOfCity:(NSString *) cityName
{
    
    City *city = [self.coreService city:cityName];
    
    assert(nil != city);
    
    NSArray *stationData = [self stationDataForMapAnnotation:[WorldbikesCoreService fullUrlPath:city.url]];
    
    if (nil == stationData) {
        @throw [NSException exceptionWithName:@"DownloadStationDataFailedException" 
                                       reason:@"Failed to retrieve/parse the XML document" 
                                     userInfo:nil];
    }
    
    for (NSDictionary *stationDict in stationData) {            
        assert(nil != stationDict);
        Station *station = [self.coreService addStation:stationDict];
        assert(nil != station);
        [city addStationsObject:station];
        assert(nil != station.city);
    }
}    

- (void) removeStationDataOfCity:(NSString *) cityName
{
    /* is it save to do this?? is NSArray sychronised save?? */
    
    NSArray *stations = [self.coreService allStationsInCity:cityName];
   
    for (Station *station in stations) {
        [self.coreService deleteStation:[station.stationID intValue] inCity:cityName];
    }
}


@end
