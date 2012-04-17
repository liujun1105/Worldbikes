//
//  XObjRealtimeInfo.m
//  Worldbikes
//
//  Created by a亲爱的 我自己 on 14/04/2012.
//  Copyright (c) 2012 Ericsson Software Campus. All rights reserved.
//

#import "XObjRealtimeInfo.h"

@implementation XObjRealtimeInfo
@synthesize available = _available;
@synthesize total = _total;
@synthesize free = _free;
@synthesize ticket = _ticket;

- (NSString*) description
{
    return [NSString stringWithFormat:@"%d,%d,%d,%d", self.available, self.free,self.total,self.ticket];
}

@end
