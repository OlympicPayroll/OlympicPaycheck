//
//  OLYHomeViewController.m
//  EemployeePayroll
//
//  Created by Reynante Sabud on 7/31/13.
//  Copyright (c) 2013 Reynante Sabud. All rights reserved.
//

#import "OLYHomeViewController.h"
//#import "OLYWebRequest.h"
#import "OLYDetailViewController.h"
#import "OLYSoapMessages.h"
#import "OLYCheckListPreviousPayroll.h"
@interface OLYHomeViewController ()
{
    int tapCount;
    NSString *historyID;
    NSString *checkDateString;
    NSString *checkDate;
    NSInteger checkCount;
    BOOL isCombined;
    UIActivityIndicatorView *spinner;

}

@end

@implementation OLYHomeViewController
//@synthesize tableView;





-(void)viewDidLoad
{
    [super viewDidLoad];
   
    self.title=@"Previous Payrolls";
    self.lblName.text = [NSString stringWithFormat:@"%@",self.EmpName ];
    self.lblCompName.text = self.CompName;
    self.automaticallyAdjustsScrollViewInsets=NO;
  

    self.lblYear.text =self.PickYear;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

   
}


-(void)viewWillAppear:(BOOL)animated{
    tapCount=0;
}


-(void)GetWebData{
    
    OLYSoapMessages *objSoapMsg =[OLYSoapMessages new];
    
    self.MethodName = @"GetPayrollHistory";

    [objSoapMsg GetPayrollHistory :self.EmpID PickYear:self.PickYear MethodName:self.MethodName];

    
    //Fire away.
    [self FireRequest: objSoapMsg.UrlRequest];
    
}


-(void)GetWCombinedChecks:(NSString*) pCheckDate{
    
    OLYSoapMessages *objSoapMsg =[OLYSoapMessages new];
    
    self.MethodName = @"GetEmpCombinedPayroll";
    
    [objSoapMsg GetEmpCombinedPayrollEmpID:self.EmpID CheckDate:pCheckDate MethodName:self.MethodName];
   
    
    //Fire away.
    [self FireRequest: objSoapMsg.UrlRequest];
    
}




#pragma mark UITableViewDataSource

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    if(tapCount==0){
        tapCount++;
        
        historyID = [[self.CheckData valueForKey:@"Id"] objectAtIndex: indexPath.row];
        checkDateString = [[self.CheckData valueForKey:@"CheckMonth"] objectAtIndex: indexPath.row];
    
        isCombined = [[[self.CheckData valueForKey:@"IsCombined"] objectAtIndex: indexPath.row] boolValue];
        
        
        if (isCombined) {
 
            [self GetWCombinedChecks: [[self.CheckData valueForKey:@"CheckDate"] objectAtIndex: indexPath.row] ];
        }
        else{
            checkCount = [[[self.CheckData valueForKey:@"CheckCount"] objectAtIndex: indexPath.row] integerValue];
            
            //if multiple Checks.
            if(checkCount > 1)
            {
                checkDate = [[self.CheckData valueForKey:@"CheckDate"] objectAtIndex: indexPath.row];
                
            }
            
            [self GetEmployeePayrollDetails];
        }
        
        
  
    
       
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSInteger checkQty = [[[self.CheckData valueForKey:@"CheckCount"] objectAtIndex: indexPath.row] integerValue];
    NSString *lblText=@"";
    

    
    if (checkQty>1)
    {
       BOOL isCombinedtemp = [[[self.CheckData valueForKey:@"IsCombined"] objectAtIndex: indexPath.row] boolValue];
       NSString *checkLabel = (isCombinedtemp)? @"Combined" : @"Checks";
        
        lblText=[NSString stringWithFormat:@"       (%ld %@)", (long)checkQty, checkLabel];
    }
    
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    cell.textLabel.text =[NSString stringWithFormat:@"%@%@"
                          ,[[self.CheckData valueForKey:@"CheckMonth"] objectAtIndex: indexPath.row]
                          ,lblText];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"$ %@",
                                 [[self.CheckData valueForKey:@"NetPay"] objectAtIndex: indexPath.row]
                                ];
                                
    
    cell.textLabel.textColor=[UIColor blackColor];
    cell.detailTextLabel.textColor= [UIColor colorWithRed:5/255.f green:197/255.f blue:150/255.f alpha:1.0f];
    cell.detailTextLabel.font =[UIFont boldSystemFontOfSize:17];
    //[UIColor colorWithRed:0.1491f green:0.6706f blue:0.8863f alpha:1.0f];
    return cell;
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [self.CheckData count];
    
}



-(void)GetEmployeePayrollDetails
{
    
    OLYSoapMessages *objSoapMsg =[OLYSoapMessages new];
    
    self.MethodName = @"GetEmployeePayrollDetails";
    
    [objSoapMsg GetPayrollDetails:self.ClientAccountID HistoryID:historyID MethodName:self.MethodName];
    

    //Fire away.
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:objSoapMsg.UrlRequest delegate:self];
    
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
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}



-(void)GetMultipleCheckList
{
    
    OLYSoapMessages *objSoapMsg =[OLYSoapMessages new];
    
    self.MethodName = @"GetMultipleCheckList";
    
    [objSoapMsg GetMultipleCheckListEmpID:self.EmpID CheckDate:checkDate MethodName:self.MethodName];
    
    //Fire away.
  [self FireRequest: objSoapMsg.UrlRequest];
    
}




-(void)parser:(NSXMLParser *)parser
didEndElement:(NSString *)elementName
 namespaceURI:(NSString *)namespaceURI
qualifiedName:(NSString *)qName
{
    
    if ([elementName isEqualToString:[NSString stringWithFormat:@"%@Result", self.MethodName]])
    {
        
        
        NSData *requestResult = [self.SoapResults dataUsingEncoding:NSUTF8StringEncoding];
        
       NSMutableDictionary *requestedData = [NSJSONSerialization  JSONObjectWithData:requestResult
                                                         options:0
                                                           error:nil];
        
        
        [self.SoapResults setString:@""];
        self.ElementFound = FALSE;
       
        
        if([self.MethodName isEqual:@"GetEmployeePayrollDetails"])
        {
            if (checkCount==1) {
                
                OLYDetailViewController *nextViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"HistoryDetails"];
                nextViewController.EmpName = self.EmpName;
                nextViewController.CompName = self.CompName;
                nextViewController.ClientAccountID = self.ClientAccountID;
                nextViewController.HistoryID = historyID;
                nextViewController.CheckDate =[NSString stringWithFormat:@"%@,%@", checkDateString, self.lblYear.text];
                nextViewController.HistoryData = requestedData;
                [self.navigationController pushViewController:nextViewController animated:YES];
            }
            else
            {
                  [self GetMultipleCheckList];
            }

        
        }
        else if ([self.MethodName isEqual:@"GetMultipleCheckList"])
        {
            [spinner stopAnimating];
            OLYCheckListPreviousPayroll *nextViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MultiplePreviousChecklists"];
            nextViewController.ClientAccountID = self.ClientAccountID;
            nextViewController.EmpID = self.EmpID;
            nextViewController.EmpName = self.EmpName;
            nextViewController.PickYear = self.PickYear;
            nextViewController.CheckDate = checkDate;
            nextViewController.CheckDateString = checkDateString;
            nextViewController.CompName = self.CompName;
            nextViewController.Checklists = requestedData;
           // nextViewController.IsCombined = isCombined;
            [self.navigationController pushViewController:nextViewController animated:YES];
            
        }
        else if ([self.MethodName isEqual:@"GetEmpCombinedPayroll"])
        {
            [spinner stopAnimating];
            OLYDetailViewController *nextViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"HistoryDetails"];
            nextViewController.EmpName = self.EmpName;
            nextViewController.CompName = self.CompName;
            nextViewController.ClientAccountID = self.ClientAccountID;
            nextViewController.HistoryID = historyID;
            nextViewController.CheckDate =[NSString stringWithFormat:@"%@,%@", checkDateString, self.lblYear.text];
            nextViewController.HistoryData = requestedData;
            [self.navigationController pushViewController:nextViewController animated:YES];
            
        }


    }
    
}



-(BOOL)IsCombined:(NSMutableDictionary *)requestedData{

    NSPredicate *filter =[NSPredicate predicateWithFormat:@"doubleValue == 0.0"];
    
    NSMutableArray* checkNumbers = [[requestedData valueForKey:@"History"] valueForKey:@"ChkNumber"];

    NSArray *zeroCheckNo = [checkNumbers filteredArrayUsingPredicate:filter];
  

    return ([zeroCheckNo count ] > 1) ? YES : NO;
}



-(void)FireRequest :(NSMutableURLRequest*)urlRequest
{
    
    
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.center = CGPointMake(160, 240);
    [self.view addSubview:spinner];
    [spinner startAnimating];
    
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
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    
}






@end
