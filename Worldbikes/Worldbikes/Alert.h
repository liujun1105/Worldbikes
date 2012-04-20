//
//  Alert.h
//  Worldbikes
//
//  Created by a亲爱的 我自己 on 20/04/2012.
//  Copyright (c) 2012 Ericsson Software Campus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Station;

@interface Alert : NSManagedObject

@property (nonatomic, retain) NSString * alertID;
@property (nonatomic, retain) NSString * alertType;
@property (nonatomic, retain) Station *station;

@end
