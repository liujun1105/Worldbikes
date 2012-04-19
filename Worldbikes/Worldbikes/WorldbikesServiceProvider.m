//
//  WorldbikesServiceProvider.m
//  Worldbikes
//
//  Created by a亲爱的 我自己 on 18/04/2012.
//  Copyright (c) 2012 Ericsson Software Campus. All rights reserved.
//

#import "WorldbikesServiceProvider.h"
#import "WorldbikesCoreService.h"

@implementation WorldbikesServiceProvider

+ (WorldbikesCoreService*) CoreService
{
    // keep one WorldbikesCoreSerce object only;
    static WorldbikesCoreService *worldbikesCoreService;
    
    if (!worldbikesCoreService) {
        NSLog(@"setup WorldbikesCoreService");
        worldbikesCoreService = [[WorldbikesCoreService alloc] init];
    }
    
    return worldbikesCoreService;
}

@end
