//
//  Alert+EXT.m
//  Worldbikes
//
//  Created by a亲爱的 我自己 on 20/04/2012.
//  Copyright (c) 2012 Ericsson Software Campus. All rights reserved.
//

#import "Alert+EXT.h"

@implementation Alert (EXT)

- (NSString*) description
{
    NSMutableString *description = [NSMutableString stringWithFormat:@"Alert %@\n", self.alertID];
    if ([self.alertType intValue] == [FreeStandsAlert intValue]) {
        [description appendString:@"FreeStandsAlert triggered, there are free stands available"];
    }
    else if ([self.alertType intValue] == [BikeAvailableAlert intValue]) {
        [description appendString:@"BikeAvailableAlert triggered, there are free bikes available"];
    }
    
    return description;
}

@end
