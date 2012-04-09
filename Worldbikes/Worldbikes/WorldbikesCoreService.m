//
//  WorldbikesCoreService.m
//  Worldbikes
//
//  Created by a亲爱的 我自己 on 09/04/2012.
//  Copyright (c) 2012 Ericsson Software Campus. All rights reserved.
//

#import "WorldbikesCoreService.h"
#import "Worldbikes.h"
#import "City+CRUD.h"
#import "Country+CRUD.h"
#import <CoreData/CoreData.h>
#import "CountryDAO.h"
#import "CityDAO.h"

@interface WorldbikesCoreService ()

@property (nonatomic,strong) CityDAO *cityDAO;
@property (nonatomic,strong) CountryDAO *countryDAO;

@end

@implementation WorldbikesCoreService
@synthesize cityDAO = _cityDAO;
@synthesize countryDAO = _countryDAO;

- (id) init
{
    self = [super init];
    if (self) {
        self.cityDAO = [[CityDAO alloc] init];
        self.countryDAO = [[CountryDAO alloc] init];
    }
    return self;
}

/* private static method used only by other methods in the WorldbikesCoreService class */
+(UIManagedDocument *) CoreDataDocument
{
    static UIManagedDocument *document;
    
    if (document != nil && document.documentState == UIDocumentStateNormal) {
        return document;
    }
    
    NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    
    url = [url URLByAppendingPathComponent:CORE_DATA_DOCUMENT];
    
    if (document == nil) {
        document = [[UIManagedDocument alloc] initWithFileURL:url];
    }
    
    // whether the database already exists
    BOOL isDatabaseExist = [[NSFileManager defaultManager] fileExistsAtPath:[url path]];
    if (isDatabaseExist) {        
        NSLog(@"core data document %@ already exists", document.fileURL);
        if (document.documentState == UIDocumentStateClosed) {
            NSLog(@"opening document");
            [document openWithCompletionHandler:^(BOOL success){
                if (success) NSLog(@"core data document exists, open it");
                else NSLog(@"couldn't open core data document %@", document.localizedName);
            }];
        }
        else if (document.documentState == UIDocumentStateNormal) NSLog(@"Normal state");        
        else NSLog(@"Other state");
    }
    else {
        NSLog(@"core data document does not exist");
        [document saveToURL:document.fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
            if (success) NSLog(@"create the database");      
            else NSLog(@"couldn't create core data document at %@", document.fileURL);
        }];
    }
    
    return document;
}

- (City *) addCity:(NSString*) cityName toCountry:(NSString*) countryName inManagedObjectContext:(NSManagedObjectContext *)context
{
    Country *country = [self.countryDAO addCountry:countryName inManagedObjectContext:context];
    assert(nil != country);
    
    City *city = [self.cityDAO addCity:cityName inManagedObjectContext:context];
    assert(nil != city);
    
    [country addCitiesObject:city];
    
    return city;
}

- (void) removeCity:(NSString*) cityName inManagedObjectContext:(NSManagedObjectContext *) context
{
    NSString *countryName = [self.cityDAO countryOfCity:cityName inManagedObjectContext:context];
    [self.cityDAO deleteCity:cityName inManagedObjectContext:context];
    [context processPendingChanges];
    BOOL hasMoreCity = [self.countryDAO hasCityMappedToCountry:countryName inManagedObjectContext:context];
    if (!hasMoreCity) {
        [self.countryDAO deleteCountry:countryName inManagedObjectContext:context];
        [context processPendingChanges];
    }
}

@end
