//
//  WorldbikesCoreService.h
//  Worldbikes
//
//  Created by a亲爱的 我自己 on 09/04/2012.
//  Copyright (c) 2012 Ericsson Software Campus. All rights reserved.
//

#import <Foundation/Foundation.h>


@class City;
@class Country;

@interface WorldbikesCoreService : NSObject

- (City *) addCity:(NSString*) cityName toCountry:(NSString*) countryName inManagedObjectContext:(NSManagedObjectContext *)context;
- (void) removeCity:(NSString*) cityName inManagedObjectContext:(NSManagedObjectContext *) context;

@end
