//
//  XMLParser.m
//  Worldbikes
//
//  Created by a亲爱的 我自己 on 06/04/2012.
//  Copyright (c) 2012 Ericsson Software Campus. All rights reserved.
//

#import "XMLParserDelegate.h"

@implementation XMLParserDelegate

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    NSLog(@"start parsing xml document");
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    NSLog(@"end parsing xml document");
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
    NSLog(@"start element -> %@", elementName);
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    NSLog(@"end element -> %@", elementName);
}

@end
