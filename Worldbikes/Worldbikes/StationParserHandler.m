//
//  StationParserHandler.m
//  Worldbikes
//
//  Created by a亲爱的 我自己 on 14/04/2012.
//  Copyright (c) 2012 Ericsson Software Campus. All rights reserved.
//

#import "StationParserHandler.h"
#import "XObjStation.h"

@interface StationParserHandler ()
@property (nonatomic,strong) NSMutableArray *stations;
@end

@implementation StationParserHandler
@synthesize crawlerDelegate = _crawlerDelegate;
@synthesize stations = _stations;


- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    NSLog(@"start parsing xml document of stations");
    self.stations = [NSMutableArray array];
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    NSLog(@"end parsing xml document of stations");
    [self.crawlerDelegate grabData:self.stations];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"marker"]) {
        XObjStation *station = [[XObjStation alloc] init];
        for (NSString *key in attributeDict) {
            if ([key isEqualToString:@"name"])
                station.stationName = [attributeDict valueForKey:@"name"];
            else if ([key isEqualToString:@"number"])
                station.stationID = [[attributeDict valueForKey:@"number"] intValue];
            else if ([key isEqualToString:@"address"])
                station.stationAddress = [attributeDict valueForKey:@"address"];
            else if ([key isEqualToString:@"fullAddress"])
                station.stationFullAddress = [attributeDict valueForKey:@"fullAddress"];
            else if ([key isEqualToString:@"lat"])
                station.stationLatitude = [[attributeDict valueForKey:@"lat"] doubleValue];
            else if ([key isEqualToString:@"lng"])
                station.stationLongitude = [[attributeDict valueForKey:@"lng"] doubleValue];
        }
        [self.stations addObject:station];
    }
    else if ([elementName isEqualToString:@"arrondissement"]) {
        for (NSString *key in attributeDict) {
            if ([key isEqualToString:@"minLat"]) {
                
            }
            else if ([key isEqualToString:@"minLng"]) {
            }
            else if ([key isEqualToString:@"maxLat"]) {
            }
            else if ([key isEqualToString:@"maxLng"]) {
            }
        }
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
}

@end
