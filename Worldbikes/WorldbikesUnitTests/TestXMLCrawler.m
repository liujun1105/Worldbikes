//
//  TestXMLCrawler.m
//  Worldbikes
//
//  Created by a亲爱的 我自己 on 14/04/2012.
//  Copyright (c) 2012 Ericsson Software Campus. All rights reserved.
//

#import "TestXMLCrawler.h"
#import "XMLCrawler.h"
#import "StationParserHandler.h"
#import "CityParserHandler.h"
#import "RealtimeInfoParserHandler.h"

@interface TestXMLCrawler ()
@property (nonatomic,strong) XMLCrawler *crawler;
@end

@implementation TestXMLCrawler
@synthesize crawler = _crawler;


- (void) setUp
{
    self.crawler = [[XMLCrawler alloc] init];
}

- (void) testXMLCrawler_BicycleScheme
{
    NSURL *url = [NSURL URLWithString:@"http://www.drpangpang.com/worldbikes.xml"];
    CityParserHandler *parserHandler = [[CityParserHandler alloc] init];
    STAssertTrue([self.crawler startCrawling:url withHandler:parserHandler], @"crawling failed");
    STAssertTrue([[self.crawler data] count] > 0, @"incorrect result");    
}

- (void) testXMLCrawler_RealtimeInfo
{
    NSURL *url = [NSURL URLWithString:@"https://abo-dublin.cyclocity.fr/service/stationdetails/dublin/1"];
    RealtimeInfoParserHandler *parserHandler = [[RealtimeInfoParserHandler alloc] init];
    STAssertTrue([self.crawler startCrawling:url withHandler:parserHandler], @"crawling failed");
    STAssertTrue([[self.crawler data] count] > 0, @"incorrect result");    
}

- (void) testXMLCrawler_Stations
{
    NSURL *url = [NSURL URLWithString:@"https://abo-dublin.cyclocity.fr/service/carto"];
    StationParserHandler *parserHandler = [[StationParserHandler alloc] init];
    STAssertTrue([self.crawler startCrawling:url withHandler:parserHandler], @"crawling failed");
    STAssertTrue([[self.crawler data] count] > 0, @"incorrect result");
}

@end
