//
//  OLYJsonParcer.m
//  EemployeePayroll
//
//  Created by Reynante Sabud on 9/6/13.
//  Copyright (c) 2013 Reynante Sabud. All rights reserved.
//

#import "OLYJsonParcer.h"
#import "OLYXMLParcer.h"


@implementation OLYJsonParcer

//http://www.myolympicpay.com

-(NSMutableDictionary *) getJSONData:(NSData *)requestData
{
    //NSMutableDictionary *jsonDict = nil;
    NSString *methodName = [NSString stringWithFormat:@"%@Result",self.MethodName];
   
    
    NSString *receivedText = [[NSString alloc] initWithData:requestData encoding:NSUTF8StringEncoding];
    
    //Get the JSON response string only.
    NSArray *array = [receivedText componentsSeparatedByString:
                      [NSString stringWithFormat: @"<%@>[",methodName]];
    
   // id x = [receivedText valueForKey: @"Name"];
    if ([array count] != 2 || [array count] == 0) {
        return nil;
    }
    
    receivedText = array[1];
    array = [receivedText componentsSeparatedByString:
             [NSString stringWithFormat: @"]</%@>",methodName]];
    
    if ([array count] != 2 || [array count] == 0) {
        return nil;
    }
    
    receivedText = array[0];
    
      
    //Convert JSON String to Dictionary.
    requestData = [receivedText dataUsingEncoding:NSUTF8StringEncoding];
    
    return [NSJSONSerialization
            JSONObjectWithData:requestData
            options:0
            error:nil];
    
    
    
    
   //return jsonDict ;
    
    
}

-(NSMutableDictionary *) convertToJSONData:(NSString *) txtJSON
{
    NSMutableDictionary *jsonDict = nil;
    
    
    NSData *requestData = [txtJSON dataUsingEncoding:NSUTF8StringEncoding];
    
      
    id object = [NSJSONSerialization
                 JSONObjectWithData:requestData
                 options:0
                 error:nil];
    
    
    
    
    
    if([object isKindOfClass:[NSDictionary class]])
    {
        jsonDict = object;
    }
    else
    {
        /* there's no guarantee that the outermost object in a JSON
         packet will be a dictionary; if we get here then it wasn't,
         so 'object' shouldn't be treated as an NSDictionary; probably
         you need to report a suitable error condition */
    }
    
    
    
    return jsonDict;
}


-(NSMutableDictionary *)GetWebReturnData :(NSString *)soapMessage URL:(NSURL*) url{
    

    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
      
    
    NSString *reqMethod = [NSString stringWithFormat: @"http://tempuri.org/%@",self.MethodName];
    
    
    [urlRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [urlRequest addValue: reqMethod forHTTPHeaderField:@"SOAPAction"];
    [urlRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    
    NSError *error;
    NSURLResponse *response;
    
    
    NSData *result = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
   
    NSMutableDictionary *jsonData = [NSMutableDictionary new];
    
   
    if(!theConnection ){
        UIAlertView  *alert = [[UIAlertView alloc] initWithTitle:@""
                                             message:@"Connection not available."
                                            delegate:nil
                                   cancelButtonTitle:@"OK"
                                   otherButtonTitles:nil];
          
          [alert show];
          return nil;

    }
    else{
        jsonData = [self getJSONData:result];
     }
    
    return jsonData;
    
}


@end
