//
//  DetailedStationViewController.h
//  Worldbikes
//
//  Created by a亲爱的 我自己 on 15/04/2012.
//  Copyright (c) 2012 Ericsson Software Campus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorldbikesStationAnnotation.h"
#import "DetailedStationTableView.h"
@class WorldbikesFavoriteModel;

@interface DetailedStationViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UILabel *stationID;
@property (strong, nonatomic) IBOutlet UILabel *stationName;
@property (strong, nonatomic) IBOutlet UILabel *stationLatitude;
@property (strong, nonatomic) IBOutlet UILabel *stationLongitude;
@property (strong, nonatomic) IBOutlet UILabel *stationFullAddress;
@property (strong, nonatomic) IBOutlet UILabel *availableBikes;
@property (strong, nonatomic) IBOutlet UILabel *freeStands;
@property (strong, nonatomic) IBOutlet UILabel *total;
@property (strong, nonatomic) IBOutlet UILabel *city;

@property (strong, nonatomic) UIActivityIndicatorView *savingProgress;
@property (strong, nonatomic) WorldbikesFavoriteModel *favoriteModel;
@property (strong, nonatomic) WorldbikesStationAnnotation *annotation;
@property (strong, nonatomic) NSDictionary *realtimeInfoDict;

@end
