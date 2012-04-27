//
//  WorldbikesAlertPool.m
//  Worldbikes
//
//  Created by a亲爱的 我自己 on 20/04/2012.
//  Copyright (c) 2012 Ericsson Software Campus. All rights reserved.
//

#import "WorldbikesAlertPool.h"
#import "Alert+EXT.h"
#import "WorldbikesCoreService.h"
#import "XMLCrawler.h"
#import "RealtimeInfoParserHandler.h"
#import "XObjRealtimeInfo.h"
#import "Worldbikes.h"
#import "Station+CRUD.h"
#import "City+CRUD.h"

@interface WorldbikesAlertPool ()

@property (nonatomic,strong) NSMutableDictionary *alertPool;

@end

@implementation WorldbikesAlertPool
// WorldbikesAlertPoolDelegate, responsible for stopping alerts 
// or deleting alerts from the alert pool
@synthesize alertPool = _alertPool;
@synthesize delegate = _delegate;
- (id) init 
{
    self = [super init];
    if (self) {
        self.alertPool = [NSMutableDictionary dictionary];
    }
    return self;
}

/*
 * This function retrieves the realtime information of a given station
 */
- (NSArray*) realtimeInfo:(NSURL *) url
{
    XMLCrawler *xmlCrawler = [[XMLCrawler alloc] init];
    RealtimeInfoParserHandler *parserHandler = [[RealtimeInfoParserHandler alloc] init];
    
    if (![xmlCrawler startCrawling:url withHandler:parserHandler]) {
        NSLog(@"failed to retrieve data from [%@]", [url absoluteString]);
        return nil;
    }
    
    return [NSArray arrayWithArray:[xmlCrawler data]];
}

- (BOOL) triggerAlert:(Alert*) alert
{
    NSURL *url = [NSURL URLWithString:[WorldbikesCoreService fullRealtimeInfoUrlPath:alert.station.city.url
                                                                           ofStation:[alert.station.stationID intValue]]];
    
    // get the realtime information of the station 
    NSArray *realtimeInfos = [self realtimeInfo:url];    
    XObjRealtimeInfo *realtimeInfo = [realtimeInfos lastObject];
    
    // if there are free stands or bikes available, then return YES
    // to trigger the alert    
    if ([alert.alertType intValue] == [FreeStandsAlert intValue]) {
        return realtimeInfo.free > 0;
    }
    else if ([alert.alertType intValue] == [BikeAvailableAlert intValue]) {
        return realtimeInfo.available > 0;
    }
    
    // no need to trigger the alert
    return NO;
}

- (void) main
{
    // the timer is scheduled with the timer interval of 30 seconds
    [NSTimer scheduledTimerWithTimeInterval:30
                                     target:self 
                                   selector:@selector(onTimer:) 
                                   userInfo:nil 
                                    repeats:YES];
    [[NSRunLoop currentRunLoop] run];
}


-(void) onTimer:(NSTimer *)theTimer 
{
    Log(@"Scheduled alerts checking");
    @synchronized(self.alertPool){
        if ([self.alertPool count]>0) {
            [self checkRealtimeInfo];
        }
    }
}

-(void)  checkRealtimeInfo
{
    NSArray *keys = [NSArray arrayWithArray:self.alertPool.allKeys];
    for (NSString *key in keys) {
        Alert *alert = [self.alertPool valueForKey:key];
        Log(@"checking station [%@,%@]", alert.station.stationName,alert.station.stationID);
        if ([self triggerAlert:alert]) {
            Log(@"Alert triggered");
            
            UILocalNotification *localNotification = [[UILocalNotification alloc] init];
            if (nil == localNotification) { return; }
            
            // the time when the local notification should be displayed
            NSDate *notificationDate = [NSDate dateWithTimeIntervalSinceNow:30];
            
            [localNotification setAlertBody:[NSString stringWithFormat:@"%@", alert.description]];
            [localNotification setAlertAction:@"Open App"];
            [localNotification setHasAction:YES];   
            [localNotification setSoundName:UILocalNotificationDefaultSoundName];
            localNotification.fireDate  = notificationDate;
            localNotification.timeZone  = [NSTimeZone systemTimeZone];
            localNotification.applicationIconBadgeNumber = ++[UIApplication sharedApplication].applicationIconBadgeNumber;
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];

            NSString *type = alert.alertType;
            // remove from persistent store
            [self.delegate deleteAlertWithID:alert.alertID andType:alert.alertType];


            [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateAlertSwitch" 
                                                                object:nil 
                                                              userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                        type, @"alertType",                                                                        
                                                                        nil]];
        }
    }
}

-(void) removeAlertWithID:(NSString*) alertID
{
    Log(@"Alert [%@] removed", alertID);
    [self.alertPool removeObjectForKey:alertID];
}

-(void) addAlert:(Alert*) alert
{
    [self.alertPool setValue:alert forKey:alert.alertID];
}

@end
