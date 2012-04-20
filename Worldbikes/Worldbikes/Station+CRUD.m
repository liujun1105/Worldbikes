//
//  Station+CRUD.m
//  Worldbikes
//
//  Created by a亲爱的 我自己 on 20/04/2012.
//  Copyright (c) 2012 Ericsson Software Campus. All rights reserved.
//

#import "Station+CRUD.h"

@implementation Station (CRUD)

- (void)addAlertsObject:(Alert *)value
{
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    
    [self willChangeValueForKey:@"alerts"
                withSetMutation:NSKeyValueUnionSetMutation
                   usingObjects:changedObjects];
    [[self primitiveValueForKey:@"alerts"] addObject:value];
    [self didChangeValueForKey:@"alerts"
               withSetMutation:NSKeyValueUnionSetMutation
                  usingObjects:changedObjects];     
}

- (void)removeAlertsObject:(Alert *)value
{
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    
    [self willChangeValueForKey:@"alerts"
                withSetMutation:NSKeyValueMinusSetMutation
                   usingObjects:changedObjects];
    [[self primitiveValueForKey:@"alerts"] removeObject:value];
    [self didChangeValueForKey:@"alerts"
               withSetMutation:NSKeyValueMinusSetMutation
                  usingObjects:changedObjects];     
}

- (void)addAlerts:(NSSet *)values
{
    [self willChangeValueForKey:@"alerts"
                withSetMutation:NSKeyValueUnionSetMutation
                   usingObjects:values];
    [[self primitiveValueForKey:@"alerts"] unionSet:values];
    [self didChangeValueForKey:@"alerts"
               withSetMutation:NSKeyValueUnionSetMutation
                  usingObjects:values];      
}

- (void)removeAlerts:(NSSet *)values
{
    [self willChangeValueForKey:@"alerts"
                withSetMutation:NSKeyValueMinusSetMutation
                   usingObjects:values];
    [[self primitiveValueForKey:@"alerts"] minusSet:values];
    [self didChangeValueForKey:@"alerts"
               withSetMutation:NSKeyValueMinusSetMutation
                  usingObjects:values];    
}

@end
