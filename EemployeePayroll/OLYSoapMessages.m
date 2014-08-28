//
//  OLYSoapMessages.m
//  EemployeePayroll
//
//  Created by Reynante Sabud on 4/29/14.
//  Copyright (c) 2014 Reynante Sabud. All rights reserved.
//

#import "OLYSoapMessages.h"

@implementation OLYSoapMessages


-(void) GetClientAccountsInfo :(NSString*) email SSN:(NSString*) ssn MethodName:(NSString*)methodName
{
    


NSString *soapMessage = [NSString stringWithFormat:
                         @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                         "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                         "<soap:Body>\n"
                         "<%@ xmlns=\"http://tempuri.org/\">\n"
                         "<emailAddress>%@</emailAddress>\n"
                         "<ssn>%@</ssn>\n"
                         "</%@>\n"
                         "</soap:Body>\n"
                         "</soap:Envelope>\n"
                         ,methodName
                         ,email
                         ,ssn
                         ,methodName
                         ];

    [self PrepareRequest:methodName SoapMessage:soapMessage];

}





-(void) GetClientAccountsInfo :(NSString*) email SSN:(NSString*) ssn DeviceToken:(NSString*)deviceToken DeviceType:(NSString*)deviceType MethodName:(NSString*)methodName
{
    
    //deviceToken=@"abcd";
        NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<%@ xmlns=\"http://tempuri.org/\">\n"
                             "<emailAddress>%@</emailAddress>\n"
                             "<ssn>%@</ssn>\n"
                             "<deviceToken>%@</deviceToken>\n"
                             "<deviceType>%@</deviceType>\n"
                             "</%@>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n"
                             ,methodName
                             ,email
                             ,ssn
                             ,deviceToken
                             ,deviceType
                             ,methodName
                             ];
    
    [self PrepareRequest:methodName SoapMessage:soapMessage];
    
}



-(void)GetPayrollYears :(NSString *)EmpID MethodName:(NSString*)methodName{
    
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<%@ xmlns=\"http://tempuri.org/\">\n"
                             "<strEmpID>%@</strEmpID>\n"
                             "</%@>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n"
                             ,methodName
                             , EmpID
                             ,methodName
                             ];
    
    [self PrepareRequest:methodName SoapMessage:soapMessage];
    
}




-(void)GetEmployeePhoto:(NSString *)EmpID MethodName:(NSString *)methodName{
    
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<%@ xmlns=\"http://tempuri.org/\">\n"
                             "<strEmpID>%@</strEmpID>\n"
                             "</%@>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n"
                             ,methodName
                             , EmpID
                             ,methodName
                             ];
    
    [self PrepareRequest:methodName SoapMessage:soapMessage];
    
}




-(void)GetPayrollHistory :(NSString *)EmpID MethodName:(NSString*)methodName{
    

    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<%@ xmlns=\"http://tempuri.org/\">\n"
                             "<strEmpID>%@</strEmpID>\n"
                             "</%@>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n"
                             ,methodName
                             , EmpID
                             ,methodName
                             ];
    
   [self PrepareRequest:methodName SoapMessage:soapMessage];
    //[self PrepareImageRequest:methodName SoapMessage:soapMessage EmployeeID:EmpID];
}

-(void)GetPayrollHistory :(NSString *) EmpID PickYear:(NSString*)pickYear MethodName:(NSString*)methodName{
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<%@ xmlns=\"http://tempuri.org/\">\n"
                             "<strEmpID>%@</strEmpID>\n"
                             "<strYear>%@</strYear>\n"
                             "</%@>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n"
                             ,methodName
                             , EmpID
                             ,pickYear
                             ,methodName
                             ];
    
     [self PrepareRequest:methodName SoapMessage:soapMessage];

}

-(void)GetPayrollDetails: (NSString *) clientAccountID  HistoryID:(NSString *) historyID  MethodName:(NSString*)methodName{
    
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<%@ xmlns=\"http://tempuri.org/\">\n"
                             "<strClientAccountID>%@</strClientAccountID>\n"
                             "<strHistID>%@</strHistID>\n"
                             "</%@>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n"
                             ,methodName
                             , clientAccountID
                             , historyID
                             ,methodName
                             ];
    
    
    [self PrepareRequest:methodName SoapMessage:soapMessage];
    
}


-(void)GetMultipleCheckListEmpID: (NSString *) empID CheckDate:(NSString*)checkDate MethodName:(NSString*)methodName{
    
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<%@ xmlns=\"http://tempuri.org/\">\n"
                             "<strEmpID>%@</strEmpID>\n"
                             "<strCheckDate>%@</strCheckDate>\n"
                             "</%@>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n"
                             ,methodName
                             ,empID
                             ,checkDate
                             ,methodName
                             ];
    
    
    [self PrepareRequest:methodName SoapMessage:soapMessage];
    
}



-(void)GetEmpCombinedPayrollEmpID: (NSString *) empID CheckDate:(NSString*)checkDate MethodName:(NSString*)methodName{
    
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<%@ xmlns=\"http://tempuri.org/\">\n"
                             "<strEmpID>%@</strEmpID>\n"
                             "<strCheckDate>%@</strCheckDate>\n"
                             "</%@>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n"
                             ,methodName
                             ,empID
                             ,checkDate
                             ,methodName
                             ];
    
    
    [self PrepareRequest:methodName SoapMessage:soapMessage];
    
}




-(void)SendEmailSendID: (NSString *) sendID  MethodName:(NSString*)methodName{
    
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<%@ xmlns=\"http://tempuri.org/\">\n"
                             "<strSendID>%@</strSendID>\n"
                             "</%@>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n"
                             ,methodName
                             ,sendID
                             ,methodName
                             ];
    
    
    [self PrepareRequest:methodName SoapMessage:soapMessage];
    
}



-(void)FlagReadPayrolls: (NSString *) sendID  MethodName:(NSString*)methodName{
    
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<%@ xmlns=\"http://tempuri.org/\">\n"
                             "<strSendID>%@</strSendID>\n"
                             "</%@>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n"
                             ,methodName
                             ,sendID
                             ,methodName
                             ];
    
    
    [self PrepareRequest:methodName SoapMessage:soapMessage];
    
}



-(void)InsertBase64Photo: (NSString *) empID Base64String:(NSString*) base64String MethodName:(NSString*)methodName{
    
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<%@ xmlns=\"http://tempuri.org/\">\n"
                             "<strEmpID>%@</strEmpID>\n"
                             "<strBase64String>%@</strBase64String>\n"
                             "</%@>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n"
                             ,methodName
                             ,empID
                             ,base64String
                             ,methodName
                             ];
    
    
    [self PrepareJpegImageRequest:methodName SoapMessage:soapMessage];
    
}





-(void) PrepareRequest :(NSString*) methodName SoapMessage:(NSString*) soapMessage {
    
    NSURL *url = [NSURL URLWithString:@"https://myolympicpay.com/WebServices/EmplPayrollInfo.asmx"];
    
    
    self.UrlRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    
    NSString *reqMethod = [NSString stringWithFormat: @"http://tempuri.org/%@",methodName];
    
    
   [self.UrlRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
   [self.UrlRequest addValue: reqMethod forHTTPHeaderField:@"SOAPAction"];
   [self.UrlRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
   [self.UrlRequest setHTTPMethod:@"POST"];
   [self.UrlRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];

    
}

-(void) PrepareJpegImageRequest :(NSString*) methodName SoapMessage:(NSString*) soapMessage {
    
    NSURL *url = [NSURL URLWithString:@"https://myolympicpay.com/WebServices/EmplPayrollInfo.asmx"];
    
    
    self.UrlRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    
    NSString *reqMethod = [NSString stringWithFormat: @"http://tempuri.org/%@",methodName];
    
    
    [self.UrlRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [self.UrlRequest addValue: reqMethod forHTTPHeaderField:@"SOAPAction"];
    [self.UrlRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [self.UrlRequest setHTTPMethod:@"POST"];
    [self.UrlRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    
}

/*
-(void) PrepareJpegImageRequest :(NSString*) methodName ImageData:(NSData*) imgData {
    
    NSURL *url = [NSURL URLWithString:@"https://myolympicpay.com/WebServices/EmplPayrollInfo.asmx"];
    
    
    self.UrlRequest = [NSMutableURLRequest requestWithURL:url];
     
    
    [self.UrlRequest addValue: @"image/jpeg" forHTTPHeaderField:@"Content-Type"];
    [self.UrlRequest setHTTPBody: imgData];
    
    
}
*/

-(void)WCFTest :(NSString*)methodName{
    
    /*
    NSString *soapMessage = [NSString stringWithFormat:
							 @"<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
							 "<SOAP-ENV:Envelope \n"
							 "xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"; \n"
							 "xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"; \n"
							 "xmlns:SOAP-ENC=\"http://schemas.xmlsoap.org/soap/encoding/\"; \n"
							 "SOAP-ENV:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\"; \n"
							 "xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\">; \n"
							 "<SOAP-ENV:Body> \n"
							 "<GetData xmlns=\"http://tempuri.org/\">"
                             "<value>77</value>\n"
							 "</GetData> \n"
							 "</SOAP-ENV:Body> \n"
							 "</SOAP-ENV:Envelope>"];

    
   */
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<%@ xmlns=\"http://tempuri.org/\">\n"
                             "<value>77</value>\n"
                             "</%@>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n"
                             ,methodName
                             ,methodName
                             ];
    
    
    NSURL *url = [NSURL URLWithString:@"http:/74.208.64.78:8000/OLYService.svc/singleWsdl"];
    
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"http://tempuri.org/IService1/GetData" forHTTPHeaderField:@"Soapaction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
	
    NSError *error;
    NSURLResponse *response;
    NSData *result = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:&response error:&error];
    
    
    if(theConnection) {

    }
    else {
        NSLog(@"theConnection is NULL");
	}


    
}




-(void) PrepareImageRequest :(NSString*) methodName SoapMessage:(NSString*) soapMessage EmployeeID:(NSString*)empID {
    
    NSURL *url = [NSURL URLWithString:
                  [NSString stringWithFormat:@"%@%@", @"https://myolympicpay.com/DownloadPhotos.ashx?EmpID=",empID]];
    
    
    self.UrlRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    
    NSString *reqMethod = [NSString stringWithFormat: @"http://tempuri.org/%@",methodName];
    
    
    [self.UrlRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [self.UrlRequest addValue: reqMethod forHTTPHeaderField:@"SOAPAction"];
    [self.UrlRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [self.UrlRequest setHTTPMethod:@"POST"];
    [self.UrlRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    
}

@end








