//
//  OLYXMLParcer.m
//  EemployeePayroll
//
//  Created by Reynante Sabud on 9/11/13.
//  Copyright (c) 2013 Reynante Sabud. All rights reserved.
//

#import "OLYXMLParcer.h"

@implementation OLYXMLParcer
{
 
}

-(void)loadDataFromXML:(NSMutableData*) data{
    
  
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict{

    
    
    if ([elementName isEqualToString:@"GetClientAccountsInfoResponse"]) {
        
        id value = [attributeDict valueForKey:@"GetClientAccountsResult"] ;
        NSLog(@"%@",value);
       // int id = [[attributeDict valueForKey:@"GetClientAccountsInfoResult"] intValue];
       // NSLog(@"Title: %@, ID: %i", title, id);
    }
   
}

@end
