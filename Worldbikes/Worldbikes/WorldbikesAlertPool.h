//
//  WorldbikesAlertPool.h
//  Worldbikes
//
//  Created by a亲爱的 我自己 on 20/04/2012.
//  Copyright (c) 2012 Ericsson Software Campus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WorldbikesAlertPoolDelegate.h"
@class Alert;
@interface WorldbikesAlertPool : NSThread
@property id <WorldbikesAlertPoolDelegate> delegate;

-(void) removeAlertWithID:(NSString*) key;
-(void) addAlert:(Alert*) alert;
@end
