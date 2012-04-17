//
//  RealtimeInfoParserHandler.m
//  Worldbikes
//
//  Created by a亲爱的 我自己 on 14/04/2012.
//  Copyright (c) 2012 Ericsson Software Campus. All rights reserved.
//

#import "RealtimeInfoParserHandler.h"
#import "XObjRealtimeInfo.h"

@interface RealtimeInfoParserHandler ()
@property (nonatomic,strong) NSMutableArray *realtimeInfos;
@property (nonatomic,strong) NSMutableString *characters;
@end

@implementation RealtimeInfoParserHandler
@synthesize crawlerDelegate = _crawlerDelegate;
@synthesize realtimeInfos = _realtimeInfos;
@synthesize characters = _characters;

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    NSLog(@"start parsing xml document of realtime information");
    self.realtimeInfos = [NSMutableArray array];
    self.characters = [NSMutableString string];
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    NSLog(@"end parsing xml document of realtime information");
    [self.crawlerDelegate grabData:self.realtimeInfos];
    [self setCharacters:nil];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{    
    if ([elementName isEqualToString:@"station"]) {
        [self.realtimeInfos addObject:[[XObjRealtimeInfo alloc] init]];
    }
    [self.characters setString:@""];    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    XObjRealtimeInfo *realtimeInfo = [self.realtimeInfos lastObject];
    if ([elementName isEqualToString:@"available"]) {
        realtimeInfo.available = [self.characters intValue];
    }
    else if ([elementName isEqualToString:@"ticket"]) {
        realtimeInfo.ticket = [self.characters intValue];
    }
    else if ([elementName isEqualToString:@"free"]) {
        realtimeInfo.free = [self.characters intValue];
    }
    else if ([elementName isEqualToString:@"total"]) {
        realtimeInfo.total = [self.characters intValue];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] > 0) {
        [self.characters appendString:string];
    }
}

@end
