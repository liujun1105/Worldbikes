//
//  ModelContextTestDelegate.m
//  Worldbikes
//
//  Created by a亲爱的 我自己 on 10/04/2012.
//  Copyright (c) 2012 Ericsson Software Campus. All rights reserved.
//

#import "ModelContextTestDelegate.h"
#import <CoreData/CoreData.h>

@interface ModelContextTestDelegate ()
@property (nonatomic,strong) NSManagedObjectModel *model;
@property (nonatomic,strong) NSPersistentStoreCoordinator *coordinator;
@property (nonatomic,strong) NSManagedObjectContext *context;

@end


@implementation ModelContextTestDelegate
@synthesize model = _model;
@synthesize coordinator = _coordinator;
@synthesize context = _context;

- (id) init
{
    self = [super init];
    if (self) {
        self.model = [NSManagedObjectModel mergedModelFromBundles:[NSBundle allBundles]];
        self.coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.model];
        self.context = [[NSManagedObjectContext alloc] init];
        self.context.persistentStoreCoordinator = self.coordinator;
    }
    return self;
}

- (NSManagedObjectContext*) managedObjectContext 
{
    return self.context;
}

@end
