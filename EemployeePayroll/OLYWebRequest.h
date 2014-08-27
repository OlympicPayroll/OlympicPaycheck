//
//  OLYWebRequest.h
//  EemployeePayroll
//
//  Created by Reynante Sabud on 7/31/13.
//  Copyright (c) 2013 Reynante Sabud. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OLYWebRequest : NSObject


@property(nonatomic, weak) NSString *MethodName;

-(NSMutableDictionary *)GetClientAccountsInfo :(NSString *)EmailAddress :(NSString *) Ssn;
-(NSMutableDictionary *)GetPayrollHistory :(NSString *) EmpID;
-(NSMutableDictionary *)GetPayrollHistory :(NSString *) EmpID :(NSString*) PickYear;

-(NSMutableDictionary *)GetPayrollDetails: (NSString *) ClientAccountID :(NSString *) HistoryID ;

@end
