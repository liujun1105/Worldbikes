//
//  XMLCrawler.m
//  Worldbikes
//
//  Created by a亲爱的 我自己 on 08/04/2012.
//  Copyright (c) 2012 Ericsson Software Campus. All rights reserved.
//

#import "XMLCrawler.h"
#import "WorldbikesParserHandler.h"

@interface XMLCrawler ()
@property (nonatomic,strong) NSArray *data;
@end

@implementation XMLCrawler
@synthesize data = _data;

- (BOOL) startCrawling:(NSURL*) url withHandler:(id)parserHandler
{
    assert(nil != parserHandler);
    NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    assert(nil != parser);
    
    parser.delegate = parserHandler;   
    
    assert(nil != parser.delegate);
    
    [parserHandler setCrawlerDelegate:self];
    
    assert(nil != [parserHandler crawlerDelegate]);
    BOOL status = [parser parse];
    
    
    
    return status;
}

- (void) grabData:(NSArray*) data
{
    self.data = [NSArray arrayWithArray:data];
}

@end
