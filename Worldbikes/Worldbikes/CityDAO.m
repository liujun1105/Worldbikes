//
//  CityDAO.m
//  Worldbikes
//
//  Created by a亲爱的 我自己 on 09/04/2012.
//  Copyright (c) 2012 Ericsson Software Campus. All rights reserved.
//

#import "CityDAO.h"
#import "City+CRUD.h"
#import "Country.h"

@implementation CityDAO

- (City*) addCity:(NSString*) cityName inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"City"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"cityName = %@", cityName];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"cityName" ascending:YES];
    fetchRequest.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:fetchRequest error:&error];
    
    if (error) NSLog(@"error when retrieving place entities %@", error);
    
    City *city;
    
    if (!matches || [matches count] > 1) ;
    else if ([matches count] == 0) {
        city = [NSEntityDescription insertNewObjectForEntityForName:@"City" inManagedObjectContext:context];
        city.cityName = cityName;
    }
    else city = [matches lastObject];
        
    return city;
}

- (City*) city:(NSString*) cityName inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"City"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"cityName = %@", cityName];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"cityName" ascending:YES];
    fetchRequest.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:fetchRequest error:&error];
    
    if (error) NSLog(@"error when retrieving place entities %@", error);
        
    assert([matches count] == 0 || [matches count] == 1);
    
    return [matches lastObject];
}

- (BOOL) deleteCity:(NSString *) cityName inManagedObjectContext:(NSManagedObjectContext *)context
{
    City *city = [self city:cityName inManagedObjectContext:context];
    
    if (nil == city) {
        return false;
    }
    else {
        [context deleteObject:city];
        return true;
    }
}

- (NSString*) countryOfCity:(NSString*) cityName inManagedObjectContext:(NSManagedObjectContext *)context
{
    City *city = [self city:cityName inManagedObjectContext:context];
    
    if (nil == city) {
        return nil;
    }
    else {
        return city.country.countryName;
    }
}

@end
