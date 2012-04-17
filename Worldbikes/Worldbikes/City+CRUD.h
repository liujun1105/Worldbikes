//
//  City+CRUD.h
//  Worldbikes
//
//  Created by a亲爱的 我自己 on 15/04/2012.
//  Copyright (c) 2012 Ericsson Software Campus. All rights reserved.
//

#import "City.h"

@interface City (CRUD)
- (void)addStationsObject:(Station *)value;
- (void)removeStationsObject:(Station *)value;
- (void)addStations:(NSSet *)values;
- (void)removeStations:(NSSet *)values;
@end
