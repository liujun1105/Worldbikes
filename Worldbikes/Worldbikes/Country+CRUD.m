//
//  Country+CRUD.m
//  Worldbikes
//
//  Created by a亲爱的 我自己 on 07/04/2012.
//  Copyright (c) 2012 Ericsson Software Campus. All rights reserved.
//

#import "Country+CRUD.h"

@implementation Country (CRUD)

-(id) init
{
    self = [super init];
    if (self) {
        self.cities = [NSSet set];
    }
    return self;
}

- (void)addCitiesObject:(City *)value
{
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    
    [self willChangeValueForKey:@"cities"
                withSetMutation:NSKeyValueUnionSetMutation
                   usingObjects:changedObjects];
    [[self primitiveValueForKey:@"cities"] addObject:value];
    [self didChangeValueForKey:@"cities"
               withSetMutation:NSKeyValueUnionSetMutation
                  usingObjects:changedObjects];
    
}

- (void)removeCitiesObject:(City *)value
{
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    
    [self willChangeValueForKey:@"cities"
                withSetMutation:NSKeyValueMinusSetMutation
                   usingObjects:changedObjects];
    [[self primitiveValueForKey:@"cities"] removeObject:value];
    [self didChangeValueForKey:@"cities"
               withSetMutation:NSKeyValueMinusSetMutation
                  usingObjects:changedObjects];    
}

- (void)addCities:(NSSet *)values
{
    [self willChangeValueForKey:@"cities"
                withSetMutation:NSKeyValueUnionSetMutation
                   usingObjects:values];
    [[self primitiveValueForKey:@"cities"] unionSet:values];
    [self didChangeValueForKey:@"cities"
               withSetMutation:NSKeyValueUnionSetMutation
                  usingObjects:values];
}

- (void)removeCities:(NSSet *)values
{
    [self willChangeValueForKey:@"cities"
                withSetMutation:NSKeyValueMinusSetMutation
                   usingObjects:values];
    [[self primitiveValueForKey:@"cities"] minusSet:values];
    [self didChangeValueForKey:@"cities"
               withSetMutation:NSKeyValueMinusSetMutation
                  usingObjects:values];    
}


@end
