//
//  OLYCurrentPayrollMainViewController.m
//  EemployeePayroll
//
//  Created by Reynante Sabud on 4/7/14.
//  Copyright (c) 2014 Reynante Sabud. All rights reserved.
//

#import "OLYCurrentPayrollMainViewController.h"
#import "OLYCurrentPayrollViewControllerNet.h"
#import "OLYCurrentPayrollViewControllerYTD.h"
#import "OLYWebRequest.h"
#import "OLYSoapMessages.h"

@interface OLYCurrentPayrollMainViewController () 
{

    
    NSDictionary* earningRequestDict;
    NSDictionary* taxesRequestDict;
    NSString *sentID;
    
}

@end




@implementation OLYCurrentPayrollMainViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
   
     self.title = @"Latest Payroll";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.hidden = NO;

  
    UIBarButtonItem *email = [[UIBarButtonItem alloc]
                              initWithImage:[UIImage imageNamed:@"Email_Circle2.png"] style:UIBarButtonItemStylePlain target:self action:@selector(SendEmail)];

    
    self.navigationItem.rightBarButtonItem = email;
   
  [self.navigationController setToolbarHidden:YES animated:YES];
    
    [self GetNetValue];
    [self SetNextController];
    
 
}

-(void)viewWillAppear{
    
    //self.navigationController.toolbarHidden = YES;
    
    
}


-(void)SetNextController{
   
    sentID =[[[self.EmailDetails objectForKey:@"Details"] objectAtIndex:0] valueForKey:@"SentID"];
    

    OLYCurrentPayrollViewControllerNet *vcNet =  [[self viewControllers] objectAtIndex:0];
    vcNet.SentID = sentID;
    vcNet.RecordNumber = self.RecordNumber;
    vcNet.EmailDetails = self.EmailDetails;
    vcNet.EmpName = self.EmpName;
    vcNet.CompName = self.CompName;
    vcNet.PayDate =self.PayDate;
    vcNet.NetValue = self.NetValue;
    
    
    OLYCurrentPayrollViewControllerYTD *vcYTD =  [[self viewControllers] objectAtIndex:1];
    vcYTD.RecordNumber = self.RecordNumber;
    vcYTD.EmailDetails = self.EmailDetails;
    vcYTD.EmpName = self.EmpName;
    vcYTD.CompName = self.CompName;

    
    
}


-(void)SendEmail{
    
    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"This will send a PDF copy to your e-mail, proceed anyway?"
                          message:nil
                          delegate:self
                          cancelButtonTitle:@"Cancel"
                          otherButtonTitles:@"Yes", nil];
    alert.tag =1010;
    [alert show];
    
 
    
}




//================================
#pragma mark - Private Methods
//=================================
-(void)GetNetValue
{
    
    
    id  payrollDetailsDict=[[self.EmailDetails objectForKey:@"Details"] objectAtIndex:self.RecordNumber];
    
    
    NSMutableArray* earningRequest = [payrollDetailsDict valueForKey:@"Earnings"];
    NSMutableArray* taxesRequest = [payrollDetailsDict valueForKey:@"Taxes"];
    NSMutableArray* deductionsRequest = [payrollDetailsDict valueForKey:@"Deductions"];
    NSMutableArray* reverseTipsRequest = [payrollDetailsDict valueForKey:@"ReverseTips"];
    
    
    
    NSDecimalNumber *totalEarningGross = [NSDecimalNumber decimalNumberWithString:@"0"];
    NSDecimalNumber *totalTaxes = [NSDecimalNumber decimalNumberWithString:@"0"];
    NSDecimalNumber *totalDeductions = [NSDecimalNumber decimalNumberWithString:@"0"];
    NSDecimalNumber *totslReversTips = [NSDecimalNumber decimalNumberWithString:@"0"];
    NSDecimalNumber *netTotal = [NSDecimalNumber decimalNumberWithString:@"0"];
    NSDecimalNumber *valTotal = [NSDecimalNumber decimalNumberWithString:@"0"];
    

    for (NSDictionary * dict in earningRequest) {  //for each dictionary in the first array
        
        valTotal = [NSDecimalNumber decimalNumberWithString:[dict valueForKey:@"CURRENT"]];
        totalEarningGross=[totalEarningGross decimalNumberByAdding:valTotal];
       
    }
    
    
    
    
    for (int i=0; i<[taxesRequest count]; i++) {
        
        valTotal = [NSDecimalNumber decimalNumberWithString:[[taxesRequest valueForKey:@"CURRENT"]objectAtIndex:i]];
        totalTaxes =[totalTaxes decimalNumberByAdding:valTotal];
    }
    
    for (int i=0; i<[deductionsRequest count]; i++) {
        
        valTotal = [NSDecimalNumber decimalNumberWithString:[[deductionsRequest valueForKey:@"CURRENT"]objectAtIndex:i]];
        totalDeductions =[totalDeductions decimalNumberByAdding:valTotal];
    }
    
    for (int i=0; i<[reverseTipsRequest count]; i++) {
        valTotal = [NSDecimalNumber decimalNumberWithString:[[reverseTipsRequest valueForKey:@"CURRENT"]objectAtIndex:i]];
        totslReversTips =[totslReversTips decimalNumberByAdding:valTotal];
    }
    
    netTotal = [netTotal decimalNumberByAdding:totalEarningGross];
    netTotal = [netTotal decimalNumberByAdding:totslReversTips];
    netTotal = [netTotal decimalNumberBySubtracting:totalTaxes];
    netTotal = [netTotal decimalNumberBySubtracting:totalDeductions];
    
    
    
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    
    NSString *formatted = [formatter stringFromNumber :netTotal];
    
    self.NetValue =  [formatted stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@""];
    
    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        
        if(alertView.tag == 1010)
        {
            OLYSoapMessages *objSoapMsg =[OLYSoapMessages new];
            
            self.MethodName = @"SendEmailFromPhone";
            
            [objSoapMsg SendEmailSendID:sentID MethodName:self.MethodName];
            
            [self FireRequest: objSoapMsg.UrlRequest];
        }
        
    }
    
}


-(void)FireRequest :(NSMutableURLRequest*)urlRequest
{
    
    
    //Fire away.
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    
    if (theConnection)
    {
        self.ResponseData = [NSMutableData data];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"No Internet Connection."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        
        [alert show];
    }
    
    
}







@end












