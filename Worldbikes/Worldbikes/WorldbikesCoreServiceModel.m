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
#import "WorldbikesServiceProvider.h"
#import "WorldbikesAlertPool.h"
#import "XObjRegion.h"

@interface WorldbikesCoreServiceModel ()
@property (nonatomic,readonly) WorldbikesCoreService *coreService;
@end

@implementation WorldbikesCoreServiceModel
@synthesize isPersistentStoreOpened = _isPersistentStoreOpened;
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
    self.isPersistentStoreOpened = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(persistentStoreOpened:) 
                                                 name:@"PersistentStoreOpened" 
                                               object:nil];
    [self.coreService openPersistentStore];
}

- (void) persistentStoreOpened:(NSNotification *) notification
{
    NSLog(@"===== persist store opened successfully =====");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"PersistentStoreOpened" object:nil];
    self.isPersistentStoreOpened = YES;
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
    NSURL *url = [NSURL URLWithString:urlPath];
    NSArray *array = [self stations:url];
    
    if (nil == array) {
        return nil;
    }

    NSMutableArray *stations = [NSMutableArray array];
    for (NSObject *obj in array) {        
        
        if ([obj isKindOfClass:[XObjStation class]]) {
            XObjStation *station = (XObjStation*)obj;
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
        else {
            XObjRegion *region = (XObjRegion *)obj;
            [stations addObject:region];
        }
    }
    return stations;
}

- (NSArray*) cityPreferences
{
    return [self.coreService userCities];
}

- (NSArray*) allStationsInCity:(NSString*) cityName
{
    return [self.coreService allStationsInCity:cityName];
}

- (NSDictionary*) realtimeInfoOfStation:(int) stationID inCity:(NSString*) cityName
{
    NSString *realtimeInfoPath = [self.coreService realtimeInfoPathOfStation:stationID inCity:cityName];
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

- (void) initAlertPoolWithDelegate;
{
    [self.coreService setupAlertPoolWithDelegate:self.coreService];
    [self.coreService.alertPool start];
}

- (void) stopAlertPoolService
{
    self.coreService.stopAlertPool = YES;
}

- (NSDictionary*) regionBoundary:(NSString*) cityName
{
    return [self.coreService regionBoundary:cityName];
}

@end
