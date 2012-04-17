//
//  City+CRUD.m
//  Worldbikes
//
//  Created by a亲爱的 我自己 on 15/04/2012.
//  Copyright (c) 2012 Ericsson Software Campus. All rights reserved.
//

#import "City+CRUD.h"

@implementation City (CRUD)

-(id) init
{
    self = [super init];
    if (self) {
        self.stations = [NSSet set];
    }
    return self;
}

- (void)addStationsObject:(Station *)value
{
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    
    [self willChangeValueForKey:@"stations"
                withSetMutation:NSKeyValueUnionSetMutation
                   usingObjects:changedObjects];
    [[self primitiveValueForKey:@"stations"] addObject:value];
    [self didChangeValueForKey:@"stations"
               withSetMutation:NSKeyValueUnionSetMutation
                  usingObjects:changedObjects];    
}

- (void)removeStationsObject:(Station *)value
{
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    
    [self willChangeValueForKey:@"stations"
                withSetMutation:NSKeyValueMinusSetMutation
                   usingObjects:changedObjects];
    [[self primitiveValueForKey:@"stations"] removeObject:value];
    [self didChangeValueForKey:@"stations"
               withSetMutation:NSKeyValueMinusSetMutation
                  usingObjects:changedObjects];      
}

- (void)addStations:(NSSet *)values
{
    [self willChangeValueForKey:@"stations"
                withSetMutation:NSKeyValueUnionSetMutation
                   usingObjects:values];
    [[self primitiveValueForKey:@"stations"] unionSet:values];
    [self didChangeValueForKey:@"stations"
               withSetMutation:NSKeyValueUnionSetMutation
                  usingObjects:values];      
}

- (void)removeStations:(NSSet *)values
{
    [self willChangeValueForKey:@"stations"
                withSetMutation:NSKeyValueMinusSetMutation
                   usingObjects:values];
    [[self primitiveValueForKey:@"stations"] minusSet:values];
    [self didChangeValueForKey:@"stations"
               withSetMutation:NSKeyValueMinusSetMutation
                  usingObjects:values];        
}

@end
