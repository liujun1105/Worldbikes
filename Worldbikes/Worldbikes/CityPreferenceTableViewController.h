//
//  CitySettingViewController.h
//  Worldbikes
//
//  Created by a亲爱的 我自己 on 08/04/2012.
//  Copyright (c) 2012 Ericsson Software Campus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Worldbikes.h"
#import "WorldbikesPreferenceModel.h"
#import "WorldbikesCoreService.h"

@interface CityPreferenceTableViewController : UITableViewController
@property (nonatomic,strong) NSString *countryName;
@property (nonatomic) int countryIndex;
@property (strong, nonatomic) WorldbikesPreferenceModel *preference;


@end
