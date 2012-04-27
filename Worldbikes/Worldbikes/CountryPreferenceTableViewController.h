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

@interface CountryPreferenceTableViewController : UIViewController <UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet WorldbikesPreferenceModel *preference;
@property (strong, nonatomic) IBOutlet UISearchBar *countrySearchBar;
@property (strong, nonatomic) IBOutlet UITableView *countryTableView;

@end
