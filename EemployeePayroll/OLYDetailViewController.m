//
//  OLYDetailViewController.m
//  EemployeePayroll
//
//  Created by Reynante Sabud on 7/31/13.
//  Copyright (c) 2013 Reynante Sabud. All rights reserved.
//

#import "OLYDetailViewController.h"

@interface OLYDetailViewController ()
{

    NSArray *earnings;
    NSArray *taxes;
    NSArray *deductions;


}
@end

@implementation OLYDetailViewController


-(id) initWithCoder:(NSCoder *)aDecoder
{
    self =[super initWithCoder:aDecoder];
    
    if(self)
    {
    

    }
    return self;
}


/*
-(void)viewDidAppear:(BOOL)animated{
       [super viewDidAppear:animated];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
*/

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    NSArray *monthYear = [self.CheckDate componentsSeparatedByString: @","];
    
    //self.lblMonth.text = monthYear[0];
    //self.lblYear.text = monthYear[1];
    self.lblDate.text = [NSString stringWithFormat:@"Date: %@, %@", monthYear[0], monthYear[1]];//
    NSString *checkNo = [self.HistoryData valueForKey:@"CHECKNO"] ;
    self.lblCheckNo.text = [NSString stringWithFormat:@"Check No. %@", checkNo];
    //self.lblEmpName.text = self.EmpName;
    //self.lblCompName.text = self.CompName;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self displayTableView];
    
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    UILabel *typeLabel = (UILabel *)[cell viewWithTag:1010];
    UILabel *hoursLabel = (UILabel *)[cell viewWithTag:1020];
    UILabel *grossLabel = (UILabel *)[cell viewWithTag:1030];
    
    //typeLabel.textColor =[UIColor colorWithRed:0.1491f green:0.6706f blue:0.8863f alpha:1.0f];
    typeLabel.textColor =[UIColor blackColor];
    hoursLabel.textColor =[UIColor colorWithRed:0.1491f green:0.6706f blue:0.8863f alpha:1.0f];
    grossLabel.textColor =[UIColor colorWithRed:5/255.f green:197/255.f blue:150/255.f alpha:1.0f];
    
    NSString *lblType, *lblAmount, *lblHour;
    
    switch (indexPath.section) {
        case 0:
            lblType = [[earnings valueForKey:@"DESC"] objectAtIndex:indexPath.row];
            lblAmount = [[earnings valueForKey:@"AMOUNT"] objectAtIndex:indexPath.row];
            lblHour = [[earnings valueForKey:@"HRS"] objectAtIndex:indexPath.row];
            break;
        case 1:
            lblType = [[taxes valueForKey:@"DESC"] objectAtIndex:indexPath.row];
            lblAmount = [[taxes valueForKey:@"VAL"] objectAtIndex:indexPath.row];
            lblHour = @"";
            break;
        case 2:
            lblType = [[deductions valueForKey:@"DESC"] objectAtIndex:indexPath.row];
            lblAmount = [[deductions valueForKey:@"VAL"] objectAtIndex:indexPath.row];
            lblHour =  @"";
            break;
        default:
            break;
    }
    
    typeLabel.text = lblType;
    hoursLabel.text =lblHour;
    grossLabel.text = lblAmount;
    
    
    return cell;
}




-(void)displayTableView
{
    
    
    NSString *net =[[[self.HistoryData objectForKey: @"TOTALS"] valueForKey: @"VAL"] objectAtIndex:2];
    
    
    self.lblPaytype.text = [self.HistoryData objectForKey: @"PAYTYPE"];
    self.lblNet.text = [net stringByReplacingOccurrencesOfString:@"$" withString:@""];
    
    earnings = [self.HistoryData objectForKey: @"EARN"];
    taxes = [self.HistoryData objectForKey: @"TAXES"];
    deductions = [self.HistoryData objectForKey: @"DEDUCT"];
    
 
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
    /* Create custom view to display section header... */
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.frame.size.width, 18)];
    [label setFont:[UIFont systemFontOfSize:15]];
    NSString *sectionName = @"";
    /* Section header is in 0th index... */
    
    switch (section)
    {
        case 0:
            sectionName =[NSString stringWithFormat:@"%@%@%@%@%@"
                          ,@"EARNINGS"
                          ,[@"" stringByPaddingToLength:15 withString:@" " startingAtIndex:0]
                          ,@"HOURS"
                          ,[@"" stringByPaddingToLength:10 withString:@" " startingAtIndex:0]
                          ,@"AMOUNT"
                          ];
            break;
        case 1:
            sectionName =[NSString stringWithFormat:@"%@%@%@"
                          ,@"TAXES"
                          ,[@"" stringByPaddingToLength:45 withString:@" " startingAtIndex:0]
                          ,@"AMOUNT"
                          ];
            break;
        case 2:
            if([deductions count] > 0)
                sectionName =[NSString stringWithFormat:@"%@%@%@"
                              ,@"MISC DEDUCTIONS"
                              ,[@"" stringByPaddingToLength:22 withString:@" " startingAtIndex:0]
                              ,@"AMOUNT"
                              ];
            break;
            
        default:
            break;
    }

    
    
    
    [label setText:sectionName];
    [view addSubview:label];
    [view setBackgroundColor:[UIColor groupTableViewBackgroundColor]]; //your background color...
    return view;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.0;
}




//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    NSString *sectionName = @"";
//    switch (section)
//    {
//        case 0:
//            sectionName =[NSString stringWithFormat:@"%@%@%@%@%@"
//                          ,@"EARNINGS"
//                          ,[@"" stringByPaddingToLength:15 withString:@" " startingAtIndex:0]
//                          ,@"HOURS"
//                          ,[@"" stringByPaddingToLength:10 withString:@" " startingAtIndex:0]
//                          ,@"AMOUNT"
//                          ];
//            break;
//        case 1:
//            sectionName =[NSString stringWithFormat:@"%@%@%@"
//                          ,@"TAXES"
//                          ,[@"" stringByPaddingToLength:45 withString:@" " startingAtIndex:0]
//                          ,@"AMOUNT"
//                          ];
//            break;
//        case 2:
//            if([deductions count] > 0)
//            sectionName =[NSString stringWithFormat:@"%@%@%@"
//                          ,@"MISC DEDUCTIONS"
//                          ,[@"" stringByPaddingToLength:22 withString:@" " startingAtIndex:0]
//                          ,@"AMOUNT"
//                          ];
//            break;
//
//        default:
//            break;
//    }
//    return sectionName;
//}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rowCount =0;
    switch (section) {
        case 0:
            rowCount = [earnings count];
            break;
        case 1:
            rowCount = [taxes count];
            break;
        case 2:
            rowCount = [deductions count];
            break;
        default:
            break;
    }
    
    return rowCount;
    
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger retVal=0;
    
    if([earnings count] > 0)
        retVal++;
    
    if([taxes count] > 0)
        retVal++;
    
    if([deductions count] > 0)
        retVal++;
    
    return retVal;
    
}




@end
