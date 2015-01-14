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
    
    NSMutableArray *sectionIdentifier;
    
}
@end

@implementation OLYCurrentPayrollViewControllerNet




-(void) viewDidLoad
{
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    NSArray *monthYear = [self.PayDate componentsSeparatedByString: @","];
    
     self.lblDate.text = [NSString stringWithFormat:@"Date: %@,%@", monthYear[0], monthYear[1]];//
    self.lblNetValue.text = self.NetValue;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
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
    
   NSString *sectionName = [sectionIdentifier objectAtIndex:indexPath.section];
    
    if([sectionName isEqual:@"EARNINGS"])
    {
        labelType=[[earningsArray objectAtIndex:indexPath.row] valueForKey:@"TYPE"] ;
        labelHour=[[earningsArray objectAtIndex:indexPath.row] valueForKey:@"HRS"] ;
        dollarSign =([labelHour isEqualToString:@"0.00"]) ? @"$":@"";
        labelGross=[NSString stringWithFormat:@"%@%@",dollarSign, [[earningsArray objectAtIndex:indexPath.row] valueForKey:@"CURRENT"]] ;
        
        if([labelType isEqualToString:@"RTIPS"])
        {
            labelType = @"CREDIT CARD TIPS";
        }
        
        if([labelHour isEqualToString:@"0.00"]) labelHour =@"";
    }
    else if([sectionName isEqual:@"DEDUCTIONS"])
    {
        labelType=[[deductionsArray objectAtIndex:indexPath.row] valueForKey:@"TYPE"] ;
        labelHour= @"";
        labelGross=[NSString stringWithFormat:@"$%@", [[deductionsArray objectAtIndex:indexPath.row] valueForKey:@"CURRENT"]] ;
        
    }
    else if([sectionName isEqual:@"TAXES"])
    {
        labelType=[[taxesArray objectAtIndex:indexPath.row] valueForKey:@"TYPE"] ;
        labelHour= @"";
        labelGross=[NSString stringWithFormat:@"$%@", [[taxesArray objectAtIndex:indexPath.row] valueForKey:@"CURRENT"]] ;
        
    }
    else if([sectionName isEqual:@"TIPS"])
    {
        labelType=[[reverseTipsArray objectAtIndex:indexPath.row] valueForKey:@"TYPE"] ;
        labelHour= @"";
        labelGross=[NSString stringWithFormat:@"$%@", [[reverseTipsArray objectAtIndex:indexPath.row] valueForKey:@"CURRENT"]] ;
        
        
    }
    else if([sectionName isEqual:@"MESSAGES"])
    {
        labelType= [[ddMessageArray objectAtIndex:indexPath.row] valueForKey:@"TYPE"] ;
        labelHour= [[ddMessageArray objectAtIndex:indexPath.row] valueForKey:@"ACCT"] ;
        labelGross= [[ddMessageArray objectAtIndex:indexPath.row] valueForKey:@"AMOUNT"] ;
        
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
            retVal =[self CreateNumberOfSections:section] ;
            break;
            
        case 1:
             retVal =[self CreateNumberOfSections:section] ;
            break;
        case 2:
             retVal =[self CreateNumberOfSections:section] ;
            break;
        case 3:
             retVal =[self CreateNumberOfSections:section] ;
            break;
        case 4:
             retVal =[self CreateNumberOfSections:section] ;
        default:
            break;
    }
    
    return retVal;
    
}





-(NSInteger)CreateNumberOfSections :(NSInteger) section
{
    NSInteger retVal=0;
    
    NSString *sectionOwner;
    
 
            sectionOwner =[sectionIdentifier objectAtIndex:section];
            
            if([sectionOwner isEqual:@"EARNINGS"])
            {
                retVal =[earningsArray count] ;
            }
            else if([sectionOwner isEqual:@"DEDUCTIONS"])
            {
                retVal =[deductionsArray count];
            }
            else if([sectionOwner isEqual:@"TAXES"])
            {
                retVal =[taxesArray count];
            }
            else if([sectionOwner isEqual:@"TIPS"])
            {
                retVal =[reverseTipsArray count];
            }
            else if([sectionOwner isEqual:@"MESSAGES"])
            {
                retVal =[ddMessageArray count];//
            }
   
    return retVal;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
   
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
    /* Create custom view to display section header... */
   
    UILabel *col1label;
    [col1label setFont:[UIFont systemFontOfSize:15]];
   
    NSString *sectionName = [sectionIdentifier objectAtIndex:section];

    
    if([sectionName isEqual:@"EARNINGS"])
    {
        
        float labelWidth = (tableView.frame.size.width - 20) / 3;
        
        float xAxis = 10;
        col1label = [[UILabel alloc] initWithFrame:CGRectMake(xAxis, 5, labelWidth, 18)];
        col1label.text = @"EARNINGS";
        
        xAxis += (tableView.frame.size.width / 2) - (labelWidth / 2);
        UILabel *col2label = [[UILabel alloc] initWithFrame:CGRectMake(xAxis, 5, labelWidth, 18)];
        [col2label setFont:[UIFont systemFontOfSize:15]];
        col2label.text = (combinedCheckCounts > 0) ? @"HOURS@RATE" : @"HOURS";
        col2label.textAlignment = NSTextAlignmentRight;
        
        xAxis = tableView.frame.size.width - labelWidth - 2;
        UILabel *col3label = [[UILabel alloc] initWithFrame:CGRectMake(xAxis, 5, labelWidth, 18)];
        [col3label setFont:[UIFont systemFontOfSize:15]];
        col3label.text = @"CURRENT";
        col3label.textAlignment = NSTextAlignmentRight;
        
        [view addSubview:col1label];
        [view addSubview:col2label];
        [view addSubview:col3label];
        
    }
    else if([sectionName isEqual:@"DEDUCTIONS"])
    {
       
         col1label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.frame.size.width, 18)];
         col1label.text = (deductionsArray > 0) ? @"MISC DEDUCTIONS" : @"";
         [view addSubview:col1label];
        
    }
    else if([sectionName isEqual:@"TAXES"])
    {
       
        float labelWidth = (tableView.frame.size.width - 20) / 3;
        
        float xAxis = 10;
        col1label = [[UILabel alloc] initWithFrame:CGRectMake(xAxis, 5, labelWidth, 18)];
        col1label.text = @"TAXES";
        
        xAxis = tableView.frame.size.width - labelWidth - 5;
        UILabel *col2label = [[UILabel alloc] initWithFrame:CGRectMake(xAxis, 5, labelWidth, 18)];
        [col2label setFont:[UIFont systemFontOfSize:15]];
        col2label.text = @"CURRENT";
        col2label.textAlignment = NSTextAlignmentRight;


        [view addSubview:col1label];
        [view addSubview:col2label];
        
    }
    else if([sectionName isEqual:@"TIPS"])
    {
        
        col1label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.frame.size.width, 18)];
        col1label.text = (reverseTipsArray > 0) ? @"REVERSE TIPS" : @"";
        [view addSubview:col1label];
        
    }
    else if([sectionName isEqual:@"MESSAGES"])
    {
        
        col1label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.frame.size.width, 18)];
        col1label.text = @"DIRECT DEPOSIT";
        [view addSubview:col1label];
        
    }

    

    [view setBackgroundColor:[UIColor groupTableViewBackgroundColor]]; //your background color...
    return view;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.0;
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    int retVal=0;
    
     sectionIdentifier = [NSMutableArray new];

   //NSMutableArray *x =[NSMutableArray new];
    
    if([earningsArray count] > 0)
    {
        [sectionIdentifier addObject:@"EARNINGS"];
             retVal++;
    }
    
    if([taxesArray count] > 0)
    {

         [sectionIdentifier addObject:@"TAXES"];
        
        retVal++;
    }
    
    if([deductionsArray count] > 0)
    {
         [sectionIdentifier addObject:@"DEDUCTIONS"];
        retVal++;
    }
    
    
    if([reverseTipsArray count] > 0)
    {
        [sectionIdentifier addObject:@"TIPS"];
        retVal++;
    }
    
    if([ddMessageArray count] > 0)
    {
        [sectionIdentifier addObject:@"MESSAGES"];
        retVal++;
    }
    
   
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
    
    
    NSString *accountType;
    
    if ([directDepositRequest length] > 6)
    {
        NSArray *splitMessageArray = [[directDepositRequest componentsSeparatedByString: @"@!"] mutableCopy];
        
        NSMutableDictionary *mutDic;
        ddMessageArray =[NSMutableArray new];
        NSArray *accountMoney;

        
        if ([splitMessageArray count] > 1) {
            
            for (int i = 0; i < splitMessageArray.count; i++)
            {
                
                if([[splitMessageArray objectAtIndex:i] length] ==0 )
                    continue;
                
                if([[splitMessageArray objectAtIndex:i] length] < 6 )
                    continue;
                    
             
                accountType= [[splitMessageArray objectAtIndex:i] uppercaseString];
                accountMoney = [accountType componentsSeparatedByString:@"$"];
                
                if([accountMoney count] <1)
                    continue;
                
                float money = [accountMoney[1] floatValue];
                

                 mutDic =[NSMutableDictionary new];
                
                if ( [accountType hasPrefix:@"DIRCH$"])
                {
                
                    [mutDic setValue:@"CHECKING" forKey:@"TYPE"];
                    [mutDic setValue:@"" forKey:@"ACCT"];
                    [mutDic setValue:[NSString stringWithFormat:@"$%.02f", money] forKey:@"AMOUNT"];
                
                
                }else if ([accountType hasPrefix:@"DIRSV$"])
                {
                
                    [mutDic setValue:@"SAVINGS" forKey:@"TYPE"];
                    [mutDic setValue:@"" forKey:@"ACCT"];
                    [mutDic setValue:[NSString stringWithFormat:@"$%.02f", money] forKey:@"AMOUNT"];
                
                
                }else if ( [accountType hasPrefix:@"DIRCHX"])
                {
                    
                    [mutDic setValue:@"CHECKING" forKey:@"TYPE"];
                    [mutDic setValue:[[accountType substringWithRange:NSMakeRange(5,4)] lowercaseString] forKey:@"ACCT"];
                    [mutDic setValue:[NSString stringWithFormat:@"$%.02f", money] forKey:@"AMOUNT"];
                
                
                }else if( [accountType hasPrefix:@"DIRSVX"])
                {
                
                    [mutDic setValue:@"SAVINGS" forKey:@"TYPE"];
                    [mutDic setValue:[[accountType substringWithRange:NSMakeRange(5,4)] lowercaseString] forKey:@"ACCT"];
                    [mutDic setValue:[NSString stringWithFormat:@"$%.02f", money] forKey:@"AMOUNT"];
                
                }
            
                [ddMessageArray addObject:mutDic];
            
            }
        
        }
        
        
    }
    
    
    
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
