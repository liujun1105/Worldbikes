//
//  CityDAO.h
//  Worldbikes
//
//  Created by a亲爱的 我自己 on 09/04/2012.
//  Copyright (c) 2012 Ericsson Software Campus. All rights reserved.
//

#import <Foundation/Foundation.h>

@class City;

@interface CityDAO : NSObject

- (City*) addCity:(NSString*) countryName inManagedObjectContext:(NSManagedObjectContext *)context;

- (City*) city:(NSString*) cityName inManagedObjectContext:(NSManagedObjectContext *)context;
- (BOOL) deleteCity:(NSString *) cityName inManagedObjectContext:(NSManagedObjectContext *)context;

- (NSString*) countryOfCity:(NSString*) cityName inManagedObjectContext:(NSManagedObjectContext *)context;

@end
