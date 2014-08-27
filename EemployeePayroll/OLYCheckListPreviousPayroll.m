//
//  OLYCheckListPreviousPayroll.m
//  EemployeePayroll
//
//  Created by Reynante Sabud on 5/6/14.
//  Copyright (c) 2014 Reynante Sabud. All rights reserved.
//

#import "OLYCheckListPreviousPayroll.h"
#import "OLYDetailViewController.h"
#import "OLYSoapMessages.h"


@interface OLYCheckListPreviousPayroll ()
{
    int tapCount;
    NSString *historyID;
    NSMutableDictionary *checklists;
    UIActivityIndicatorView *spinner;
}

@end

@implementation OLYCheckListPreviousPayroll


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    //self.title = self.IsCombined ? @"Combined Checks" : @"Multiple Checks";
    //if(!self.IsCombined)self.lblHours.text =@"";
    
    self.lblMonth.text = self.CheckDateString;
    self.lblYear.text = self.PickYear;
    
    
    self.navigationController.navigationBar.hidden = NO;
    self.lblName.text = [NSString stringWithFormat:@"%@",self.EmpName ];
    self.lblCompName.text = self.CompName;
    
    //checkData = [NSMutableArray new];
     checklists = [self.Checklists objectForKey:@"History"];

    
}

-(void)viewWillAppear:(BOOL)animated{
    
    tapCount=0;
}


- (void)viewDidAppear:(BOOL)animated {
    /*
    if(self.IsCombined)
    {
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView selectRowAtIndexPath:indexPath animated:YES  scrollPosition:UITableViewScrollPositionBottom];
    }
     */
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(tapCount==0){
        tapCount++;
      historyID =[[checklists valueForKey: @"HistoryDetailsID"] objectAtIndex:indexPath.row];
     [self GetEmployeePayrollDetails];
    }
 }




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    UILabel *lblCheckNo = (UILabel *)[cell viewWithTag:1010];
    UILabel *lblHours = (UILabel *)[cell viewWithTag:1020];
    UILabel *lblNet = (UILabel *)[cell viewWithTag:1030];
   
    lblHours.textColor =[UIColor colorWithRed:0.1491f green:0.6706f blue:0.8863f alpha:1.0f];
    lblNet.textColor =[UIColor colorWithRed:5/255.f green:197/255.f blue:150/255.f alpha:1.0f];
    
    
    NSString *checkNo, *hours, *net;

    checkNo =[[checklists valueForKey: @"ChkNumber"] objectAtIndex:indexPath.row];
    
    net =[[checklists valueForKey: @"NetPay"] objectAtIndex:indexPath.row];
    
    /*
    if (self.IsCombined) {
   
        if([checkNo intValue] == 0)
        {
            checkNo =[NSString stringWithFormat:@"%ld)",indexPath.row + 1];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.userInteractionEnabled = NO;
        }
        else
        {
            checkNo =[NSString stringWithFormat:@"%ld)  #%@",indexPath.row + 1, checkNo];
        }
        
        hours =[[checklists valueForKey: @"HS_RegHrs"] objectAtIndex:indexPath.row];
        
        if([hours intValue] == 0) hours=@"";
        
        net = ([net intValue] == 0)? net=@"" : [NSString stringWithFormat:@"$%@", net];
    }
     
    else
    {
     */
       checkNo =[NSString stringWithFormat:@"%ld)  #%@",indexPath.row + 1, checkNo];
       hours =@"";
       net = [NSString stringWithFormat:@"$%@", net];

    
    lblCheckNo.text = checkNo;
    lblHours.text = hours;
    lblNet.text = net;
    /*
    cell.textLabel.text = lblCheckNo;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"$%@", [[checklists valueForKey: @"NetPay"] objectAtIndex:indexPath.row]];
    
    cell.textLabel.textColor=[UIColor blackColor];
    cell.detailTextLabel.textColor= [UIColor colorWithRed:5/255.f green:197/255.f blue:150/255.f alpha:1.0f];
    cell.detailTextLabel.font =[UIFont boldSystemFontOfSize:17];
     */
    return cell;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
   
    return [checklists count];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


-(void)ParseMultipleChecks{
    
    OLYSoapMessages *objSoapMsg =[OLYSoapMessages new];
    
    self.MethodName = @"GetMultipleChecks";
    
    [objSoapMsg GetMultipleCheckListEmpID:self.EmpID CheckDate:self.CheckDate MethodName:self.MethodName];
    
    [self FireRequest: objSoapMsg.UrlRequest];

    
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







-(void)GetEmployeePayrollDetails
{
    
    OLYSoapMessages *objSoapMsg =[OLYSoapMessages new];
    
    self.MethodName = @"GetEmployeePayrollDetails";
    
    [objSoapMsg GetPayrollDetails:self.ClientAccountID HistoryID:historyID MethodName:self.MethodName];
    
    //Fire away.
     [self FireRequest: objSoapMsg.UrlRequest];
    
}





//==================================
#pragma mark - Request Methods.
//==================================
//---when the end of element is found---
-(void)parser:(NSXMLParser *)parser
didEndElement:(NSString *)elementName
 namespaceURI:(NSString *)namespaceURI
qualifiedName:(NSString *)qName
{
    
    if ([elementName isEqualToString:[NSString stringWithFormat:@"%@Result", self.MethodName]])
    {
        
        
        NSData *requestResult = [self.SoapResults dataUsingEncoding:NSUTF8StringEncoding];
        
        NSMutableDictionary *requestedData = [NSJSONSerialization
                                              JSONObjectWithData:requestResult
                                              options:0
                                              error:nil];
        
        
        [self.SoapResults setString:@""];
        self.ElementFound = FALSE;
        
        
        if([self.MethodName isEqual:@"GetEmployeePayrollDetails"])
        {
                [spinner stopAnimating];
                OLYDetailViewController *nextViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"HistoryDetails"];
                nextViewController.EmpName = self.EmpName;
                nextViewController.CompName = self.CompName;
                nextViewController.ClientAccountID = self.ClientAccountID;
                nextViewController.HistoryID = historyID;
                nextViewController.CheckDate =[NSString stringWithFormat:@"%@,%@", self.CheckDateString, self.PickYear];
                nextViewController.HistoryData = requestedData;
                [self.navigationController pushViewController:nextViewController animated:YES];
        }
        
        
    }
}









@end
