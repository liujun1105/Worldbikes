//
//  WorldbikesCoreServiceModel.m
//  Worldbikes
//
//  Created by a亲爱的 我自己 on 14/04/2012.
//  Copyright (c) 2012 Ericsson Software Campus. All rights reserved.
//

#import "TestWorldbikesCoreServiceModel.h"
#import "WorldbikesCoreServiceModel.h"
#import <CoreLocation/CoreLocation.h>
#import "ModelContextTestDelegate.h"
#import "WorldbikesCoreService.h"

@interface TestWorldbikesCoreServiceModel ()
@property (nonatomic,strong) WorldbikesCoreServiceModel *coreServiceModel;
@property (nonatomic,strong) ModelContextTestDelegate *delegate;
@end


@implementation TestWorldbikesCoreServiceModel
@synthesize coreServiceModel = _coreServiceModel;
@synthesize delegate = _delegate;

- (void) setUp
{
    self.coreServiceModel = [[WorldbikesCoreServiceModel alloc] init];
    self.delegate = [[ModelContextTestDelegate alloc] init];
    
    // need find a way to replace this. maybe useing mock???
//    self.coreServiceModel.worldbikesCoreService.delegate = self.delegate;
}

- (void) tearDown
{
    [self setCoreServiceModel:nil];
}

- (void) testCoreServiceModel_Stations
{
    NSLog(@"testCoreServiceModel_Stations-->>");
    NSURL *url = [NSURL URLWithString:@"https://abo-dublin.cyclocity.fr/service/carto"];
    NSArray *data = [self.coreServiceModel stations:url];
    STAssertTrue([data count]>0, @"number of stations should be greater than 0");
    NSLog(@"<<--testCoreServiceModel_Stations");    
}

/* This test case requires some cities to be added into database first,
 * it is not working correctly at monent. */
- (void) testCoreServiceModel_StationURLs
{
    NSLog(@"testCoreServiceModel_StationURLs-->>");  
        
    NSArray *stationData = [self.coreServiceModel stationDataForMapAnnotation:@"https://abo-dublin.cyclocity.fr/service/carto"];
        
    STAssertNotNil(stationData, @"failed to get station data");
    STAssertTrue([stationData count]>0, @"incorrect station data");
    
    NSLog(@"%@", stationData);
    
    NSLog(@"<<--testCoreServiceModel_StationURLs"); 
}
     
@end
