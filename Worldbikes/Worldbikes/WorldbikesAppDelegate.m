//
//  WorldbikesAppDelegate.m
//  Worldbikes
//
//  Created by a亲爱的 我自己 on 03/04/2012.
//  Copyright (c) 2012 Ericsson Software Campus. All rights reserved.
//

#import "WorldbikesAppDelegate.h"
#import <QuartzCore/QuartzCore.h>

@interface WorldbikesAppDelegate ()

/* a shared view that can be used by all view controller to display activity status*/
@property (nonatomic,strong) UIView *activityView;

@end

@implementation WorldbikesAppDelegate

@synthesize window = _window;
@synthesize activityView = _activityView;

+ (WorldbikesAppDelegate *)sharedAppDelegate  
{  
    return (WorldbikesAppDelegate*)[UIApplication sharedApplication].delegate;  
} 

- (void)hideActivityView  
{  
    [self.activityView removeFromSuperview];  
}  

- (void) showActivityView
{
    if (nil == self.activityView) {
        self.activityView = [[UIView alloc] initWithFrame:CGRectMake(self.window.center.x-50, 
                                                                self.window.center.y-50, 
                                                                100, 100)];    
        self.activityView.opaque = NO;  
        self.activityView.backgroundColor = [UIColor blackColor];  
        self.activityView.alpha = 0.7;  
        self.activityView.layer.cornerRadius = 10.0f;
        self.activityView.layer.shadowOffset = CGSizeZero;
        self.activityView.layer.shadowColor = [UIColor blackColor].CGColor;
        self.activityView.layer.shadowOpacity = 1;
        self.activityView.layer.shadowRadius = 130;
        
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        self.activityView.layer.shadowPath = [UIBezierPath bezierPathWithRect:
                                 CGRectInset(activityIndicator.bounds, -40, -40)].CGPath;     

        activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];    
        
        [self.activityView addSubview:activityIndicator];
        [activityIndicator setHidden:NO];
        [activityIndicator startAnimating];        
        [activityIndicator setFrame:self.activityView.bounds];
    }
    [self.window addSubview:self.activityView];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{   
    // Override point for customization after application launch.
    
    application.applicationIconBadgeNumber = 0;
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
 
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    application.applicationIconBadgeNumber = 0;    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.    
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification 
{
    
    if (application.applicationState == UIApplicationStateActive) {
        UIAlertView *alertView = [[UIAlertView alloc] 
                                  initWithTitle:@"Alert Info:"
                                  message:notification.alertBody 
                                  delegate:self
                                  cancelButtonTitle:@"OK" 
                                  otherButtonTitles: nil];
        [alertView show];
    }
    else if (application.applicationState == UIApplicationStateBackground) {
        NSLog(@"running at background...");
    }
}

@end
