//
//  OLYClientInfoViewController.m
//  EemployeePayroll
//
//  Created by Reynante Sabud on 9/5/13.
//  Copyright (c) 2013 Reynante Sabud. All rights reserved.
//

#import "OLYClientInfoViewController.h"
#import "OLYHomeViewController.h"
#import "OLYPayTypeViewController2.h"

@interface OLYClientInfoViewController ()
{
    int tapCount;
  
}

@end

@implementation OLYClientInfoViewController
//@synthesize tableView;


- (void)viewDidLoad
{
  
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;
    
    self.Name.text = self.EmpName;
    self.imgBanner.image = [UIImage imageNamed: @"banner2.png"];
    self.navigationItem.hidesBackButton = NO;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    
    

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) viewWillAppear:(BOOL)animated
{
    tapCount = 0;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

   
    
    
    NSInteger recNo = [[[self.CompanyInfo valueForKey:@"RecNo"]
                       objectAtIndex:indexPath.row]
                       integerValue];
    
    if(recNo == 0)
    {
        
      UIAlertView  *alert = [[UIAlertView alloc] initWithTitle:@""
                                           message:@"You have no available Payroll for this Company."
                                          delegate:nil
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
        
        [alert show];
        return;

    }
    
    
    if(tapCount==0){
         tapCount++;
        OLYPayTypeViewController2 *nextViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PayTypeViewController"];
    
        nextViewController.EmpName = self.EmpName;
        nextViewController.EmpID = [[self.CompanyInfo valueForKey:@"EmpID"] objectAtIndex:indexPath.row];
        nextViewController.ClientAccountID= [[self.CompanyInfo valueForKey:@"ClientAccountID"] objectAtIndex:indexPath.row];
        nextViewController.CompName = [[self.CompanyInfo valueForKey:@"CompName"] objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:nextViewController animated:YES];
    }
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    cell.textLabel.text = [[self.CompanyInfo valueForKey:@"CompName"]  objectAtIndex:indexPath.row];
    return cell;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
     return [self.CompanyInfo count];
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Please select the Company";
}


@end














