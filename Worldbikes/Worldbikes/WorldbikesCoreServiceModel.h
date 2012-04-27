//
//  WorldbikesCoreServiceModel.h
//  Worldbikes
//
//  Created by a亲爱的 我自己 on 10/04/2012.
//  Copyright (c) 2012 Ericsson Software Campus. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XObjRealtimeInfo;

@interface WorldbikesCoreServiceModel : NSObject
@property (nonatomic) BOOL isPersistentStoreOpened;

- (void) setup;

- (NSArray*) bicycleSchemes:(NSURL *) url;
- (NSArray*) stations:(NSURL *) url;
- (NSArray*) realtimeInfo:(NSURL *) url;
- (NSArray*) stationDataForMapAnnotation:(NSString*) urlPath;
- (NSArray*) cityPreferences;

- (NSArray*) allStationsInCity:(NSString*) cityName;
- (NSDictionary*) realtimeInfoOfStation:(int) stationID inCity:(NSString*) cityName;
- (NSDictionary*) regionBoundary:(NSString*) cityName;

- (void) initAlertPoolWithDelegate;
- (void) stopAlertPoolService;
@end
