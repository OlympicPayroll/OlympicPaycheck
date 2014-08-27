//
//  OLYSoapParcer.h
//  EemployeePayroll
//
//  Created by Reynante Sabud on 10/2/13.
//  Copyright (c) 2013 Reynante Sabud. All rights reserved.
//
#define DOMAIN_URL      @"http://www.myolympicpay.com/WebServices/"
#define SERVICE_URL     DOMAIN_URL@"/EmplPayrollInfo.asmx"
#define TEMP_URL        @"http://tempuri.org"

#import <Foundation/Foundation.h>

@protocol soap_parser_delegate <NSObject>

@optional
-(void)receivedResponseWithStatusCode:(NSInteger)statusCode;
-(void)requestFailedWithError:(NSError *)err;
@required
-(void)dataReceivingCompleted:(NSMutableData *)data;

@end

#import <Foundation/Foundation.h>

@interface OLYSoapParcer : NSObject
{
NSMutableURLRequest *soap_request;
NSURLResponse *soap_response;
NSMutableData *soap_responseData;

NSString *currentAction;

id <soap_parser_delegate>delegate;
}


@property (nonatomic, retain) NSMutableData *soap_responseData;
@property (nonatomic, retain) NSString *currentAction;
@property (nonatomic, retain) id <soap_parser_delegate>delegate;

#pragma mark - Initialize Parsing
-(void)startParsingWithAction:(NSString *)action andWithParams:(NSDictionary *)params;

#pragma mark - Create SOAP message
-(NSString *)createSoapMesssageFrom:(NSDictionary *)requestParam;

@end
