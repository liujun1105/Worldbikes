//
//  Crawler.h
//  Worldbikes
//
//  Created by a亲爱的 我自己 on 08/04/2012.
//  Copyright (c) 2012 Ericsson Software Campus. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol XMLCrawlerDelegate <NSObject>

- (NSArray*) data;
- (void) grabData:(NSArray*) data;

@end
