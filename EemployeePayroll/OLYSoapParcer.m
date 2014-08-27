//
//  OLYSoapParcer.m
//  EemployeePayroll
//
//  Created by Reynante Sabud on 10/2/13.
//  Copyright (c) 2013 Reynante Sabud. All rights reserved.
//

#import "OLYSoapParcer.h"

@implementation OLYSoapParcer
@synthesize soap_responseData, currentAction, delegate;

#pragma mark - Initialize Parsing
-(void)startParsingWithAction:(NSString *)action andWithParams:(NSDictionary *)params
{
    self.currentAction = action;
    
    NSString *reqSOAPmsg = [self createSoapMesssageFrom:params];
    
    NSURL *url = [NSURL URLWithString:SERVICE_URL];
    
    soap_request = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [reqSOAPmsg length]];
    
    [soap_request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [soap_request addValue: [NSString stringWithFormat:@"%@/%@",TEMP_URL,self.currentAction] forHTTPHeaderField:@"SOAPAction"];
    [soap_request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [soap_request setHTTPMethod:@"POST"];
    [soap_request setHTTPBody: [reqSOAPmsg dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLConnection *cn = [[NSURLConnection alloc] initWithRequest:soap_request delegate:self];
    [cn start];
}

#pragma mark - Create SOAP message
-(NSString *)createSoapMes/Users/reynantesabud/Desktop/Projects/EemployeePayroll/EemployeePayroll/en.lproj/MainStoryboard.storyboardssageFrom:(NSDictionary *)requestParam
{
    NSMutableString *soapMessage = [[NSMutableString alloc] init];
    
    [soapMessage appendFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
     "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
     "<soap:Body>\n"
     "<%@ xmlns=\"http://tempuri.org/\">\n",self.currentAction];
    
    for(NSString *key in requestParam)
    {
        [soapMessage appendFormat:@"<%@>%@</%@>\n",key,[requestParam valueForKey:key],key];
    }
    [soapMessage appendFormat:@"</%@>\n"
     "</soap:Body>\n"
     "</soap:Envelope>",self.currentAction];
    
    NSLog(@"%@",soapMessage);
    return soapMessage;
}

#pragma mark - NSURLConnection Delegate
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    
    if([delegate respondsToSelector:@selector(receivedResponseWithStatusCode:)])
    {
        [delegate performSelector:@selector(receivedResponseWithStatusCode:) withObject:httpResponse];
    }
    self.soap_responseData = [[NSMutableData alloc] initWithCapacity:0];
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.soap_responseData appendData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if([delegate respondsToSelector:@selector(requestFailedWithError:)])
    {
        [delegate performSelector:@selector(requestFailedWithError:) withObject:error];
    }
    
    connection = nil;
    self.soap_responseData = nil;
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if([delegate respondsToSelector:@selector(dataReceivingCompleted:)])
    {
        [delegate performSelector:@selector(dataReceivingCompleted:) withObject:self.soap_responseData];
    }
}
@end
