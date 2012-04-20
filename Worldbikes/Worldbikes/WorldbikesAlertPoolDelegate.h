//
//  WorldbikesAlertPoolDelegate.h
//  Worldbikes
//
//  Created by a亲爱的 我自己 on 20/04/2012.
//  Copyright (c) 2012 Ericsson Software Campus. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Alert;
@protocol WorldbikesAlertPoolDelegate <NSObject>

-(BOOL) stopAlertPool;
-(BOOL) deleteAlertWithID:(NSString*) alertID andType:(NSString*) alertType;
@end
