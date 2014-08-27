//
//  OLYCoreTabBarController.m
//  EemployeePayroll
//
//  Created by Reynante Sabud on 5/14/14.
//  Copyright (c) 2014 Reynante Sabud. All rights reserved.
//

#import "OLYCoreTabBarController.h"


@interface OLYCoreTabBarController ()
{

    NSURLConnection *conn;
    NSXMLParser *xmlParser;
   
}


@end


@implementation OLYCoreTabBarController




//====================================

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [self.ResponseData setLength:0];
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    [self.ResponseData appendData:data];
}



- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:@"Connection Error..."
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    
    [alert show];
    
}



- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    xmlParser = [[NSXMLParser alloc] initWithData: self.ResponseData];
    [xmlParser setDelegate:self];
    [xmlParser setShouldResolveExternalEntities:YES];
    [xmlParser parse];
}

//---when the start of an element is found---
-(void) parser:(NSXMLParser *) parser didStartElement:(NSString *) elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *) qName attributes:(NSDictionary *)attributeDict {
    
    //GetClientAccountsInfoResult
    if( [elementName isEqualToString:[NSString stringWithFormat:@"%@Result", self.MethodName]])
    {
        if (!self.SoapResults)
        {
            self.SoapResults = [[NSMutableString alloc] init];
        }
        self.ElementFound = YES;
    }
}


-(void)parser:(NSXMLParser *) parser foundCharacters:(NSString *)string
{
    if (self.ElementFound)
    {
        [self.SoapResults appendString: string];
    }
}



@end
