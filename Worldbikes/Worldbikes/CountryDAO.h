//
//  CountryDAO.h
//  Worldbikes
//
//  Created by a亲爱的 我自己 on 08/04/2012.
//  Copyright (c) 2012 Ericsson Software Campus. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Country;

@interface CountryDAO : NSObject

- (Country*) addCountry:(NSString*) countryName inManagedObjectContext:(NSManagedObjectContext *)context;
- (int) numberOfCountryInManagedObjectContext:(NSManagedObjectContext *)context;

- (Country*) country:(NSString*) countryName inManagedObjectContext:(NSManagedObjectContext *)context;
- (BOOL) deleteCountry:(NSString*) countryName inManagedObjectContext:(NSManagedObjectContext *)context;

- (BOOL) hasCityMappedToCountry:(NSString*) countryName inManagedObjectContext:(NSManagedObjectContext *)context;

@end
