//
//  XMLParser.m
//  Worldbikes
//
//  Created by a亲爱的 我自己 on 06/04/2012.
//  Copyright (c) 2012 Ericsson Software Campus. All rights reserved.
//

#import "CityParserHandler.h"
#import "XObjCity.h"
#import "XObjCountry.h"

@interface CityParserHandler ()
@property (nonatomic,strong) NSMutableArray *countries;
@property (nonatomic,strong) NSMutableArray *cities;
@property (nonatomic,strong) NSMutableString *characters;

@end

@implementation CityParserHandler
@synthesize countries = _countries;
@synthesize cities = _cities;
@synthesize characters = _characters;
@synthesize crawlerDelegate = _crawlerDelegate;

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    NSLog(@"start parsing xml document");
    self.countries = [NSMutableArray array];
    self.cities = [NSMutableArray array];
    self.characters = [NSMutableString string];
}


- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    NSLog(@"end parsing xml document");
    self.cities = nil;
    [self.crawlerDelegate grabData:self.countries];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{    
    if ([elementName isEqualToString:@"country"]) {
        [self.countries addObject:[[XObjCountry alloc] init]];
    }
    else if ([elementName isEqualToString:@"city"]) {
        [self.cities addObject:[[XObjCity alloc] init]];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"country_name"]) {
        XObjCountry *country = [self.countries lastObject];
        country.countryName = [NSString stringWithString:self.characters];
    }
    else if ([elementName isEqualToString:@"name"]) {
        XObjCity *city = [self.cities lastObject];
        city.cityName = [NSString stringWithString:self.characters];
    }
    else if ([elementName isEqualToString:@"URL"]) {
        XObjCity *city = [self.cities lastObject];
        city.url = [NSString stringWithString:self.characters];
    }
    else if ([elementName isEqualToString:@"country"]) {        
        XObjCountry *country = [self.countries lastObject];
        for (XObjCity *city in self.cities) {
            [country.cities addObject:city];
        }
        [self.cities removeAllObjects];
    }
    [self.characters setString:@""];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] > 0) {
        [self.characters appendString:string];
    }
}

@end
