//
//  CitySettingViewController.h
//  Worldbikes
//
//  Created by a亲爱的 我自己 on 08/04/2012.
//  Copyright (c) 2012 Ericsson Software Campus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingModel.h"

@interface CitySettingViewController : UITableViewController
@property (nonatomic,strong) NSString *countryName;
@property (nonatomic) int countryIndex;
@property (strong, nonatomic) IBOutlet SettingModel *citySettingModel;


@end
