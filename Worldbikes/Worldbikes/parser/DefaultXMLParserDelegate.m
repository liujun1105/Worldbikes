//
//  XMLParser.m
//  Worldbikes
//
//  Created by a亲爱的 我自己 on 06/04/2012.
//  Copyright (c) 2012 Ericsson Software Campus. All rights reserved.
//

#import "XMLParserDelegate.h"

@interface XMLParserDelegate ()

@property (nonatomic,strong) NSMutableArray *stack;



@end

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

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] > 0) {
        NSLog(@"characters -> %@", string);
    }
}

- (void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock
{
    NSLog(@"%@", CDATABlock);
}

@end
