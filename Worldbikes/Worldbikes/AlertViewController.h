//
//  AlertViewController.h
//  Worldbikes
//
//  Created by a亲爱的 我自己 on 19/04/2012.
//  Copyright (c) 2012 Ericsson Software Campus. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WorldbikesFavoriteModel;

@interface AlertViewController : UITableViewController

@property (strong, nonatomic) NSString *cityName;
@property (nonatomic) int stationID;

@property (strong, nonatomic) IBOutlet UISwitch *freeStandsSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *availableBikesSwitch;
@property (strong, nonatomic) IBOutlet UITableView *alertTableView;
@property (strong, nonatomic) IBOutlet WorldbikesFavoriteModel *favoriteModel;

- (IBAction)availableBikeAlertStatusChanged:(UISwitch *)sender;
- (IBAction)freeStandsAlertStatusChanged:(UISwitch *)sender;

@end
