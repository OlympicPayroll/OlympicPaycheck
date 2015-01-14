//
//  OLYPayTypeViewController2.m
//  EemployeePayroll
//
//  Created by Reynante Sabud on 4/17/14.
//  Copyright (c) 2014 Reynante Sabud. All rights reserved.
//
#import "OLYWebRequest.h"
#import "OLYCurrentPayrollMainViewController.h"
#import "OLYPayTypeViewController2.h"
#import "OLYDetailViewController.h"
#import "OLYHomeViewController.h"
#import "OLYYearListsViewController.h"
#import "OLYCheckListViewController.h"
#import "OLYSoapMessages.h"
#import "OLYPhotoGrabber.h"
#import "OLYLoginViewController.h"



@interface OLYPayTypeViewController2 ()
{
    int tapCount;
    
    NSMutableDictionary *currentPayrollData;
    NSMutableDictionary *previousPayrollData;
    NSString *pickYear;
    UIActivityIndicatorView *spinner;
 //   BOOL isRead;
    NSTimer *logOffTimer;
    int seconds;
  // NSData *currentPayrollInfoData;
}

@end


@implementation OLYPayTypeViewController2



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = NO;
    
    //[self createToolbar];
    
    self.title =@"Report Options";
    self.navigationItem.rightBarButtonItem = nil;
    UIBarButtonItem *logOut = [[UIBarButtonItem alloc] initWithTitle:@"Log Out" style:UIBarButtonItemStylePlain target:self action:@selector(LogOut)];
    self.navigationItem.leftBarButtonItem = logOut;
    
    self.btnLatestPayroll.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.btnPreviousPayroll.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    NSString *nameFormat;
    nameFormat = self.EmpName;
    
    NSArray *substrings = [nameFormat componentsSeparatedByString:@", "];
    nameFormat = [NSString stringWithFormat:@"%@ %@", [substrings objectAtIndex:1], [substrings objectAtIndex:0]];
    nameFormat = [nameFormat capitalizedString];
    
    self.lblInformation.text = [NSString stringWithFormat:@"Welcome, %@!\n\nClick below to\nview any payroll from:\n%@", nameFormat, self.CompName];
    
    
    [self GetLatestPayroll];
    
    
}



-(void)viewWillAppear:(BOOL)animated{
    tapCount=0;
    
    [self.navigationController setToolbarHidden:NO animated:YES];
    
    if(self.IsReadLatestPayroll)
    {
      [spinner stopAnimating];
       self.NewImg.image = [UIImage imageNamed:nil];
    }
    
    
}

- (NSTimer *)createTimer {
    return [NSTimer scheduledTimerWithTimeInterval:1.0
                                            target:self
                                          selector:@selector(timerTicked:)
                                          userInfo:nil
                                           repeats:YES];
}

- (void)timerTicked:(NSTimer *)timer {
    seconds++;
    if (seconds == 1){
        [timer invalidate];
        OLYLoginViewController *nextViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Login"];
        [self.navigationController pushViewController:nextViewController animated:NO];
        self.logOutView.hidden = YES;
        seconds = 0;
    }
}

- (void)LogOut{
    
    self.logOutView.hidden = NO;
    [self createTimer];
    
}





- (IBAction)BtnGrabPhotoClick:(id)sender{
    
    
    OLYPhotoGrabber *nextViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PhotoGrabber"];
    nextViewController.EmpID = self.EmpID;
    nextViewController.EmpName = self.EmpName;
    nextViewController.CompName = self.CompName;
    [self.navigationController pushViewController:nextViewController animated:YES];
    
}



- (IBAction)BtnLatestPayrollClick:(id)sender {
    
    if(tapCount != 0) return;
    
    tapCount++;
    
    [spinner stopAnimating];
    
    
    if(!self.IsReadLatestPayroll)
    {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setValue:@"True" forKey:@"IsReadLatestPayroll"];
        [prefs synchronize];

    }
    
    
    if([[currentPayrollData objectForKey:@"DataSource"] isEqualToString:@"HISTORY"])
    {
        
        OLYDetailViewController *nextViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"HistoryDetails"];
        nextViewController.ClientAccountID = self.ClientAccountID;
        nextViewController.CheckDate = [currentPayrollData valueForKey:@"PayDate"];
        nextViewController.HistoryData = currentPayrollData;
        [self.navigationController pushViewController:nextViewController animated:YES];
        
    }
    else if([[currentPayrollData objectForKey:@"DataSource"] isEqualToString:@"EMAIL"])
    {
        NSInteger recount = [[currentPayrollData  valueForKey:@"Recount"] integerValue];
         
        if(recount == 1)
        {
            //Single Check
            
            
            if(!self.IsReadLatestPayroll)
            {
                OLYSoapMessages *objSoapMsg =[OLYSoapMessages new];
                NSString *sentID = [[[currentPayrollData objectForKey:@"Details"] objectAtIndex:0] valueForKey:@"SentID"] ;
                
                self.MethodName = @"FlagReadPayrolls";
                
                [objSoapMsg FlagReadPayrolls:sentID MethodName:self.MethodName];
                
                [self FireRequest: objSoapMsg.UrlRequest];
                
                self.IsReadLatestPayroll = YES;
                
            }
            
           
            OLYCurrentPayrollMainViewController * nextViewController =[self.storyboard instantiateViewControllerWithIdentifier:@"CurrentPayrollMainDetails"];
            nextViewController.EmailDetails = currentPayrollData;
            nextViewController.RecordNumber = 0;
            nextViewController.EmpName = self.EmpName;
            nextViewController.CompName = self.CompName;
            nextViewController.PayDate = [currentPayrollData objectForKey:@"PayDate"];
            [self.navigationController pushViewController:nextViewController animated:YES];
        }
        else
        {
            //Multiple Check.
            OLYCheckListViewController *nextViewController =[self.storyboard instantiateViewControllerWithIdentifier:@"MultipleChecklists"];
            nextViewController.RecordNumber = recount;
            nextViewController.EmailDetails = currentPayrollData;
            nextViewController.EmpName = self.EmpName;
            nextViewController.CompName = self.CompName;
            nextViewController.PayDate = [currentPayrollData objectForKey:@"PayDate"];
            [self.navigationController pushViewController:nextViewController animated:YES];
            
        }

    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Data Error!"
                                                        message:@"Please contact olympic Payroll."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    


}





- (IBAction)PreviousPayrollClick:(id)sender {
    
    if(tapCount !=0) return;
    
    tapCount++;
    
     // Retreiving an Yearlist
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSMutableArray *arrayYears = [[[prefs stringForKey:@"Yearlist"] componentsSeparatedByString:@","] mutableCopy];
   
    
    if([arrayYears count] > 0)
    {
        [spinner stopAnimating];
  
        //Check the same user.
        if([arrayYears[0] intValue] == [self.EmpID intValue])
        {
            NSArray *payDateArray =[[currentPayrollData objectForKey:@"PayDate"] componentsSeparatedByString:@","];
         
            //If Year's latest payroll is  eaqual to year of current Payroll.
            if([arrayYears[1] intValue] == [payDateArray[1] intValue])
            {
                [arrayYears removeObjectAtIndex: 0];
                [self MoveToPreviousPayrollController : arrayYears ];
            }
            else
            {
                 OLYSoapMessages *objSoapMsg =[OLYSoapMessages new];
                    
                 self.MethodName = @"GetPayrollYears";
                 [objSoapMsg GetPayrollYears:self.EmpID MethodName:self.MethodName];
                 [self FireRequest: objSoapMsg.UrlRequest];
             }
        }
        else
        {
            OLYSoapMessages *objSoapMsg =[OLYSoapMessages new];
            
            self.MethodName = @"GetPayrollYears";
            [objSoapMsg GetPayrollYears:self.EmpID MethodName:self.MethodName];
            [self FireRequest: objSoapMsg.UrlRequest];
       
        }

    }
    else
    {
        OLYSoapMessages *objSoapMsg =[OLYSoapMessages new];
        
        self.MethodName = @"GetPayrollYears";
        [objSoapMsg GetPayrollYears:self.EmpID MethodName:self.MethodName];
        [self FireRequest: objSoapMsg.UrlRequest];
    }
    
}



//GetLatestPayroll
-(void)GetLatestPayroll
{
    
    // Retreiving an CurrentPayrollData
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *previousPayroll = [prefs objectForKey:@"CurrentPayrollData"];

    id  payrollDetailsDict=[[previousPayroll objectForKey:@"Details"] objectAtIndex:0];
    int previousPayrollID = [[payrollDetailsDict valueForKey:@"SentID"] intValue];
    int previousUserEmpID = [[prefs stringForKey:@"EmpID"] intValue];
    
     if(previousUserEmpID == [self.EmpID intValue] && previousPayrollID == [self.LatestPayrollID intValue])
     {
  
         if([[previousPayroll objectForKey:@"DataSource"] isEqualToString:@"HISTORY"] )
         {
            [self DisplayLatestPayroll];
         }
         else if([[previousPayroll objectForKey:@"DataSource"] isEqualToString:@"EMAIL"] )
         {
            self.IsReadLatestPayroll = [[prefs objectForKey:@"IsReadLatestPayroll"] boolValue];
           
             if(self.IsReadLatestPayroll)
             {
                 self.lblCheckDate.text = [prefs objectForKey:@"CheckDate"];
                 currentPayrollData = previousPayroll;
             }
             else
             {
                [self DisplayLatestPayroll];
             }

         }
         else
         {
             [self DisplayLatestPayroll];
         }
         
         
     }
    else
    {
        [prefs setValue:self.EmpID forKey:@"EmpID"];
        //[prefs setValue:self.LatestPayrollID forKey:@"LatestPayrollID"];
        [prefs synchronize];
      
        [self DisplayLatestPayroll];
    
    }
 
}



-(void)DisplayLatestPayroll
{

    OLYSoapMessages *objSoapMsg =[OLYSoapMessages new];
    
    self.MethodName = @"GetLatestPayroll";
    
    [objSoapMsg GetPayrollHistory:self.EmpID MethodName:self.MethodName];
    
    [self FireRequest: objSoapMsg.UrlRequest];


}


-(void)DisplayCheckDates
{
    
    OLYSoapMessages *objSoapMsg =[OLYSoapMessages new];
    
    self.MethodName = @"GetPayrollHistory";
    
    [objSoapMsg GetPayrollHistory:self.EmpID PickYear:pickYear MethodName:self.MethodName];
    
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
                                                        message:@"Failed connection."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        
        [alert show];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    
}




-(void) MoveToPreviousPayrollController :(NSMutableArray *) arrayYears{

    
    //If Employee has one year payroll.
    if([arrayYears count]== 1)
    {
        pickYear = arrayYears[0];
        
        [self DisplayCheckDates];
        
        
    }
    else
    {
        
        OLYYearListsViewController *nextViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"YearLists"];
        nextViewController.EmpID= self.EmpID;
        nextViewController.EmpName = self.EmpName;
        nextViewController.CompName = self.CompName;
        nextViewController.ClientAccountID = self.ClientAccountID;
        nextViewController.YearList = arrayYears;
        
        [self.navigationController pushViewController:nextViewController animated:YES];
    }
    
}



-(void)parser:(NSXMLParser *)parser
didEndElement:(NSString *)elementName
 namespaceURI:(NSString *)namespaceURI
qualifiedName:(NSString *)qName
{
    
    if ([elementName isEqualToString:[NSString stringWithFormat:@"%@Result", self.MethodName]])
    {
        [spinner stopAnimating];
        
        NSData *requestResult = [self.SoapResults dataUsingEncoding:NSUTF8StringEncoding];
        
        
        NSMutableDictionary *requestedData = [NSJSONSerialization  JSONObjectWithData:requestResult
                                                                              options:0
                                                                                error:nil];
        
        
        [self.SoapResults setString:@""];
        self.ElementFound = FALSE;
        
        
        
        if ([self.MethodName isEqualToString: @"GetLatestPayroll" ]) {
            [spinner stopAnimating];
            currentPayrollData = requestedData;
            self.CheckDate =[requestedData valueForKey:@"PayDate"];
            self.lblCheckDate.text =self.CheckDate;
           
             NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            //  saving an CurrentPayrollData
            if([[requestedData objectForKey:@"DataSource"] isEqualToString:@"HISTORY"])
            {
                //Rettrieve data from History Details table
                self.IsReadLatestPayroll = YES;

                [prefs setObject:nil forKey:@"CurrentPayrollData"];
                [prefs synchronize];
            }
            else if([[requestedData objectForKey:@"DataSource"] isEqualToString:@"EMAIL"]){
               
                self.IsReadLatestPayroll = [[[[requestedData objectForKey:@"Details"] objectAtIndex:0] valueForKey:@"IsRead"] boolValue];
            
                if(!self.IsReadLatestPayroll)
                {
                    [prefs setValue:@"False" forKey:@"IsReadLatestPayroll"];
                    self.NewImg.image = [UIImage imageNamed:@"new.png"];
                }
 
                [prefs setObject:currentPayrollData forKey:@"CurrentPayrollData"];
                [prefs setValue:self.CheckDate forKey:@"CheckDate"];
                [prefs synchronize];
                

            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Data Error!"
                                                                message:@"Please contact olympic Payroll."
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];

            
            }
            
        }
        else if ([self.MethodName isEqualToString: @"GetPayrollHistory" ]) {
            
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
        
        else if([self.MethodName isEqualToString: @"GetPayrollYears" ])
        {
            previousPayrollData = requestedData;
            
            if(requestedData != nil)
            {
                NSString *yearlist = [[requestedData objectForKey:@"Years"] objectAtIndex:0];
                NSMutableArray *arrayYears = [[yearlist componentsSeparatedByString:@","] mutableCopy];
                
               
                // saving an Yearlist and EmpID
                NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                [prefs setValue:[NSString stringWithFormat:@"%@,%@",self.EmpID, yearlist] forKey:@"Yearlist"];
                [prefs synchronize];
                
                [self MoveToPreviousPayrollController :arrayYears];
            }
            
        }
        
    }
    
}



@end










