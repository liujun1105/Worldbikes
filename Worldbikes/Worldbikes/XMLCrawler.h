//
//  XMLCrawler.h
//  Worldbikes
//
//  Created by a亲爱的 我自己 on 08/04/2012.
//  Copyright (c) 2012 Ericsson Software Campus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMLCrawlerDelegate.h"

@interface XMLCrawler : NSObject <XMLCrawlerDelegate>

- (BOOL) startCrawling:(NSURL*) url withHandler:(id)parserHandler;

@end
