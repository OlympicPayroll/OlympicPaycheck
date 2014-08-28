//
//  OLYCurrentPayrollViewController1.m
//  EemployeePayroll
//
//  Created by Reynante Sabud on 4/1/14.
//  Copyright (c) 2014 Reynante Sabud. All rights reserved.
//

#import "OLYCurrentPayrollViewControllerNet.h"
#import "OLYSoapMessages.h"



@interface OLYCurrentPayrollViewControllerNet ()
{
    
    NSMutableArray *earningsArray;
    //NSMutableArray *combinedChecks;
    NSArray *taxesArray;
    NSArray *deductionsArray;
    NSArray *reverseTipsArray;
    NSMutableArray *ddMessageArray;
    NSInteger combinedCheckCounts;
    
    
    
}
@end

@implementation OLYCurrentPayrollViewControllerNet




-(void) viewDidLoad
{
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    NSArray *monthYear = [self.PayDate componentsSeparatedByString: @","];
    
    //self.lblMonth.text = monthYear[0];
    //self.lblYear.text = monthYear[1];
    self.lblDate.text = [NSString stringWithFormat:@"Date: %@,%@", monthYear[0], monthYear[1]];//
    //self.lblEmpName.text = self.EmpName;
    //self.lblCompName.text = self.CompName;
    self.lblNetValue.text = self.NetValue;
    
    [self DisplayNetValue];
    
    
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    
    UILabel *typeLabel = (UILabel *)[cell viewWithTag:1010];
    UILabel *hoursLabel = (UILabel *)[cell viewWithTag:1020];
    UILabel *grossLabel = (UILabel *)[cell viewWithTag:1030];
    
    typeLabel.textColor =[UIColor colorWithRed:70/255.f green:70/255.f blue:70/255.f alpha:1.0f];
    hoursLabel.textColor =[UIColor colorWithRed:0.1491f green:0.6706f blue:0.8863f alpha:1.0f];
    grossLabel.textColor =[UIColor colorWithRed:5/255.f green:197/255.f blue:150/255.f alpha:1.0f];
    
    NSString *labelType, *labelGross, *labelHour, *dollarSign;
    
    
    switch (indexPath.section) {
        case 0:
            labelType=[[earningsArray objectAtIndex:indexPath.row] valueForKey:@"TYPE"] ;
            labelHour=[[earningsArray objectAtIndex:indexPath.row] valueForKey:@"HRS"] ;
            dollarSign =([labelHour isEqualToString:@"0.00"]) ? @"$":@"";
            labelGross=[NSString stringWithFormat:@"%@%@",dollarSign, [[earningsArray objectAtIndex:indexPath.row] valueForKey:@"CURRENT"]] ;
            
            if([labelType isEqualToString:@"RTIPS"])
            {
                labelType = @"CREDIT CARD TIPS";
            }
            
            if([labelHour isEqualToString:@"0.00"]) labelHour =@"";
            
            break;
            
        case 1:
            labelType=[[taxesArray objectAtIndex:indexPath.row] valueForKey:@"TYPE"] ;
            labelHour= @"";
            labelGross=[NSString stringWithFormat:@"$%@", [[taxesArray objectAtIndex:indexPath.row] valueForKey:@"CURRENT"]] ;
            break;
        case 2:
            labelType=[[deductionsArray objectAtIndex:indexPath.row] valueForKey:@"TYPE"] ;
            labelHour= @"";
            labelGross=[NSString stringWithFormat:@"$%@", [[deductionsArray objectAtIndex:indexPath.row] valueForKey:@"CURRENT"]] ;
            break;
        case 3:
            labelType=[[reverseTipsArray objectAtIndex:indexPath.row] valueForKey:@"TYPE"] ;
            labelHour= @"";
            labelGross=[NSString stringWithFormat:@"$%@", [[reverseTipsArray objectAtIndex:indexPath.row] valueForKey:@"CURRENT"]] ;
            break;
        case 4:
            labelType= [[ddMessageArray objectAtIndex:indexPath.row] valueForKey:@"TYPE"] ;
            labelHour= [[ddMessageArray objectAtIndex:indexPath.row] valueForKey:@"ACCT"] ;
            labelGross= [[ddMessageArray objectAtIndex:indexPath.row] valueForKey:@"AMOUNT"] ;
            break;
        default:
            break;
    }
    
    
    
    typeLabel.text = labelType;
    hoursLabel.text =labelHour;
    grossLabel.text = labelGross;
    
    
    return cell;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger retVal=0;
    
    switch (section) {
        case 0:
            retVal =[earningsArray count] ;
            break;
            
        case 1:
            retVal =[taxesArray count];
            break;
        case 2:
            retVal =[deductionsArray count];
            break;
        case 3:
            retVal =[reverseTipsArray count];
            break;
        case 4:
            retVal =[ddMessageArray count];//
        default:
            break;
    }
    
    return retVal;
    
}




- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    // NSString *retVal;
    NSString *sectionName, *earningHeader;
    int spaceCount;
    
    switch (section)
    {
        case 0:
            earningHeader= (combinedCheckCounts > 0) ? @"HOURS@RATE" : @"HOURS";
            spaceCount =  (combinedCheckCounts > 0) ? 6 : 18;
            sectionName =[NSString stringWithFormat:@"%@%@%@%@%@"
                          ,@"EARNINGS"
                          ,[@"" stringByPaddingToLength:spaceCount withString:@" " startingAtIndex:0]
                          ,earningHeader
                          ,[@"" stringByPaddingToLength:6 withString:@" " startingAtIndex:0]
                          ,@"CURRENT"
                          ];
            
            break;
            
            
            
        case 1:
            sectionName =[NSString stringWithFormat:@"%@%@%@"
                          ,@"TAXES"
                          ,[@"" stringByPaddingToLength:43 withString:@" " startingAtIndex:0]
                          ,@"CURRENT"
                          ];
            break;
        case 2:
            if([deductionsArray count] > 0)
                sectionName = @"MISC DEDUCTIONS";
            break;
        case 3:
            if([reverseTipsArray count] > 0)
                sectionName = @"REVERSE TIPS";
            break;
        case 4:
            sectionName = @"DIRECT DEPOSIT";
            break;
        default:
            sectionName = @"";
            break;
    }
    return sectionName;
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger retVal=0;
    
    if([earningsArray count] > 0)
        retVal++;
    
    if([taxesArray count] > 0)
        retVal++;
    
    if([deductionsArray count] > 0)
        retVal++;
    
    if([reverseTipsArray count] > 0)
        retVal++;
    
    if([ddMessageArray count] > 1)
        retVal++;
    retVal++;
    
    
    
    return retVal;
}


//================================
#pragma mark - Private Methods
//=================================


-(void)DisplayNetValue
{
    
    id  payrollDetailsDict=[[self.EmailDetails objectForKey:@"Details"] objectAtIndex:self.RecordNumber];
    
    NSString *checkNo = [payrollDetailsDict valueForKey:@"CheckNo"];
    self.lblCheckNo.text = [NSString stringWithFormat:@"Check No. %@", checkNo];
    
    NSMutableArray* earningRequest = [payrollDetailsDict valueForKey:@"Earnings"];
    NSMutableArray* taxesRequest = [payrollDetailsDict valueForKey:@"Taxes"];
    NSMutableArray* deductionsRequest = [payrollDetailsDict valueForKey:@"Deductions"];
    NSMutableArray* reverseTipsRequest = [payrollDetailsDict valueForKey:@"ReverseTips"];
    NSString* directDepositRequest = [payrollDetailsDict valueForKey:@"Messages"];
    
    
    
    NSPredicate *filter = [NSPredicate predicateWithFormat:@"(CURRENT != '' AND CURRENT != '0.00')"];
    
    
    if(![taxesRequest isEqual:[NSNull null]])
    {
        taxesArray = [taxesRequest filteredArrayUsingPredicate:filter];
    }
    
    
    if(![deductionsRequest  isEqual:[NSNull null]])
    {
        deductionsArray = [deductionsRequest filteredArrayUsingPredicate:filter];
    }
    
    if(![reverseTipsRequest  isEqual:[NSNull null]])
    {
        reverseTipsArray = [reverseTipsRequest filteredArrayUsingPredicate:filter];
    }
    
    if ([directDepositRequest length] > 0)
    {
        directDepositRequest = [directDepositRequest substringToIndex:[directDepositRequest length] - 2];
        NSArray *xMessageArray = [[directDepositRequest componentsSeparatedByString: @"@!"] mutableCopy];
        
        NSMutableDictionary *mutDic;
        ddMessageArray =[NSMutableArray new];
        
        if ([xMessageArray count] > 1) {
            
        for (int i = 0; i < xMessageArray.count; i++)
        {
            mutDic =[NSMutableDictionary new];
            float money = [[[xMessageArray objectAtIndex:i] substringFromIndex:6] floatValue];
            
            if ( [[[xMessageArray objectAtIndex:i] substringToIndex:6] isEqual:@"DIRCH$"])
            {
                
                [mutDic setValue:@"CHECKING" forKey:@"TYPE"];
                [mutDic setValue:@"" forKey:@"ACCT"];
                [mutDic setValue:[NSString stringWithFormat:@"$%.02f", money] forKey:@"AMOUNT"];
                
                
            }else if ( [[[xMessageArray objectAtIndex:i] substringToIndex:6] isEqual:@"DIRSV$"])
            {
                
                [mutDic setValue:@"SAVINGS" forKey:@"TYPE"];
                [mutDic setValue:@"" forKey:@"ACCT"];
                [mutDic setValue:[NSString stringWithFormat:@"$%.02f", money] forKey:@"AMOUNT"];
                
                
            }else if ( [[[xMessageArray objectAtIndex:i] substringToIndex:6] isEqual:@"DIRCHx"])
            {
                
                [mutDic setValue:@"CHECKING" forKey:@"TYPE"];
                [mutDic setValue:[[xMessageArray objectAtIndex:i] substringWithRange:NSMakeRange(5,4)] forKey:@"ACCT"];
                [mutDic setValue:[NSString stringWithFormat:@"$%.02f", money] forKey:@"AMOUNT"];
                
                
            }else
            {
                
                [mutDic setValue:@"SAVINGS" forKey:@"TYPE"];
                [mutDic setValue:[[xMessageArray objectAtIndex:i] substringWithRange:NSMakeRange(5,4)] forKey:@"ACCT"];
                [mutDic setValue:[NSString stringWithFormat:@"$%.02f", money] forKey:@"AMOUNT"];
                
            }
            
            [ddMessageArray addObject:mutDic];
            
          }
        
        }
        
        
    }
    
    
    
    //NSString *desc, *hours, *rate;
    NSString  *hoursRate;
    
    earningsArray = [NSMutableArray new];
    NSMutableDictionary *mutDic;
    
    NSPredicate *filterCombined = [NSPredicate predicateWithFormat:@"(TYPE == '' AND HRS != '')"];
    
    NSArray *combinedChecks = [earningRequest filteredArrayUsingPredicate:filterCombined];
    combinedCheckCounts =[combinedChecks count];
    
    if(combinedCheckCounts > 0){
        
        int counter=0;
        for (NSDictionary * dict in combinedChecks) {
            counter++;
            mutDic=[NSMutableDictionary new];
            
            hoursRate = [NSString stringWithFormat:@"%@ @ $%@", [dict valueForKey:@"HRS"], [dict valueForKey:@"RATE"]];
            
            [mutDic setValue:[NSString stringWithFormat:@"REG%d", counter] forKey:@"TYPE"];
            [mutDic setValue:hoursRate forKey:@"HRS"];
            [mutDic setValue:[dict valueForKey:@"CURRENT"] forKey:@"CURRENT"];
            
            [earningsArray addObject:mutDic];
        }
    }
    
    
    NSPredicate *filterEarnings = [NSPredicate predicateWithFormat:@"(TYPE != '' AND CURRENT != '0.00')"];
    NSArray *earnings = [earningRequest filteredArrayUsingPredicate:filterEarnings];
    
    for (NSDictionary * dict in earnings) {
        
        if([[dict valueForKey:@"TYPE"] isEqualToString:@"REG" ] && combinedCheckCounts > 0) continue;
        
        mutDic=[NSMutableDictionary new];
        [mutDic setValue:[dict valueForKey:@"TYPE"] forKey:@"TYPE"];
        [mutDic setValue:[dict valueForKey:@"HRS"] forKey:@"HRS"];
        [mutDic setValue:[dict valueForKey:@"CURRENT"] forKey:@"CURRENT"];
        
        [earningsArray addObject:dict];
        
    }
    
    
}









@end
