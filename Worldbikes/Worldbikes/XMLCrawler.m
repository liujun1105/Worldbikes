//
//  XMLCrawler.m
//  Worldbikes
//
//  Created by a亲爱的 我自己 on 08/04/2012.
//  Copyright (c) 2012 Ericsson Software Campus. All rights reserved.
//

#import "XMLCrawler.h"

@interface XMLCrawler ()
@property (nonatomic,strong) NSArray *data;
@end

@implementation XMLCrawler
@synthesize data = _data;

- (void) grabData:(NSArray*) data
{
    self.data = [NSArray arrayWithArray:data];
}

@end
