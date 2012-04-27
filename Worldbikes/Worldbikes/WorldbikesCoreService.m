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
#import "Station.h"
#import "StationDAO.h"
#import "Alert.h"
#import "AlertDAO.h"
#import "WorldbikesAlertPool.h"

@interface WorldbikesCoreService ()

@property (nonatomic,strong) CityDAO *cityDAO;
@property (nonatomic,strong) CountryDAO *countryDAO;
@property (nonatomic,strong) StationDAO *stationDAO;
@property (nonatomic,strong) AlertDAO *alertDAO;
@property (nonatomic,strong) UIManagedDocument *document;

@end

@implementation WorldbikesCoreService
@synthesize cityDAO = _cityDAO;
@synthesize countryDAO = _countryDAO;
@synthesize stationDAO = _stationDAO;
@synthesize document = _document;
@synthesize alertDAO = _alertDAO;
@synthesize alertPool = _alertPool;
@synthesize stopAlertPool = _stopAlertPool;

- (id) init
{
    self = [super init];
    if (self) {
        self.cityDAO = [[CityDAO alloc] init];     
        self.countryDAO = [[CountryDAO alloc] init];
        self.stationDAO = [[StationDAO alloc] init];
        self.alertDAO = [[AlertDAO alloc] init];
        
    }
    return self;
}

- (void) setupAlertPoolWithDelegate:(id) delegate
{
    self.stopAlertPool = NO;
    self.alertPool = [[WorldbikesAlertPool alloc] init];
    self.alertPool.delegate = delegate;
}

- (UIManagedDocument *) openPersistentStore
{
    static UIManagedDocument *document;
    
    if (nil != document && document.documentState == UIDocumentStateNormal) {
        return document;        
    }
    
    NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    
    url = [url URLByAppendingPathComponent:CORE_DATA_DOCUMENT];
    
    document = [[UIManagedDocument alloc] initWithFileURL:url];
    assert(nil != document);
    
    // whether the database already exists
    BOOL isDatabaseExist = [[NSFileManager defaultManager] fileExistsAtPath:[url path]];
    if (isDatabaseExist) {        
        NSLog(@"core data document %@ already exists", document.fileURL);
        if (document.documentState == UIDocumentStateClosed) {
            NSLog(@"opening document");
            [document openWithCompletionHandler:^(BOOL success){
                if (success) {
                    [[NSNotificationCenter defaultCenter]
                     postNotificationName:@"PersistentStoreOpened" object:nil userInfo:nil];
                }
                else {
                    [NSException exceptionWithName:@"UIManagedDocumentStateError" reason:@"couldn't open core data document" userInfo:nil];
                }
            }];
        }
        else if (document.documentState == UIDocumentStateNormal) {
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"PersistentStoreOpened" object:nil userInfo:nil];
        }
        else {
            @throw [NSException exceptionWithName:@"UIManagedDocumentStateError" reason:@"Unknown State" userInfo:nil];
        }
    }
    else {
        NSLog(@"core data document does not exist");
        [document saveToURL:document.fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
            if (success) {
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:@"PersistentStoreOpened" object:nil userInfo:nil];
            }
            else {
                [NSException exceptionWithName:@"UIManagedDocumentStateError" reason:@"couldn't creae core data document" userInfo:nil];
            }
        }];
    }
    
    return document;
}


- (NSManagedObjectContext *) managedObjectContext
{
    @synchronized(self){
        if (!self.document) {
            self.document = [self openPersistentStore];
        }
        
        return [self.document managedObjectContext];
    }
}

- (City *) addCity:(NSString*) cityName withURLPath:(NSString*) url toCountry:(NSString*) countryName;
{
    NSManagedObjectContext *context = [self managedObjectContext];
    assert(nil != context);
    
    Country *country = [self.countryDAO addCountry:countryName inManagedObjectContext:context];
    assert(nil != country);

    City *city = [self.cityDAO addCity:cityName withUrlPath:url inManagedObjectContext:context];
    assert(nil != city);

    [country addCitiesObject:city];

    assert(nil != city.country);
    
    return city;
}

- (City *) city:(NSString*) cityName
{
    return [self.cityDAO city:cityName inManagedObjectContext:[self managedObjectContext]];
}

- (BOOL) removeCity:(NSString*) cityName
{
    NSManagedObjectContext *context = [self managedObjectContext];
    assert(nil != context);
    
    NSString *countryName = [self.cityDAO countryOfCity:cityName inManagedObjectContext:context];
    BOOL success = [self.cityDAO deleteCity:cityName inManagedObjectContext:context];
    
    if (!success) {
        return NO;
    }
    
    NSLog(@"city %@ removed", cityName);
     
    BOOL hasMoreCity = [self.countryDAO hasCityMappedToCountry:countryName inManagedObjectContext:context];
    if (!hasMoreCity) {
        [self.countryDAO deleteCountry:countryName inManagedObjectContext:context];
        NSLog(@"country %@ removed", countryName);
    }
    
    return YES;
}

- (NSArray*) userCities
{
    NSManagedObjectContext *context = [self managedObjectContext];
    assert(nil != context);
    
    NSArray *cities = [self.cityDAO allCitiesInManagedObjectContext:context];
    
    NSMutableArray *cityNames = [NSMutableArray array];
    for (City *city in cities) {
        [cityNames addObject:city.cityName];
    }
    return cityNames;
}

+ (NSString*) fullUrlPath:(NSString*) partial
{
    NSMutableString *urlPath = [NSMutableString stringWithString:@"https://abo-"];
    [urlPath appendString:partial];
    [urlPath appendString:@".cyclocity.fr/service/carto"]; 
    return urlPath;
}

+ (NSString*) fullRealtimeInfoUrlPath:(NSString*) partial ofStation:(int) stationID
{
    NSMutableString *urlPath = [NSMutableString stringWithString:@"https://abo-"];
    [urlPath appendString:partial];
    [urlPath appendString:@".cyclocity.fr/service/stationdetails/"]; 
    [urlPath appendFormat:@"%@/%d", partial, stationID];
    return urlPath;
}

- (Station *) addStation:(NSDictionary *) stationDict
{
    NSManagedObjectContext *context = [self managedObjectContext];
    return [self.stationDAO addStation:stationDict inManagedObjectContext:context];
}

- (NSArray *) allStationsInCity:(NSString *) cityName
{
    NSManagedObjectContext *context = [self managedObjectContext];    
    
    NSArray *stations = [self.stationDAO allStationsInCity:cityName inManagedObjectContext:context];
    NSMutableArray *stationDic = [NSMutableArray array];
    for (Station *station in stations) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                             station.stationName, @"stationName",
                                             station.stationID, @"stationID",
                                             station.stationAddress, @"stationAddress", 
                                             station.stationFullAddress, @"stationFullAddress", 
                                             station.stationLatitude, @"stationLatitude",
                                             station.stationLongitude, @"stationLongitude",
                                             station.isFavorite, @"isFavorite",
                                             nil];
        [stationDic addObject:dict];
    }    
    return stationDic;
}

- (BOOL) deleteStation:(int) stationID inCity:(NSString *) cityName
{
    NSManagedObjectContext *context = [self managedObjectContext];
    return [self.stationDAO deleteStation:stationID inCity:cityName inManagedObjectContext:context];
}

- (Station *) station:(int) stationID inCity:(NSString *) cityName
{
    NSManagedObjectContext *context = [self managedObjectContext];
    return [self.stationDAO station:stationID inCity:cityName inManagedObjectContext:context];
}

- (NSString*) realtimeInfoPathOfStation:(int) stationID inCity:(NSString*) cityName
{
    City *city = [self city:cityName];
    NSString *realtimeInfoPath = [WorldbikesCoreService fullRealtimeInfoUrlPath:city.url ofStation:stationID];
    return realtimeInfoPath;
}

- (void) didSaveCallback:(NSNotification *) notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSManagedObjectContextDidSaveNotification object:[self managedObjectContext]];    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"FavoriteListUpdated" object:nil userInfo:nil];
}

- (BOOL) updateStation:(int) stationID inCity:(NSString*) cityName asFavorite:(BOOL) isFavorite 
{
    NSManagedObjectContext *context = [self managedObjectContext];
    [[NSNotificationCenter defaultCenter] addObserver:self
                    selector:@selector(didSaveCallback:)
                        name:NSManagedObjectContextDidSaveNotification
                      object:context];
    return [self.stationDAO updateStation:stationID inCity:cityName asFavorite:isFavorite inManagedObjectContext:context];
}

- (BOOL) isFavoriteStation:(int) stationID ofCity:(NSString *) cityName
{
    NSManagedObjectContext *context = [self managedObjectContext];
    return [self.stationDAO isFavoriteStation:stationID ofCity:cityName inManagedObjectContext:context];
}

- (id) fetchedResultsController
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Station"];
    request.predicate = [NSPredicate predicateWithFormat:@"isFavorite == %@", [NSNumber numberWithBool:YES]];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"stationID" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];    
   
    [request setFetchLimit:10];
    return [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:[self managedObjectContext] sectionNameKeyPath:@"city.cityName" cacheName:@"FavoriteStationCache"];        
}

- (NSDictionary *) grabCellRelatedInfomationFrom:(id) data
{
    Station *station = data;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          [NSString stringWithFormat:@"%@ (%d)", station.stationName, [station.stationID intValue]], @"title", 
                          station.stationFullAddress, @"detail",                          
                          station.stationID, @"stationID",
                          station.city.cityName, @"cityName",
                          nil];
    return dict;
}

-(Alert*) addAlertWithID:(NSString*) alertID andType:(NSString*) alertType toStation:(int) stationID inCity:(NSString*) cityName
{
    NSManagedObjectContext *context = [self managedObjectContext];
    Station *station = [self.stationDAO station:stationID inCity:cityName inManagedObjectContext:context];
    Alert *alert = [self.alertDAO addAlertWithID:alertID andType:alertType inManagedObjectContext:context];
    assert(nil != station);
    assert(nil != alert);
    
    [station addAlertsObject:alert];
    [self.alertPool addAlert:alert];
    return alert;
}

-(BOOL) deleteAlertWithID:(NSString*) alertID andType:(NSString*) alertType
{
    BOOL success = [self.alertDAO deleteAlertWithID:alertID andType:alertType inManagedObjectContext:[self managedObjectContext]];
    if (success) {
        [self.alertPool removeAlertWithID:alertID];
        return success;
    }
    return NO;
}

-(BOOL) hasAlertSet:(NSString*) alertID;
{
    return [self.alertDAO hasAlertSet:alertID inManagedObjectContext:[self managedObjectContext]];
}

-(BOOL) stopAlertPool
{
    return self.stopAlertPool;
}

- (NSDictionary*) regionBoundary:(NSString *)cityName
{
    City *city = [self city:cityName];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  city.minLat, @"minLat",
                                  city.maxLat, @"maxLat",
                                  city.minLng, @"minLng",
                                  city.maxLng, @"maxLng",
                                  nil];
    return dict;
}

@end
