//
//  SettingModel.m
//  Worldbikes
//
//  Created by a亲爱的 我自己 on 08/04/2012.
//  Copyright (c) 2012 Ericsson Software Campus. All rights reserved.
//

#import "SettingModel.h"
#import "DefaultXMLParserDelegate.h"
#import "XObjCity.h"
#import "XObjCountry.h"
#import "XMLCrawler.h"

@interface SettingModel ()
@property (nonatomic,strong) NSArray *countries;

@end

@implementation SettingModel
@synthesize countries = _countries;

- (void) setup
{
    XMLCrawler *xmlCrawler = [[XMLCrawler alloc] init];
    NSURL *url = [NSURL URLWithString:@"http://www.drpangpang.com/worldbikes.xml"];    
    NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    DefaultXMLParserDelegate *parserDelegate = [[DefaultXMLParserDelegate alloc] init];
    parser.delegate = parserDelegate;
    parserDelegate.crawlerDelegate = xmlCrawler;
    
    BOOL status = [parser parse];
    if (!status) {
        NSLog(@"failed to parse the XML specified");
    }
    
    self.countries = [NSArray arrayWithArray:[xmlCrawler data]];
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

@end
