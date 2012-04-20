//
//  AlertDAO.m
//  Worldbikes
//
//  Created by a亲爱的 我自己 on 20/04/2012.
//  Copyright (c) 2012 Ericsson Software Campus. All rights reserved.
//

#import "AlertDAO.h"
#import "Alert.h"
#import "Worldbikes.h"

@implementation AlertDAO

-(Alert*) addAlertWithID:(NSString*) alertID andType:(NSString*) alertType inManagedObjectContext:(NSManagedObjectContext *)context
{
    Alert *alert = [NSEntityDescription insertNewObjectForEntityForName:@"Alert" inManagedObjectContext:context];

    if (nil != alert) {
        alert.alertID = alertID;
        alert.alertType = alertType;
    }    
    
    return alert;
}

-(BOOL) deleteAlertWithID:(NSString*) alertID andType:(NSString*) alertType inManagedObjectContext:(NSManagedObjectContext *)context
{
    Alert *alert = [self alertWithID:alertID andType:alertType inManagedObjectContext:context];
    if (nil == alert) {
        return NO;
    }
    
    [context deleteObject:alert];
    
    return YES;
}

-(Alert*) alertWithID:(NSString*) alertID andType:(NSString*) alertType inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Alert"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"alertID == %@ AND alertType == %@", alertID, alertType];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"alertID" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];
    fetchRequest.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:fetchRequest error:&error];
    
    if (nil != error) {
        Log(@"%@", error);
        return nil;
    }
    
    return [matches lastObject];
}

-(BOOL) deleteAlertsFromStation:(NSString*) stationName inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Alert"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"alert.station.stationName == %@", stationName];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"alertType" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];
    fetchRequest.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];  
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:fetchRequest error:&error];
    
    if (nil != error) {
        Log(@"%@", error);
        return NO;
    }
    
    for (Alert *alert in matches) {
        [context deleteObject:alert];
    }
    
    return YES;
}

-(BOOL) hasAlertSet:(NSString*) alertID inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Alert"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"alertID == %@", alertID];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"alertID" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];
    fetchRequest.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:fetchRequest error:&error];
    
    if (nil != error) {
        Log(@"%@", error);
        return NO;
    }
    
    return (nil != [matches lastObject]);
}

@end
