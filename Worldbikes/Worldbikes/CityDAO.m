//
//  CityDAO.m
//  Worldbikes
//
//  Created by a亲爱的 我自己 on 09/04/2012.
//  Copyright (c) 2012 Ericsson Software Campus. All rights reserved.
//

#import "CityDAO.h"
#import "City.h"
#import "Country.h"
#import "Worldbikes.h"

@implementation CityDAO

- (City*) addCity:(NSString*) cityName withUrlPath:(NSString*) urlPath inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"City"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"cityName == %@", cityName];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"cityName" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];
    fetchRequest.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:fetchRequest error:&error];
    
    if (error) NSLog(@"error when retrieving city entities %@", error);
    
    City *city;
    
    if (!matches || [matches count] > 1) ;
    else if ([matches count] == 0) {
        city = [NSEntityDescription insertNewObjectForEntityForName:@"City" inManagedObjectContext:context];
        city.cityName = cityName;
        city.url = urlPath;
    }
    else city = [matches lastObject];
        
    return city;
}

- (City*) city:(NSString*) cityName inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"City"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"cityName == %@", cityName];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"cityName" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];
    fetchRequest.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:fetchRequest error:&error];
    
    if (error) NSLog(@"error when retrieving city entities %@", error);
        
    assert([matches count] == 0 || [matches count] == 1);
    
    return [matches lastObject];
}

- (BOOL) deleteCity:(NSString *) cityName inManagedObjectContext:(NSManagedObjectContext *)context
{
    City *city = [self city:cityName inManagedObjectContext:context];
    
    if (nil == city) {
        return FALSE;
    }

    [context deleteObject:city];
    return TRUE;

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

- (NSArray*) allCitiesInManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"City"];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"cityName" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];
    fetchRequest.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:fetchRequest error:&error];
    
    if (error) NSLog(@"error when retrieving city entities %@", error);
    
    if (matches) Log(@"%d", [matches count]);
    
    return matches;
}

@end
