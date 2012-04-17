//
//  TestXMLParser.m
//  Worldbikes
//
//  Created by a亲爱的 我自己 on 07/04/2012.
//  Copyright (c) 2012 Ericsson Software Campus. All rights reserved.
//

#import "TestCityParserHandler.h"
#import "CityParserHandler.h"
#import "XObjCity.h"
#import "XObjCountry.h"

@interface TestCityParserHandler ()

@property (nonatomic,strong) CityParserHandler *parserHandler;

@end


@implementation TestCityParserHandler
@synthesize parserHandler = _parserHandler;

-(void) testParserHandlerInit
{
    self.parserHandler = [[CityParserHandler alloc] init];
    STAssertNotNil(self.parserHandler,@ "failed to initialise an XMLParserDelegate object");
}

-(void) testParserHandler
{
    NSURL *url = [NSURL URLWithString:@"http://www.drpangpang.com/worldbikes.xml"];
    
    NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    
    STAssertNotNil(parser, @"failed to initialise a NSXMLParser object");
    
    self.parserHandler = [[CityParserHandler alloc] init];
    parser.delegate = self.parserHandler;
    
    STAssertTrue([parser parse], @"parsing failed");

}

@end
