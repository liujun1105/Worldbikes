//
//  TestXMLParser.m
//  Worldbikes
//
//  Created by a亲爱的 我自己 on 07/04/2012.
//  Copyright (c) 2012 Ericsson Software Campus. All rights reserved.
//

#import "TestXMLParser.h"
#import "XMLParserDelegate.h"

@interface TestXMLParser ()

@property (nonatomic,strong) XMLParserDelegate *delegate;

@end


@implementation TestXMLParser
@synthesize delegate = _delegate;

-(void) testXMLParserDelegateInit
{
    self.delegate = [[XMLParserDelegate alloc] init];
    STAssertNotNil(self.delegate,@"failed to initialise an XMLParserDelegate object");
}

-(void) testParser
{
    NSURL *url = [NSURL URLWithString:@"http://www.drpangpang.com/worldbikes.xml"];
    
    NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    
    STAssertNotNil(parser, @"failed to initialise a NSXMLParser object");
    
    self.delegate = [[XMLParserDelegate alloc] init];
    parser.delegate = self.delegate;
    
    STAssertTrue([parser parse], @"parsing failed");
}

@end
