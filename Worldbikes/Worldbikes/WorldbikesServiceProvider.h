//
//  WorldbikesServiceProvider.h
//  Worldbikes
//
//  Created by a亲爱的 我自己 on 18/04/2012.
//  Copyright (c) 2012 Ericsson Software Campus. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WorldbikesCoreService;

@interface WorldbikesServiceProvider : NSObject
+ (WorldbikesCoreService*) CoreService;
@end
