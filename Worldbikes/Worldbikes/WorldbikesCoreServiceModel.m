//
//  WorldbikesCoreServiceModel.m
//  Worldbikes
//
//  Created by a亲爱的 我自己 on 10/04/2012.
//  Copyright (c) 2012 Ericsson Software Campus. All rights reserved.
//

#import "WorldbikesCoreServiceModel.h"
#import "XMLCrawler.h"
#import "StationParserHandler.h"
#import "RealtimeInfoParserHandler.h"
#import "CityParserHandler.h"
#import "WorldbikesCoreService.h"
#import "XObjRealtimeInfo.h"
#import "XObjStation.h"
#import "Worldbikes.h"

@implementation WorldbikesCoreServiceModel

- (id) init
{
    self = [super init];
    if (self) {

    }
    return self;
}

+ (WorldbikesCoreService*) CoreService
{
    static WorldbikesCoreService *worldbikesCoreService;
    
    if (!worldbikesCoreService) {
        NSLog(@"setup WorldbikesCoreService");
        worldbikesCoreService = [[WorldbikesCoreService alloc] init];
    }
    
    return worldbikesCoreService;
}

- (NSArray*) bicycleSchemes:(NSURL *)url
{
    XMLCrawler *xmlCrawler = [[XMLCrawler alloc] init];
    CityParserHandler *parserHandler = [[CityParserHandler alloc] init];
    
    if (![xmlCrawler startCrawling:url withHandler:parserHandler]) {
        NSLog(@"failed to retrieve data from [%@]", [url absoluteString]);
        return nil;
    }
    
    return [NSArray arrayWithArray:[xmlCrawler data]];
}

- (NSArray*) stations:(NSURL *) url
{
    XMLCrawler *xmlCrawler = [[XMLCrawler alloc] init];
    StationParserHandler *parserHandler = [[StationParserHandler alloc] init];
    
    if (![xmlCrawler startCrawling:url withHandler:parserHandler]) {
        NSLog(@"failed to retrieve data from [%@]", [url absoluteString]);
        return nil;
    }

    return [NSArray arrayWithArray:[xmlCrawler data]];
}

- (NSArray*) realtimeInfo:(NSURL *) url
{
    XMLCrawler *xmlCrawler = [[XMLCrawler alloc] init];
    RealtimeInfoParserHandler *parserHandler = [[RealtimeInfoParserHandler alloc] init];
    
    if (![xmlCrawler startCrawling:url withHandler:parserHandler]) {
        NSLog(@"failed to retrieve data from [%@]", [url absoluteString]);
        return nil;
    }
    
    return [NSArray arrayWithArray:[xmlCrawler data]];
}

- (NSArray*) stationDataForMapAnnotation:(NSString*) urlPath
{    
    NSLog(@"[%@]", urlPath);
    
    NSURL *url = [NSURL URLWithString:urlPath];
    NSArray *array = [self stations:url];
    
    if (nil == array) {
        return nil;
    }

    NSMutableArray *stations = [NSMutableArray array];
    for (XObjStation *station in array) {        
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                             station.stationName, @"stationName",
                                             [NSNumber numberWithInt:station.stationID], @"stationID",
                                             station.stationAddress, @"stationAddress", 
                                             station.stationFullAddress, @"stationFullAddress", 
                                             [NSNumber numberWithDouble:station.stationLatitude], @"stationLatitude",
                                             [NSNumber numberWithDouble:station.stationLongitude], @"stationLongitude",
                                             nil];
        [stations addObject:dict];
    }
    return stations;
}

- (NSArray*) cityPreferences
{
    return [[WorldbikesCoreServiceModel CoreService] userCities];
}

- (NSArray*) allStationsInCity:(NSString*) cityName
{
    return [[WorldbikesCoreServiceModel CoreService] allStationsInCity:cityName];
}

- (NSDictionary*) realtimeInfoOfStation:(int) stationID inCity:(NSString*) cityName
{
    NSString *realtimeInfoPath = [[WorldbikesCoreServiceModel CoreService] realtimeInfoPathOfStation:stationID inCity:cityName];
    NSURL *url = [NSURL URLWithString:realtimeInfoPath];
    NSArray *realtimeInfos = [self realtimeInfo:url];
    
    XObjRealtimeInfo *realtimeInfo = [realtimeInfos lastObject];

    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 [NSNumber numberWithInt:realtimeInfo.free], @"stands",
                                 [NSNumber numberWithInt:realtimeInfo.total], @"total",
                                 [NSNumber numberWithInt:realtimeInfo.available], @"available",
                                 [NSNumber numberWithInt:realtimeInfo.ticket], @"ticket",
                                 nil];
    return dict;
}

@end
