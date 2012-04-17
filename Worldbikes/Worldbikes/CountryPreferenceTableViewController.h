//
//  SettingTableViewController.h
//  Worldbikes
//
//  Created by a亲爱的 我自己 on 08/04/2012.
//  Copyright (c) 2012 Ericsson Software Campus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorldbikesPreferenceModel.h"
#import "CityPreferenceTableViewController.h"
#import "Worldbikes.h"
#import "WorldbikesPreferenceModel.h"

@interface CountryPreferenceTableViewController : UITableViewController
@property (strong, nonatomic) IBOutlet WorldbikesPreferenceModel *preference;

@end
