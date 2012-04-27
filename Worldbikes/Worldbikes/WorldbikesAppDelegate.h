//
//  WorldbikesAppDelegate.h
//  Worldbikes
//
//  Created by a亲爱的 我自己 on 03/04/2012.
//  Copyright (c) 2012 Ericsson Software Campus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WorldbikesAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

+ (WorldbikesAppDelegate *)sharedAppDelegate;  
- (void)showActivityView;  
- (void)hideActivityView;  


@end
