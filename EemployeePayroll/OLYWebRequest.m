//
//  OLYWebRequest.m
//  EemployeePayroll
//
//  Created by Reynante Sabud on 7/31/13.
//  Copyright (c) 2013 Reynante Sabud. All rights reserved.
//

#import "OLYWebRequest.h"
#import "OLYJsonParcer.h"
@interface OLYWebRequest()
{

}

@end

@implementation OLYWebRequest


-(NSMutableDictionary *)GetClientAccountsInfo :(NSString *)EmailAddress :(NSString *) Ssn{
    
    OLYJsonParcer *objJson =[OLYJsonParcer new];
    objJson.MethodName = self.MethodName;
    
    
    NSURL *url = [NSURL URLWithString:@"https://myolympicpay.com/WebServices/EmplPayrollInfo.asmx"];
    //NSURL *url = [NSURL URLWithString:@"http://www.myolympicpay.com/WebServices/EmplPayrollInfo.asmx"];
   
    
    
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
                             ,self.MethodName
                             , EmailAddress
                             , Ssn
                             ,self.MethodName
                             ];
    
      
    NSMutableDictionary *jsonData =[objJson GetWebReturnData:soapMessage URL:url];
    
    return jsonData;
    
}


-(NSMutableDictionary *)GetPayrollHistory :(NSString *) EmpID{
    
    OLYJsonParcer *objJson =[OLYJsonParcer new];
    objJson.MethodName = self.MethodName;
    
    //NSURL *url = [NSURL URLWithString:@"http://www.myolympicpay.com/WebServices/EmplPayrollInfo.asmx"];
    NSURL *url = [NSURL URLWithString:@"https://myolympicpay.com/WebServices/EmplPayrollInfo.asmx"];
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<%@ xmlns=\"http://tempuri.org/\">\n"
                             "<strEmpID>%@</strEmpID>\n"
                             "</%@>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n"
                             ,self.MethodName
                             , EmpID
                             ,self.MethodName
                             ];
    NSMutableDictionary *jsonData =[objJson GetWebReturnData:soapMessage URL:url];
    
    return jsonData;

}

-(NSMutableDictionary *)GetPayrollHistory :(NSString *) EmpID :(NSString*) PickYear{
    
    OLYJsonParcer *objJson =[OLYJsonParcer new];
    objJson.MethodName = self.MethodName;
    
    NSURL *url = [NSURL URLWithString:@"https://myolympicpay.com/WebServices/EmplPayrollInfo.asmx"];
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
                             ,self.MethodName
                             , EmpID
                             ,PickYear
                             ,self.MethodName
                             ];
    NSMutableDictionary *jsonData =[objJson GetWebReturnData:soapMessage URL:url];
    
    return jsonData;
    
}




-(NSMutableDictionary *)GetPayrollDetails: (NSString *) ClientAccountID  :(NSString *) HistoryID {

    OLYJsonParcer *objJson =[OLYJsonParcer new];
    objJson.MethodName = self.MethodName;
    
    NSURL *url = [NSURL URLWithString:@"https://myolympicpay.com/WebServices/EmplPayrollInfo.asmx"];
   //NSURL *url = [NSURL URLWithString:@"http://www.myolympicpay.com/WebServices/EmplPayrollInfo.asmx"];
    
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
                             ,self.MethodName
                             , ClientAccountID
                             , HistoryID
                             ,self.MethodName
                             ];
    

       NSMutableDictionary *jsonData =[objJson GetWebReturnData:soapMessage URL:url];
    
    return jsonData;
    
}


 
@end
