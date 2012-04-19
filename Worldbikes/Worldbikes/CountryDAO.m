//
//  CountryDAO.m
//  Worldbikes
//
//  Created by a亲爱的 我自己 on 08/04/2012.
//  Copyright (c) 2012 Ericsson Software Campus. All rights reserved.
//

#import "CountryDAO.h"
#import "Country+CRUD.h"

@implementation CountryDAO

- (Country*) addCountry:(NSString*) countryName inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Country"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"countryName == %@", countryName];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"countryName" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];
    fetchRequest.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:fetchRequest error:&error];
    
    if (error) NSLog(@"error when retrieving place entities %@", error);
    
    assert([matches count] == 0 || [matches count] == 1);
    
    Country *country;    
    if ([matches count] == 0) {
        country = [NSEntityDescription insertNewObjectForEntityForName:@"Country"
                                                inManagedObjectContext:context];
        country.countryName = countryName;
    }
    else {
        country = [matches lastObject];
    }
    
    return country;
}

- (int) numberOfCountryInManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Country"]; 
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"countryName" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];
    fetchRequest.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:fetchRequest error:&error];
    
    if (error) NSLog(@"error when retrieving place entities %@", error);
    
    return [matches count];
}

- (Country*) country:(NSString*) countryName inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Country"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"countryName == %@", countryName];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"countryName" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];
    fetchRequest.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:fetchRequest error:&error];
    
    if (error) NSLog(@"error when retrieving place entities %@", error);
    
    assert([matches count] == 0 || [matches count] == 1);
    
    return [matches lastObject];
}

- (BOOL) deleteCountry:(NSString*) countryName inManagedObjectContext:(NSManagedObjectContext *)context
{
    Country *country = [self country:countryName inManagedObjectContext:context];
    if (nil == country) {
        return false;
    }
    else {
        [context deleteObject:country];
        return true;
    }
}

- (BOOL) hasCityMappedToCountry:(NSString*) countryName inManagedObjectContext:(NSManagedObjectContext *)context
{
    Country *country = [self country:countryName inManagedObjectContext:context];
    if (nil == country) {
        return false;
    }
    return [[country cities] count] > 0;
}

@end
