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
    BOOL isRead;
    NSTimer *logOffTimer;
    int seconds;
}

@end


@implementation OLYPayTypeViewController2

/*
 NSString *str=[self.uploadimagearry objectAtIndex:indexPath.row];
 NSURL *uploadimageURL = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
 // NSData *imgdata=[NSData dataWithContentsOfURL:uploadimageURL];
 
 //UIImage * uploadimage = [UIImage imageWithData:imgdata];
 cell.imageView.frame=CGRectMake(0, -15, 50, 35);
 //[cell.imageView setImageWithURL:uploadimageURL];
 [cell.imageView setImageWithURL:uploadimageURL];
 */


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.navigationController.toolbarHidden = NO;
    
    //self.navigationController.navigationBar.hidden = NO;
    // [self.navigationController setNavigationBarHidden:NO animated:YES];
    
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
    self.NewImg.image = [UIImage imageNamed:nil];
    
    
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

- (void)createToolbar {
    UIBarButtonItem *changeCategory = [[UIBarButtonItem alloc] initWithTitle:@"Change Category" style:UIBarButtonItemStyleBordered target:self action:@selector(goToChangeCategory:)];
    UIBarButtonItem *difficultyExplanation = [[UIBarButtonItem alloc] initWithTitle:@"What is Difficulty?" style:UIBarButtonItemStyleBordered target:self action:@selector(goToDifficultyExplanation:)];
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    NSArray *buttonItems = [NSArray arrayWithObjects:spacer, changeCategory, spacer, difficultyExplanation, spacer, nil];
    // [self.EmpInformation setItems:buttonItems];
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
    
    NSString *empType =[currentPayrollData objectForKey:@"EmpType"];
    
    if([empType isEqualToString:@"EMAIL"])
    {
        NSInteger recount = [[currentPayrollData  valueForKey:@"Recount"] integerValue];
        NSString *checkDate =[currentPayrollData objectForKey:@"PayDate"] ;
        
        if(recount == 1)
        {
            //Single Check
            
            
            
            if(!isRead)
            {
                OLYSoapMessages *objSoapMsg =[OLYSoapMessages new];
                NSString *sentID = [[[currentPayrollData objectForKey:@"Details"] objectAtIndex:0] valueForKey:@"SentID"] ;
                
                self.MethodName = @"FlagReadPayrolls";
                
                [objSoapMsg FlagReadPayrolls:sentID MethodName:self.MethodName];
                
                [self FireRequest: objSoapMsg.UrlRequest];
                
            }
            
            OLYCurrentPayrollMainViewController * nextViewController =[self.storyboard instantiateViewControllerWithIdentifier:@"CurrentPayrollMainDetails"];
            nextViewController.EmailDetails = currentPayrollData;
            nextViewController.RecordNumber = 0;
            nextViewController.EmpName = self.EmpName;
            nextViewController.CompName = self.CompName;
            nextViewController.PayDate = checkDate;
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
            nextViewController.PayDate = checkDate;
            [self.navigationController pushViewController:nextViewController animated:YES];
            
        }
    }
    else
    {
        NSString *detailsID =[currentPayrollData valueForKey:@"ID"];
        NSString *checkDate =[[[currentPayrollData objectForKey:@"Employee"] objectForKey:@"PayDate"] objectAtIndex:0];
        
        
        if(detailsID==nil || checkDate==nil)
            return;
        
        OLYDetailViewController *nextViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"HistoryDetails"];
        nextViewController.ClientAccountID = self.ClientAccountID;
        nextViewController.HistoryID = detailsID;
        nextViewController.CheckDate = checkDate;
        [self.navigationController pushViewController:nextViewController animated:YES];
        
    }
    
    
}

- (IBAction)PreviousPayrollClick:(id)sender {
    
    if(tapCount !=0) return;
    
    tapCount++;
    OLYSoapMessages *objSoapMsg =[OLYSoapMessages new];
    
    self.MethodName = @"GetPayrollYears";
    [objSoapMsg GetPayrollYears:self.EmpID MethodName:self.MethodName];
    [self FireRequest: objSoapMsg.UrlRequest];
    
}



//GetLatestPayroll
-(void)GetLatestPayroll
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




-(void) MoveToPreviousPayrollController{
    NSArray *years=[previousPayrollData objectForKey:@"Years"];
    years = [years[0] componentsSeparatedByString:@","];
    //NSArray *years = [list[0] componentsSeparatedByString:@","];
    
    
    if([years count]== 1)
    {
        pickYear = years[0];
        
        [self DisplayCheckDates];
        
        
    }
    else
    {
        
        OLYYearListsViewController *nextViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"YearLists"];
        nextViewController.EmpID= self.EmpID;
        nextViewController.EmpName = self.EmpName;
        nextViewController.CompName = self.CompName;
        nextViewController.ClientAccountID = self.ClientAccountID;
        nextViewController.YearList = years;
        
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
            NSArray *monthYear = [[requestedData objectForKey:@"PayDate"] componentsSeparatedByString: @","];
            
            self.lblCheckDate.text = [NSString stringWithFormat:@"(%@,%@)", monthYear[0], monthYear[1]];
            
            isRead = [[[[currentPayrollData objectForKey:@"Details"] objectAtIndex:0] valueForKey:@"IsRead"] boolValue];
            if(!isRead)
            {
                self.NewImg.image = [UIImage imageNamed:@"new.png"];
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
            [self MoveToPreviousPayrollController];
            
        }
        
    }
    
}



@end










