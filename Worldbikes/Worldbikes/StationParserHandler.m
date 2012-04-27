//
//  StationParserHandler.m
//  Worldbikes
//
//  Created by a亲爱的 我自己 on 14/04/2012.
//  Copyright (c) 2012 Ericsson Software Campus. All rights reserved.
//

#import "StationParserHandler.h"
#import "XObjStation.h"
#import "XObjRegion.h"
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
        XObjRegion *region = [[XObjRegion alloc] init];
        for (NSString *key in attributeDict) {
            if ([key isEqualToString:@"minLat"]) {
                NSLog(@"Min Lat -> %@", [attributeDict valueForKey:key]);
                region.minLat = [[attributeDict valueForKey:key] doubleValue];
            }
            else if ([key isEqualToString:@"minLng"]) {
                NSLog(@"Min Lng -> %@", [attributeDict valueForKey:key]);
                region.minLng = [[attributeDict valueForKey:key] doubleValue];
            }
            else if ([key isEqualToString:@"maxLat"]) {
                NSLog(@"Max Lat -> %@", [attributeDict valueForKey:key]);                
                region.maxLat = [[attributeDict valueForKey:key] doubleValue];
            }
            else if ([key isEqualToString:@"maxLng"]) {
                NSLog(@"Max Lng -> %@", [attributeDict valueForKey:key]);
                region.maxLng = [[attributeDict valueForKey:key] doubleValue];
            }
        }
        [self.stations addObject:region];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
}

@end
