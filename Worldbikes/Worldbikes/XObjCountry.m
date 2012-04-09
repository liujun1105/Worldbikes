//
//  XObjCountry.m
//  Worldbikes
//
//  Created by a亲爱的 我自己 on 07/04/2012.
//  Copyright (c) 2012 Ericsson Software Campus. All rights reserved.
//

#import "XObjCountry.h"

@implementation XObjCountry

@synthesize countryName = _countryName;
@synthesize cities = _cities;

-(id) init
{
    self = [super init];
    if (self) {
        self.cities = [NSMutableArray array];
    }
    return self;
}

@end
