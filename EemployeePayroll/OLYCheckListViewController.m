//
//  OLYCheckListViewController.m
//  EemployeePayroll
//
//  Created by Reynante Sabud on 4/24/14.
//  Copyright (c) 2014 Reynante Sabud. All rights reserved.
//

#import "OLYCheckListViewController.h"
#import "OLYCurrentPayrollMainViewController.h"
#import "OLYSoapMessages.h"

@interface OLYCheckListViewController ()
{
    int tapCount;
    NSMutableArray *checkData;
    
    NSMutableArray *earningsArray;
    NSMutableArray *taxesArray;
    NSMutableArray *deductionsArray;
    NSMutableArray *reverseTipsArray;
   
}

@end

@implementation OLYCheckListViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.title =@"Latest Payrolls";
    
    NSArray *monthYear = [self.PayDate componentsSeparatedByString: @","];
    
    self.lblMonth.text = monthYear[0];
    self.lblYear.text = monthYear[1];
   
    
    self.navigationController.navigationBar.hidden = NO;
    self.lblName.text = [NSString stringWithFormat:@"%@",self.EmpName ];
    self.lblCompName.text = self.CompName;
    
    checkData = [NSMutableArray new];
    [self ParseEmailDetails];
 
 
}

-(void)viewWillAppear:(BOOL)animated{
    tapCount=0;
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if(tapCount !=0) return;
    
        tapCount++;
        OLYCurrentPayrollMainViewController * nextViewController =[self.storyboard instantiateViewControllerWithIdentifier:@"CurrentPayrollMainDetails"];
        nextViewController.EmailDetails = self.EmailDetails;
        nextViewController.RecordNumber = indexPath.row;
        nextViewController.EmpName = self.EmpName;
        nextViewController.CompName = self.CompName;
        nextViewController.PayDate = self.PayDate;
        [self.navigationController pushViewController:nextViewController animated:YES];
   
  }




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    UILabel *lblCheckNo = (UILabel *)[cell viewWithTag:1010];
    UILabel *lblHoursRate = (UILabel *)[cell viewWithTag:1020];
    UILabel *lblNet = (UILabel *)[cell viewWithTag:1030];
    
   // lblHoursRate.textColor =[UIColor colorWithRed:0.1491f green:0.6706f blue:0.8863f alpha:1.0f];
    lblNet.textColor =[UIColor colorWithRed:5/255.f green:197/255.f blue:150/255.f alpha:1.0f];
    lblNet.font =[UIFont boldSystemFontOfSize:17];
    
    
    NSString *checkNo =[[checkData objectAtIndex:indexPath.row] objectForKey: @"CheckNo"];
   // NSString *hours =[[checkData objectAtIndex:indexPath.row] objectForKey: @"Hours"];
   // NSString *rate =[[checkData objectAtIndex:indexPath.row] objectForKey: @"Rate"];
    
    lblCheckNo.text = [NSString stringWithFormat:@"%ld)  #%@",indexPath.row + 1, checkNo];
    lblHoursRate.text =@"";
    lblNet.text = [[checkData objectAtIndex:indexPath.row] objectForKey: @"NetTotal"];
    
     
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [checkData count];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//================================
#pragma mark - Private Methods
//=================================

-(void)ParseEmailDetails 
{

    NSString *checkNumber, *hours, *rate;
    NSNumberFormatter *formatter;
    double totalEarningGross=0.00;
    double totalTaxes=0.00;
    double totalDeductions=0.00;
    double totslReversTips =0.00;
    double netTotal =0.00;
    
    
    for (int recNo= 0; recNo < self.RecordNumber; recNo++) {
        
    
        id  payrollDetailsDict=[[self.EmailDetails objectForKey:@"Details"] objectAtIndex:recNo];
   
        checkNumber =[payrollDetailsDict valueForKey:@"CheckNo"];
        hours =[[[payrollDetailsDict objectForKey:@"Earnings"] valueForKey:@"HRS"] objectAtIndex:0];
        rate =[[[payrollDetailsDict objectForKey:@"Earnings"] valueForKey:@"RATE"] objectAtIndex:0];
        
        
        earningsArray = [payrollDetailsDict valueForKey:@"Earnings"];
        taxesArray = [payrollDetailsDict valueForKey:@"Taxes"];
        deductionsArray = [payrollDetailsDict valueForKey:@"Deductions"];
        reverseTipsArray = [payrollDetailsDict valueForKey:@"ReverseTips"];
    
      
        totalEarningGross=0.00;
        totalTaxes=0.00;
        totalDeductions=0.00;
        totslReversTips =0.00;
   
    
    
        for (int i=0; i<[earningsArray count]; i++) {
            totalEarningGross += [[[earningsArray valueForKey:@"CURRENT"] objectAtIndex:i] doubleValue];
        }
    
        for (int i=0; i<[taxesArray count]; i++) {
            totalTaxes += [[[taxesArray valueForKey:@"CURRENT"] objectAtIndex:i] doubleValue];
        }
    
        for (int i=0; i<[deductionsArray count]; i++) {
            totalDeductions += [[[deductionsArray valueForKey:@"CURRENT"] objectAtIndex:i] doubleValue];
        }
   
        for (int i=0; i<[reverseTipsArray count]; i++) {
            totslReversTips += [[[reverseTipsArray valueForKey:@"CURRENT"] objectAtIndex:i] doubleValue];
        }
        
        netTotal = totalEarningGross + totslReversTips - totalTaxes - totalDeductions;
        
 

    
        formatter = [NSNumberFormatter new];
        [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    
        NSString *formatted = [formatter stringFromNumber:[NSNumber numberWithDouble:netTotal]];
    
      

        NSMutableDictionary *mutDic=[[NSMutableDictionary alloc] init];
        [mutDic setValue:checkNumber forKey:@"CheckNo"];
        [mutDic setValue:hours forKey:@"Hours"];
        [mutDic setValue:rate forKey:@"Rate"];
        [mutDic setValue:formatted forKey:@"NetTotal"];
        
        [checkData addObject:mutDic];

    }
    
}

@end
















