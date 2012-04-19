//
//  StationDAO.m
//  Worldbikes
//
//  Created by a亲爱的 我自己 on 15/04/2012.
//  Copyright (c) 2012 Ericsson Software Campus. All rights reserved.
//

#import "StationDAO.h"
#import "Station.h"
#import "Worldbikes.h"
@implementation StationDAO

- (Station*) addStation:(NSDictionary *) stationDict inManagedObjectContext:(NSManagedObjectContext *)context
{    
    Station *station = [NSEntityDescription insertNewObjectForEntityForName:@"Station" inManagedObjectContext:context];
    assert(nil != station);
    
    station.stationID = [stationDict valueForKey:@"stationID"];
    station.stationName = [stationDict valueForKey:@"stationName"];
    station.stationAddress = [stationDict valueForKey:@"stationAddress"];
    station.stationFullAddress = [stationDict valueForKey:@"stationFullAddress"];
    station.stationLatitude = [stationDict valueForKey:@"stationLatitude"];
    station.stationLongitude = [stationDict valueForKey:@"stationLongitude"];
    
    return station;
    
}

- (Station *) station:(int) stationID inCity:(NSString *) cityName inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Station"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"stationID == %d AND city.cityName == %@", stationID, cityName];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"stationID" ascending:YES];
    fetchRequest.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:fetchRequest error:&error];
    
    if (error) Log(@"error when retrieving city entities %@", error);
    
    if (nil == matches) {
        return nil;
    }
    
    return [matches lastObject];
}

- (BOOL) deleteStation:(int) stationID inCity:(NSString *) cityName inManagedObjectContext:(NSManagedObjectContext *)context
{
    Station *station = [self station:stationID inCity:cityName inManagedObjectContext:context];
    
    if (nil == station) {
        return FALSE;
    }
    
    [context deleteObject:station];
    return TRUE;
}

- (NSArray *) allStationsInCity:(NSString *) cityName inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Station"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"city.cityName == %@", cityName];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"stationID" ascending:YES];
    fetchRequest.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:fetchRequest error:&error];
    
    if (error) Log(@"error when retrieving city entities %@", error);

    return matches;
}

- (BOOL) updateStation:(int) stationID inCity:(NSString *) cityName asFavorite:(BOOL) favorite inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Station"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"stationID == %d AND city.cityName == %@", stationID, cityName];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"stationID" ascending:YES];
    fetchRequest.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:fetchRequest error:&error];
    
    if (error) Log(@"error when retrieving city entities %@", error);
    
    if (nil == matches) {
        return FALSE;
    }
    
    Station *station = [matches lastObject];
    station.isFavorite = [NSNumber numberWithBool:favorite];

    return TRUE;
}

- (BOOL) isFavoriteStation:(int) stationID ofCity:(NSString *) cityName inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Station"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"stationID == %d AND city.cityName == %@", stationID, cityName];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"stationID" ascending:YES];
    fetchRequest.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:fetchRequest error:&error];
    
    if (error) Log(@"error when retrieving city entities %@", error);
    
    if (nil == matches) {
        return FALSE;
    }
    
    return [[[matches lastObject] isFavorite] boolValue];
}

@end
