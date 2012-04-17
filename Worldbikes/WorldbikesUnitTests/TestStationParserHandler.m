//
//  TestStationParserHandler.m
//  Worldbikes
//
//  Created by a亲爱的 我自己 on 14/04/2012.
//  Copyright (c) 2012 Ericsson Software Campus. All rights reserved.
//

#import "TestStationParserHandler.h"
#import "StationParserHandler.h"
#import "WorldbikesParserHandler.h"

@interface TestStationParserHandler ()
@property (nonatomic,strong) StationParserHandler *parserHandler;
@end

@implementation TestStationParserHandler
@synthesize parserHandler = _parserHandler;

-(void) testParserHandlerInit
{
    self.parserHandler = [[StationParserHandler alloc] init];
    STAssertNotNil(self.parserHandler,@ "failed to initialise an XMLParserDelegate object");
}

-(void) testParserHandler
{
    NSURL *url = [NSURL URLWithString:@"https://abo-dublin.cyclocity.fr/service/carto"];
    
    NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    
    STAssertNotNil(parser, @"failed to initialise a NSXMLParser object");
    
    self.parserHandler = [[StationParserHandler alloc] init];
    parser.delegate = self.parserHandler;
    
    STAssertTrue([parser parse], @"parsing failed");
    
}

@end
