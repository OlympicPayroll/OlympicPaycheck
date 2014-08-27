//
//  OLYSoapMessages.h
//  EemployeePayroll
//
//  Created by Reynante Sabud on 4/29/14.
//  Copyright (c) 2014 Reynante Sabud. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OLYSoapMessages : NSObject

@property (nonatomic, strong) NSMutableURLRequest *UrlRequest;

-(void) GetClientAccountsInfo :(NSString*) email SSN:(NSString*) ssn MethodName:(NSString*)methodName;

-(void) GetClientAccountsInfo :(NSString*) email SSN:(NSString*) ssn DeviceToken:(NSString*)deviceToken MethodName:(NSString*)methodName;

-(void)GetPayrollYears :(NSString *)EmpID MethodName:(NSString*)methodName;


-(void)GetEmployeePhoto :(NSString *)EmpID MethodName:(NSString*)methodName;


-(void)GetPayrollHistory :(NSString *)EmpID MethodName:(NSString*)methodName;

-(void)GetPayrollHistory :(NSString *) EmpID PickYear:(NSString*)pickYear MethodName:(NSString*)methodName;

-(void)GetPayrollDetails: (NSString *) clientAccountID  HistoryID:(NSString *) historyID  MethodName:(NSString*)methodName;

-(void)GetMultipleCheckListEmpID: (NSString *) empID CheckDate:(NSString*)checkDate MethodName:(NSString*)methodName;

-(void)GetEmpCombinedPayrollEmpID: (NSString *) empID CheckDate:(NSString*)checkDate MethodName:(NSString*)methodName;

-(void)SendEmailSendID: (NSString *) sendID  MethodName:(NSString*)methodName;

-(void)FlagReadPayrolls: (NSString *) sendID  MethodName:(NSString*)methodName;

-(void)InsertBase64Photo: (NSString *) empID Base64String:(NSString*) base64String MethodName:(NSString*)methodName;


-(void) PrepareJpegImageRequest :(NSString*) methodName ImageData:(NSData*) imgData;

-(void)WCFTest :(NSString*)methodName;

@end
