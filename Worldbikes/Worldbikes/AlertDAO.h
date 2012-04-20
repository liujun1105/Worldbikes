//
//  AlertDAO.h
//  Worldbikes
//
//  Created by a亲爱的 我自己 on 20/04/2012.
//  Copyright (c) 2012 Ericsson Software Campus. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Alert;

@interface AlertDAO : NSObject

-(Alert*) addAlertWithID:(NSString*) alertID andType:(NSString*) alertType inManagedObjectContext:(NSManagedObjectContext *)context;

-(BOOL) deleteAlertWithID:(NSString*) alertID andType:(NSString*) alertType inManagedObjectContext:(NSManagedObjectContext *)context;

-(Alert*) alertWithID:(NSString*) alertID andType:(NSString*) alertType inManagedObjectContext:(NSManagedObjectContext *)context;

-(BOOL) deleteAlertsFromStation:(NSString*) stationName inManagedObjectContext:(NSManagedObjectContext *)context;

-(BOOL) hasAlertSet:(NSString*) alertID inManagedObjectContext:(NSManagedObjectContext *)context;

@end
