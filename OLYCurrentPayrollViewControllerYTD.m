//
//  OLYCurrentPayrollYTD.m
//  EemployeePayroll
//
//  Created by Reynante Sabud on 4/8/14.
//  Copyright (c) 2014 Reynante Sabud. All rights reserved.
//

#import "OLYCurrentPayrollViewControllerYTD.h"

@interface OLYCurrentPayrollViewControllerYTD ()
{
    
   NSDictionary* earningRequestDict;
   NSDictionary* taxesRequestDict;
   NSDictionary* deductionsRequestDict;
   NSMutableArray *earningsArray;
   NSDictionary *reverseTipsRequestDict;
   
}

@end


@implementation OLYCurrentPayrollViewControllerYTD


-(void) viewDidLoad
{
    
    [super viewDidLoad];
    self.lblEmpName.text = self.EmpName;
    self.lblCompName.text = self.CompName;
    [self ParseEmailDetails];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
  
  
    NSString * lblType, *lblCurrent;
    switch (indexPath.section) {
        case 0:
            lblType=[[earningsArray objectAtIndex:indexPath.row] valueForKey:@"TYPE"] ;
            lblCurrent=[[earningsArray objectAtIndex:indexPath.row] valueForKey:@"YTD"] ;

            break;
        case 1:
            lblType=[NSString stringWithFormat:@"%@", [[taxesRequestDict valueForKey:@"TYPE"] objectAtIndex:indexPath.row]];
            lblCurrent = [NSString stringWithFormat:@"$ %@", [[taxesRequestDict valueForKey:@"YTD"] objectAtIndex:indexPath.row]];
            break;
        case 2:
            lblType=[NSString stringWithFormat:@"%@", [[deductionsRequestDict valueForKey:@"TYPE"] objectAtIndex:indexPath.row]];
            lblCurrent = [NSString stringWithFormat:@"$ %@", [[deductionsRequestDict valueForKey:@"YTD"] objectAtIndex:indexPath.row]];
            break;
        case 3:
            lblType=[NSString stringWithFormat:@"%@", [[reverseTipsRequestDict valueForKey:@"TYPE"] objectAtIndex:indexPath.row]];
            lblCurrent = [NSString stringWithFormat:@"$ %@", [[reverseTipsRequestDict valueForKey:@"YTD"] objectAtIndex:indexPath.row]];
            break;
        default:
            break;
    }

    
    
    cell.textLabel.text =lblType;
    cell.detailTextLabel.text = lblCurrent;
    
    cell.textLabel.textColor=[UIColor blackColor];
    cell.detailTextLabel.textColor=[UIColor colorWithRed:5/255.f green:197/255.f blue:150/255.f alpha:1.0f];
    
    
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
            retVal =[taxesRequestDict count];
            break;
            
        case 2:
            retVal =[deductionsRequestDict count];
            break;
        case 3:
            retVal =[reverseTipsRequestDict count];
            break;
            
        default:
            break;
    }
    
    return retVal;
    
}



- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{

    NSString *sectionName;
    switch (section)
    {
        case 0:
            sectionName =[NSString stringWithFormat:@"%@%@%@"
                          ,@"EARNINGS"
                          ,[@"" stringByPaddingToLength:25 withString:@" " startingAtIndex:0]
                          ,@"YEAR TO DATE"
                          ];
            break;
        case 1:
            sectionName =@"TAXES";
            
            break;

        case 2:
            sectionName = @"DEDUCTIONS";
            break;
        case 3:
          if([reverseTipsRequestDict count] > 0)
            sectionName = @"REVERSE TIPS";
            break;
            // ...
        default:
            sectionName = @"";
            break;
    }
    return sectionName;
    
    
    
    return sectionName;
}




-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger retVal=0;
    
    if([earningRequestDict count] > 0)
        retVal++;
    
    if([taxesRequestDict count] > 0)
        retVal++;
    
    if([deductionsRequestDict count] > 0)
        retVal++;
    
    if([deductionsRequestDict count] > 0)
        retVal++;
    
    if([reverseTipsRequestDict count] > 0)
        retVal++;
    
    return retVal;

}


//================================
#pragma mark - Private Methods
//=================================

-(void)ParseEmailDetails
{

   id  payrollDetailsDict=[[self.EmailDetails objectForKey:@"Details"] objectAtIndex:self.RecordNumber];
  
    earningRequestDict = [payrollDetailsDict valueForKey:@"Earnings"];
    taxesRequestDict = [payrollDetailsDict valueForKey:@"Taxes"];
    deductionsRequestDict=[payrollDetailsDict valueForKey:@"Deductions"];
    reverseTipsRequestDict = [payrollDetailsDict valueForKey:@"ReverseTips"];
  
    NSNumberFormatter *formatter = [NSNumberFormatter new];
   [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];

    NSNumber *nGross;
    double gross;
    NSString *earnType;
    NSMutableDictionary *earningsDetails;
    
    earningsArray =[NSMutableArray new];
    for (NSDictionary *key in earningRequestDict) {
        
        gross = [[key valueForKey:@"YTD" ] doubleValue];
        
        if( gross <= 0)
            continue;
        
        earnType =[NSString stringWithFormat:@"%@", [[key valueForKey:@"TYPE" ] uppercaseString]];
        
       if([earnType isEqualToString:@""])
           continue;
        
        if([earnType isEqualToString:@"RTIPS"])
            earnType =@"CREDIT CARD TIPS";
        
        nGross = [NSNumber numberWithFloat:(gross)];
        earningsDetails =[NSMutableDictionary dictionary];
        earningsDetails[@"TYPE"] = earnType;
        earningsDetails[@"YTD"] =  [formatter stringFromNumber:nGross];;
        [ earningsArray addObject:earningsDetails];
        
    }
}




@end










