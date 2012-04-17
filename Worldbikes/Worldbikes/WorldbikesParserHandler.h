//
//  WorldbikesParserHandler.h
//  Worldbikes
//
//  Created by a亲爱的 我自己 on 14/04/2012.
//  Copyright (c) 2012 Ericsson Software Campus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMLCrawlerDelegate.h"

@protocol WorldbikesParserHandler <NSXMLParserDelegate>

@property id <XMLCrawlerDelegate> crawlerDelegate;

@end
