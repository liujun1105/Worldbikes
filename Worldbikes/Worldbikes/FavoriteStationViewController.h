//
//  FavoriteStationViewController.h
//  Worldbikes
//
//  Created by a亲爱的 我自己 on 16/04/2012.
//  Copyright (c) 2012 Ericsson Software Campus. All rights reserved.
//

#import "CoreDataTableViewController.h"
#import "WorldbikesFavoriteModel.h"

@interface FavoriteStationViewController : CoreDataTableViewController
@property (strong, nonatomic) IBOutlet WorldbikesFavoriteModel *favoriteModel;

@end
