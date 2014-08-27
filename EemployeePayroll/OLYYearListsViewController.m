//
//  OLYYearListsViewController.m
//  EemployeePayroll
//
//  Created by Reynante Sabud on 3/25/14.
//  Copyright (c) 2014 Reynante Sabud. All rights reserved.
//

#import "OLYYearListsViewController.h"
#import "OLYHomeViewController.h"
#import "OLYSoapMessages.h"

@interface OLYYearListsViewController ()
{
    int tapCount;
  NSString *pickYear;
  UILabel *label;
  UIToolbar *toolbar;
  UINavigationController *navController;
    
  UIActivityIndicatorView *spinner;
}

@end

@implementation OLYYearListsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //self.navigationController.navigationBar.hidden = NO;
    self.automaticallyAdjustsScrollViewInsets=NO;

    
    self.Name.text = self.EmpName;
    self.Company.text = self.CompName;
    self.title =@"Previous Payrolls";
  
    [self.navigationController setToolbarHidden:YES animated:YES];
    
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.center = CGPointMake(160, 240);
    [self.view addSubview:spinner];
  


}


-(void)viewWillAppear:(BOOL)animated{
    tapCount =0;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   if(tapCount == 0 ){
       tapCount++;
       [spinner startAnimating];
    
       UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
       pickYear = cell.textLabel.text;
        [self GetPayrollHistory];
   }
    
}





- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.textLabel.text = [self.YearList objectAtIndex:indexPath.row];
    return cell;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [self.YearList count];
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}



-(void)GetPayrollHistory
{
    
    OLYSoapMessages *objSoapMsg =[OLYSoapMessages new];
    
    self.MethodName = @"GetPayrollHistory";
    
    [objSoapMsg GetPayrollHistory:self.EmpID PickYear:pickYear MethodName:self.MethodName];
    
    [self FireRequest: objSoapMsg.UrlRequest];
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
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    
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
        
        
        if([self.MethodName isEqual:@"GetPayrollHistory"])
        {
            [spinner stopAnimating];
            NSArray *checkData = [requestedData objectForKey:@"PayrollHist"];
            OLYHomeViewController *nextViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Checklists"];
            nextViewController.EmpID= self.EmpID;
            nextViewController.EmpName = self.EmpName;
            nextViewController.CompName = self.CompName;
            nextViewController.ClientAccountID = self.ClientAccountID;
            nextViewController.PickYear = pickYear;
            nextViewController.CheckData = checkData;
            
            [self.navigationController pushViewController:nextViewController animated:YES];

        }
        
        
    }
}


@end
