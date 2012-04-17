//
//  SettingModel.h
//  Worldbikes
//
//  Created by a亲爱的 我自己 on 08/04/2012.
//  Copyright (c) 2012 Ericsson Software Campus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettingModel : NSObject

- (void) setup;

- (int) indexOfCountry:(NSString*) countryName;
- (int) countrySize;
- (int) numberOfCitiesInCountryAtIndex:(int) index;
- (NSString*) nameOfCountryAtIndex:(int) index;
- (NSArray*) citiesOfCountry:(NSString*) countryName;
- (NSArray*) citiesOfCountryAtIndex:(int) countryIndex;
- (NSString*) nameOfCityAtIndex:(int) cityIndex OfCountryAtIndex:(int) countryIndex;
@end
