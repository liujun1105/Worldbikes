//
//  ModelContextTestDelegate.h
//  Worldbikes
//
//  Created by a亲爱的 我自己 on 10/04/2012.
//  Copyright (c) 2012 Ericsson Software Campus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WorldbikesModelContextDelegate.h"

@interface ModelContextTestDelegate : NSObject <WorldbikesModelContextDelegate>

- (NSManagedObjectContext*) managedObjectContext;

@end
