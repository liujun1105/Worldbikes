//
//  TestRealtimeInfoParserHandler.m
//  Worldbikes
//
//  Created by a亲爱的 我自己 on 14/04/2012.
//  Copyright (c) 2012 Ericsson Software Campus. All rights reserved.
//

#import "TestRealtimeInfoParserHandler.h"
#import "RealtimeInfoParserHandler.h"

@interface TestRealtimeInfoParserHandler ()
@property (nonatomic,strong) RealtimeInfoParserHandler *parserHandler;
@end

@implementation TestRealtimeInfoParserHandler
@synthesize parserHandler = _parserHandler;


-(void) testParserHandlerInit
{
    self.parserHandler = [[RealtimeInfoParserHandler alloc] init];
    STAssertNotNil(self.parserHandler,@ "failed to initialise an XMLParserDelegate object");
}

-(void) testParserHandler
{
    NSURL *url = [NSURL URLWithString:@"https://abo-dublin.cyclocity.fr/service/stationdetails/dublin/1"];
    
    NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    
    STAssertNotNil(parser, @"failed to initialise a NSXMLParser object");
    
    self.parserHandler = [[RealtimeInfoParserHandler alloc] init];
    parser.delegate = self.parserHandler;
    
    STAssertTrue([parser parse], @"parsing failed");
    
}

@end
