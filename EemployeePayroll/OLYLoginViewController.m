//
//  OLYLoginViewController.m
//  EemployeePayroll
//
//  Created by Reynante Sabud on 7/31/13.
//  Copyright (c) 2013 Reynante Sabud. All rights reserved.
//

#import "OLYLoginViewController.h"
#import "OLYWebRequest.h"
#import "OLYSoapParcer.h"
#import "OLYClientInfoViewController.h"
#import "OLYHomeViewController.h"
#import "OLYPayTypeViewController2.h"
#import <QuartzCore/QuartzCore.h>
#import "OLYSoapMessages.h"
#import "OLYPrivacyPolicyViewController.h"


#define NUMBERS_ONLY @"1234567890"
#define CHARACTER_LIMIT 4
#define ALERT_FULLSSN_LIMIT 11

@interface OLYLoginViewController ()
{
    int tapCount;
    BOOL isSuccess;
    int attempts;
    int fullCounter;
    NSString *fullSSN;
    UIActivityIndicatorView *spinner;
    NSString *deviceToken;
    
}
@property (nonatomic, weak) IBOutlet UIView *accessoryView;

@end

@implementation OLYLoginViewController


-(void)viewDidAppear:(BOOL)animated{
    tapCount=0;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [spinner stopAnimating];
    
}

-(void)viewDidLoad
{
    [super viewDidLoad];
 
    if([UIApplication sharedApplication].applicationIconBadgeNumber >1)
    {
       [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    }
    
    [self.txtEmaiAddress setInputAccessoryView:self.accessoryView];
    [self.txtSSN setInputAccessoryView:self.accessoryView];
    
    self.accessoryView.backgroundColor = [UIColor whiteColor];
    
    self.txtEmaiAddress.delegate = self;
    self.txtEmaiAddress.keyboardType = UIKeyboardTypeEmailAddress;
    
    self.txtSSN.delegate = self;
    self.txtSSN.keyboardType = UIKeyboardTypeNumberPad;
    
    [self.navigationController setToolbarHidden:YES animated:NO];
    
    
}


- (IBAction)doneAction:(id)sender {
    
    // user tapped the Done button, release first responder on the text view
    if ([self.txtSSN isFirstResponder]){
        [self.txtSSN resignFirstResponder];
    }else if ([self.txtEmaiAddress isFirstResponder]){
        [self.txtEmaiAddress resignFirstResponder];
    }
}



-(IBAction)nextButton:(id)sender{
    [self.txtSSN becomeFirstResponder];
    self.btnNext.enabled = NO;
    self.btnPrevious.enabled = YES;
}



-(IBAction)previousButton:(id)sender{
    [self.txtEmaiAddress becomeFirstResponder];
    self.btnNext.enabled = YES;
    self.btnPrevious.enabled = NO;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    
    if (textField.tag == 1020){
        self.btnNext.enabled = NO;
        self.btnPrevious.enabled = YES;
    }else if(textField.tag == 1010){
        self.btnNext.enabled = YES;
        self.btnPrevious.enabled = NO;
    }
    
    return YES;
}


-(void) viewWillAppear:(BOOL)animated
{
    //[super viewDidLoad];
    [super viewWillAppear:animated];
    
    //self.title =@"Olympic Payroll Services";
    self.txtSSN.secureTextEntry = YES;
    //self.txtEmaiAddress.text =@"ohheyliv@aol.com";
    //self.txtSSN.text =@"3546";
   // self.txtEmaiAddress.text =@"VALE.S2020@GMAIL.COM";
    //self.txtSSN.text =@"6922";
    
    self.navigationController.navigationBar.hidden = YES;
    [self.navigationController setToolbarHidden:YES animated:NO];
    
    self.txtEmaiAddress.layer.masksToBounds = YES;
    self.txtEmaiAddress.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    self.txtEmaiAddress.layer.borderWidth = 1.0f;
    
    self.txtSSN.layer.masksToBounds=YES;
    self.txtSSN.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    self.txtSSN.layer.borderWidth= 1.0f;
    
    self.lblWelcome.text = [NSString stringWithFormat: @"%@\n%@", @"Welcome to", @"Olympic Paycheck"];
   
    
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH"];
    NSString *strTime = [dateFormatter stringFromDate:today];
    int currentTime = [strTime intValue];
    NSString *greeting;
    if ( currentTime >= 6 && currentTime <= 11 ){
        greeting = @"Good morning";
    }else if ( currentTime >= 12 && currentTime <= 17 ){
        greeting = @"Good afternoon";
    }else if ( currentTime >= 18 && currentTime <= 23 ){
        greeting = @"Good evening";
    }else{
        greeting = @"Good night";
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    self.retainUser.on = [[defaults stringForKey:@"rememberID"] boolValue];
    
    if(self.retainUser.on)
    {
        NSString* empName =[defaults objectForKey:@"nameField"];
        NSArray *lastNameFirsName = [empName componentsSeparatedByString:@", "];
        
        NSString *firstName =([lastNameFirsName count] > 1) ? [lastNameFirsName[1] capitalizedString] : empName  ;
        
        self.txtEmaiAddress.text = [defaults objectForKey:@"emailAddress"];
        
        self.lblName.text = [NSString stringWithFormat: @"%@,\n%@", greeting, firstName];
        
    }
    else
    {
        self.txtEmaiAddress.text =@"";
        self.lblName.text = [NSString stringWithFormat: @"%@!", greeting];
    }
    self.txtSSN.text =@"";
    
    attempts = 0;
    fullCounter = 0;
}



- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string  {
    
    BOOL retVal=YES;
 
    if (textField.tag == 1020){
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS_ONLY] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        
        retVal = ([string isEqualToString:filtered])&&(newLength <= CHARACTER_LIMIT);
        
    }
    
    
    
    if (self.txtFullSSN.isEditing){
        
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS_ONLY] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        if(range.length == 0){
            if(range.location == 3){
                textField.text = [NSString stringWithFormat: @"%@-", textField.text];
            }
            if(range.location==6){
                textField.text = [NSString stringWithFormat: @"%@-", textField.text];
            }
            
        }
        retVal = ([string isEqualToString:filtered])&&(newLength <= ALERT_FULLSSN_LIMIT);
    }
    return retVal;
    
}



- (IBAction)btnPrivacyAndTerms:(id)sender{
    
    OLYPrivacyPolicyViewController *nextViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PrivacyPolicy"];
    [self.navigationController pushViewController:nextViewController animated:YES];
    
    
}


- (IBAction)BtnLoginClick:(id)sender {
    
    
    if (tapCount > 0) return;
    
    tapCount++;
    
     
    NSString *email = self.txtEmaiAddress.text;
    NSString *ssn = self.txtSSN.text;
    
    isSuccess = YES;
    
    UIAlertView *alert;
    
    
    if(email.length == 0)
    {
        
        alert = [[UIAlertView alloc] initWithTitle:@""
                                           message:@"Please enter a valid email address and try again."
                                          delegate:nil
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
        
        [alert show];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        tapCount = 0;
        isSuccess = NO;
        
        return;
    }
    
    
    
    if(ssn.length != 4)
    {
        
        alert = [[UIAlertView alloc] initWithTitle:@""
                                           message:@"Please enter the last four digits of your Social Security number and try again"
                                          delegate:nil
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
        
        [alert show];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        tapCount = 0;
        isSuccess = NO;
        return;
    }
    
    
    NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
    [DateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString* currentDate = [DateFormatter stringFromDate:[NSDate date]];
    
   
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    NSString*previousDate = [prefs stringForKey:@"LastDateEntry"];
    NSString* previousEmail = [prefs stringForKey:@"emailAddress"];
    NSString* previousSSN = [prefs stringForKey:@"ssn"];


    if([email isEqual: previousEmail] && [ssn isEqual: previousSSN] && [currentDate isEqual:previousDate] )
    {
        NSString *switchStatus =[NSString stringWithFormat:@"%d",self.retainUser.on];
       [prefs setValue:switchStatus forKey:@"rememberID"];
       [prefs synchronize];
        
        NSMutableDictionary *companyInfo =[prefs objectForKey:@"CompanyInfo"];
       
        if ([companyInfo isEqual:nil]) {
            //Save Device Token.
            deviceToken = [(OLYAppDelegate *)[[UIApplication sharedApplication] delegate] DeviceToken];
            
            [self FireRequest:email SSN:ssn MethodName:@"GetClientAccountsInformations"] ;

        }
        else
        {
        
        
            NSString *latestPayrollID = [[companyInfo valueForKey:@"LatestPayrollID"] objectAtIndex:0];
        
            NSString*empName = [prefs stringForKey:@"nameField"];
        
            //If Employee works in single company
            if([companyInfo count] == 1)
            {
            
                OLYPayTypeViewController2 *nextViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PayTypeViewController"];
            
            
                nextViewController.EmpID =[[companyInfo valueForKey:@"EmpID"] objectAtIndex:0];
                nextViewController.EmpName = empName;
                nextViewController.LatestPayrollID =latestPayrollID;
                nextViewController.ClientAccountID= [[companyInfo valueForKey:@"ClientAccountID"] objectAtIndex:0];
                nextViewController.CompName = [[companyInfo valueForKey:@"CompName"] objectAtIndex:0];
                [self.navigationController pushViewController:nextViewController animated:YES];
            }
            else
            {
            
                //Employees works in multiple company.
                OLYClientInfoViewController *nextViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CompanyInfo"];
                nextViewController.LatestPayrollID =latestPayrollID;
                nextViewController.CompanyInfo = companyInfo;
                nextViewController.EmpName = empName;
                [self.navigationController pushViewController:nextViewController animated:YES];
            
            
            }
        }
    
    }
    else
    {
        
        //Save Device Token.
        deviceToken = [(OLYAppDelegate *)[[UIApplication sharedApplication] delegate] DeviceToken];
    
        [self FireRequest:email SSN:ssn MethodName:@"GetClientAccountsInformations"] ;
        
    }
    
    
}







-(void)FireRequest: (NSString*)email  SSN:(NSString*) ssn MethodName:(NSString*) methodName
{
    
    self.MethodName = methodName;
    
    OLYSoapMessages *objSoapMsg =[OLYSoapMessages new];
    
    [objSoapMsg GetClientAccountsInfo:email SSN:ssn DeviceToken:deviceToken DeviceType:@"IOS" MethodName:methodName];
    
    
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.center = CGPointMake(160, 240);
    [self.view addSubview:spinner];
    [spinner startAnimating];
    
    //Fire away.
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:objSoapMsg.UrlRequest delegate:self];
    
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







#pragma mark Segues


- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    return isSuccess;
    
}




-(void)MoveToNextController :(NSMutableDictionary *)requestedData{
    
     NSString *ssn = self.txtSSN.text;
    
    BOOL isPassed = [[requestedData valueForKey:@"IsPassed"] boolValue];
    
    if(!isPassed)
    {

        if(![[requestedData valueForKey:@"IsValidEmail"] boolValue])
        {
            [spinner stopAnimating];
            
           
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"Invalid Email Address."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            
            [alert show];
            tapCount =0;
            isSuccess = NO;
            return;

        
        }
        
        
        
        int empCount =[[requestedData valueForKey:@"EmpCount"] intValue];
        if(empCount > 1)
        {
           [spinner stopAnimating];
            
            NSString *message = [NSString stringWithFormat
                                 :@"This Email is used by (%d) Employees with different SS number. Please call Olympic Payroll."
                                 , empCount];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                               message:message
                                              delegate:nil
                                     cancelButtonTitle:@"OK"
                                     otherButtonTitles:nil];
            
            [alert show];
            isSuccess = NO;
            tapCount =0;
          return;
        }

        
        if(![[requestedData valueForKey:@"IsValidSSN"] boolValue])
        {

            fullSSN = [requestedData valueForKey:@"FullSSN"];
        
            [self CheckValidEntry:@"Invalid Social Security number."];
        }

        if(!isSuccess)
            [spinner stopAnimating];
        
        tapCount =0;
        return;
        
    }else{
        self.txtSSN.text = nil;
        if (self.retainUser.on == NO){
            self.txtEmaiAddress.text = nil;
            self.lblName.text = @"Welcome!";
        }
    }
    
    
    NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
    [DateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString* currentDate = [DateFormatter stringFromDate:[NSDate date]];
    
    NSString *empName = [requestedData valueForKey:@"Name"];

   // NSString* ssn = self.txtSSN.text;
  
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *switchStatus =[NSString stringWithFormat:@"%d",self.retainUser.on];
    [defaults setValue:switchStatus forKey:@"rememberID"];
    [defaults setValue:self.txtEmaiAddress.text forKey:@"emailAddress"];
    [defaults setValue:ssn forKey:@"ssn"];
    [defaults setValue:empName forKey:@"nameField"];
    [defaults setValue:currentDate forKey:@"LastDateEntry"];
    

    
    NSMutableDictionary *companyInfo =[requestedData valueForKey:@"CompanyInfo"];
    [defaults setObject:companyInfo forKey:@"CompanyInfo"];
    [defaults synchronize];
    
    NSString *latestPayrollID = [[companyInfo valueForKey:@"LatestPayrollID"] objectAtIndex:0];
    
    /*
    if(latestPayrollID == "")
    alert = [[UIAlertView alloc] initWithTitle:@""
                                       message:@"Please enter a valid email address and try again."
                                      delegate:nil
                             cancelButtonTitle:@"OK"
                             otherButtonTitles:nil];
    
    [alert show];
    */
    [self dismissViewControllerAnimated:YES completion:nil];
    tapCount = 0;
    isSuccess = NO;

    
    
    //If Employee works in single company
    if([companyInfo count] == 1)
    {
  
        OLYPayTypeViewController2 *nextViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PayTypeViewController"];
        
        
        nextViewController.EmpID =[[companyInfo valueForKey:@"EmpID"] objectAtIndex:0];
        nextViewController.EmpName = empName;
        nextViewController.LatestPayrollID =latestPayrollID;
        nextViewController.ClientAccountID= [[companyInfo valueForKey:@"ClientAccountID"] objectAtIndex:0];
        nextViewController.CompName = [[companyInfo valueForKey:@"CompName"] objectAtIndex:0];
        [self.navigationController pushViewController:nextViewController animated:YES];
    }
    else
    {
        
        //Employees works in multiple company.
        OLYClientInfoViewController *nextViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CompanyInfo"];
        nextViewController.LatestPayrollID =latestPayrollID;
        nextViewController.CompanyInfo = companyInfo;
        nextViewController.EmpName = empName;
        [self.navigationController pushViewController:nextViewController animated:YES];
        
        
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1010) {
        NSString *inputFullSSN = [alertView textFieldAtIndex:0].text;
        
        inputFullSSN = [inputFullSSN stringByReplacingOccurrencesOfString:@"-" withString:@""];
        
        if([inputFullSSN length] != 9){
            [spinner stopAnimating];
            isSuccess = NO;
            tapCount = 0;
            UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Invalid Entry"
                                                             message:@"You must enter a 9-digit Social Security number to proceed."
                                                            delegate:self
                                                   cancelButtonTitle:nil
                                                   otherButtonTitles: nil];
            [alert addButtonWithTitle:@"GO"];
            alert.tag = 1030;
            [alert show];
            
        }else if (![ inputFullSSN isEqual:fullSSN]){
            [spinner stopAnimating];
            isSuccess = NO;
            tapCount = 0;
            UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Invalid entry. Try again."
                                                             message:@""
                                                            delegate:self
                                                   cancelButtonTitle:nil
                                                   otherButtonTitles: nil];
            [alert addButtonWithTitle:@"OK"];
            alert.tag = 1020;
            [alert show];
        }else{
            isSuccess = YES;
            NSRange midRange = NSMakeRange(5, 4);
            [self FireRequest:self.txtEmaiAddress.text SSN:[inputFullSSN substringWithRange:midRange] MethodName:@"GetClientAccountsInformations"];
            
        }
        
    }
    
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag == 1020){
        fullCounter++;
        if(fullCounter == 3){
            exit(0);
        }
        [self CheckValidEntry:@"Invalid. Re-enter."];
        
    }else if(alertView.tag == 1030){
        
        [self CheckValidEntry:@"Please enter a valid Social Security Number"];
        
    }
}

//Steve Jobs Assignment...
-(void) CheckValidEntry : (NSString*) errorMessage
{
    tapCount = 0;
    UIAlertView *alert;
    BOOL retVal = NO;
    if (attempts == 2 && fullCounter <= 3){
        
        [spinner stopAnimating];
        [self.view endEditing:YES];
        alert =[[UIAlertView alloc ] initWithTitle:@"Invalid"
                                           message:@"Enter your full Social Security number."
                                          delegate:self
                                 cancelButtonTitle:nil
                                 otherButtonTitles: nil];
        alert.tag = 1010;
        [alert addButtonWithTitle:@"GO"];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        self.txtFullSSN = [alert textFieldAtIndex:0];
        self.txtFullSSN.placeholder = @"XXX-XX-XXXX";
        self.txtFullSSN.delegate = self;
        self.txtFullSSN.keyboardType = UIKeyboardTypeNumberPad;
        [alert show];
        isSuccess = NO;
        
        return;
        
    }else{
        [spinner stopAnimating];
        alert = [[UIAlertView alloc] initWithTitle:errorMessage
                                           message:@""
                                          delegate:nil
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
        [alert show];
        attempts++;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
    isSuccess = retVal;
    
}





//==================================
#pragma mark - Request Methods.
//==================================
//---when the end of element is found---
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    
    if ([elementName isEqualToString:[NSString stringWithFormat:@"%@Result",@"GetClientAccountsInformations"]])
    {
        
        NSData *requestResult = [self.SoapResults dataUsingEncoding:NSUTF8StringEncoding];
        
        NSMutableDictionary *requestedData = [NSJSONSerialization
                                              JSONObjectWithData:requestResult
                                              options:0
                                              error:nil];
        
        
        [self.SoapResults setString:@""];
        self.ElementFound = FALSE;
        
        [self MoveToNextController:requestedData];
    }
}






@end
