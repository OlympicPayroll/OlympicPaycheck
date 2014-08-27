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
    NSString *nameSave;
    NSUserDefaults *defaults;
    NSString *deviceToken;
    
}
@property (nonatomic, weak) IBOutlet UIView *accessoryView;

@end

@implementation OLYLoginViewController

@synthesize retainUser;


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
    //[UIApplication sharedApplication].applicationIconBadgeNumber = 1;
    
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
    //self.txtEmaiAddress.text =@"VALE.S2020@GMAIL.COM";
    //self.txtSSN.text =@"6922";
    
    self.navigationController.navigationBar.hidden = YES;
    [self.navigationController setToolbarHidden:YES animated:NO];
    
    self.txtEmaiAddress.layer.masksToBounds = YES;
    self.txtEmaiAddress.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    self.txtEmaiAddress.layer.borderWidth = 1.0f;
    
    self.txtSSN.layer.masksToBounds=YES;
    self.txtSSN.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    self.txtSSN.layer.borderWidth= 1.0f;
    
    NSString *Welcome = [NSString stringWithFormat: @"%@\n%@", @"Welcome to", @"Olympic Paycheck"];
    self.lblWelcome.text = Welcome;
    
    
    
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
    
    defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *keepUserSetting = [defaults stringForKey:@"rememberID"];
    if ([keepUserSetting isEqualToString:@"On"]){
        self.retainUser.on = YES;
        self.txtEmaiAddress.text = [defaults objectForKey:@"emailAddress"];
        self.lblName.text = [NSString stringWithFormat: @"%@,\n%@", greeting, [defaults objectForKey:@"nameField"]];
    }else{
        self.retainUser.on = NO;
        self.lblName.text = [NSString stringWithFormat: @"%@!", greeting];
    }
    
    attempts = 0;
    fullCounter = 0;
}



- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string  {
    
    BOOL retVal=YES;
    //if (textField.tag == 1010){
    //  retVal = YES;
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


//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//
//    UITouch *touch = [[event allTouches] anyObject];
//    if ([_txtSSN isFirstResponder] && [touch view] != _txtSSN) {
//        [_txtSSN resignFirstResponder];
//    }
//    [super touchesBegan:touches withEvent:event];

//    UITouch *touch1 = [[event allTouches] anyObject];
//    if ([_txtEmaiAddress isFirstResponder] && [touch1 view] != _txtEmaiAddress) {
//        [_txtEmaiAddress resignFirstResponder];
//    }
//    [super touchesBegan:touches withEvent:event];
//}

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
        //[self.navigationController popViewControllerAnimated:YES];
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
    
    
    
    NSString *emailSaveField = self.txtEmaiAddress.text;
    
    
    defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:emailSaveField forKey:@"emailAddress"];
    
    if([retainUser isOn]){
        [defaults setObject:@"On" forKey:@"rememberID"];
    }else if(retainUser.on == 0){
        [defaults setObject:@"Off" forKey:@"rememberID"];
    }
    [defaults synchronize];
    
    deviceToken = [(OLYAppDelegate *)[[UIApplication sharedApplication] delegate] DeviceToken];
    
    
    [self FireRequest:email SSN:ssn];
    
    
}





-(void)FireRequest: (NSString*)email  SSN:(NSString*) ssn
{
    
    //self.MethodName = @"GetClientAccountsInfo";
    self.MethodName = @"GetClientAccountsInformations";
    
    OLYSoapMessages *objSoapMsg =[OLYSoapMessages new];
    
    [objSoapMsg GetClientAccountsInfo:email SSN:ssn DeviceToken:deviceToken MethodName:self.MethodName];
    
    
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
    
    
    BOOL isPassed = [[requestedData valueForKey:@"IsPassed"] boolValue];
    
    if(!isPassed)
    {
        
        fullSSN = [requestedData valueForKey:@"FullSSN"];
        NSString *message = [requestedData valueForKey:@"ErrorMsg"];
        
        
        [self CheckValidEntry:message];
        
        
        // isSuccess = isPassed;
        if(!isSuccess)
            [spinner stopAnimating];
        return;
        
    }else{
        self.txtSSN.text = nil;
        if (self.retainUser.on == NO){
            self.txtEmaiAddress.text = nil;
            self.lblName.text = @"Welcome!";
        }
    }
    
    
    NSString *empName = [requestedData valueForKey:@"Name"];
    nameSave = [requestedData valueForKey:@"Name"];
    NSArray *substrings = [nameSave componentsSeparatedByString:@", "];
    nameSave = [substrings objectAtIndex:1];
    nameSave = [nameSave capitalizedString];
    
    defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:nameSave forKey:@"nameField"];
    
    if([retainUser isOn]){
        [defaults setObject:@"On" forKey:@"rememberID"];
    }else if(retainUser.on == 0){
        [defaults setObject:@"Off" forKey:@"rememberID"];
    }
    [defaults synchronize];
    
    
    
    
    NSMutableDictionary *companyInfo =[requestedData valueForKey:@"CompanyInfo"];
    
    //If Employee works in single company
    if([companyInfo count] == 1)
    {
        OLYPayTypeViewController2 *nextViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PayTypeViewController"];
        
        
        nextViewController.EmpID =[[companyInfo valueForKey:@"EmpID"] objectAtIndex:0];
        nextViewController.EmpName = empName;
        nextViewController.ClientAccountID= [[companyInfo valueForKey:@"ClientAccountID"] objectAtIndex:0];
        nextViewController.CompName = [[companyInfo valueForKey:@"CompName"] objectAtIndex:0];
        [self.navigationController pushViewController:nextViewController animated:YES];
    }
    else
    {
        
        //Employees works in multiple company.
        OLYClientInfoViewController *nextViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CompanyInfo"];
        nextViewController.CompanyInfo = companyInfo;
        nextViewController.EmpName = empName;
        [self.navigationController pushViewController:nextViewController animated:YES];
        
        
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1010) {
        NSString *inputFullSSN = [alertView textFieldAtIndex:0].text;
        
        inputFullSSN = [inputFullSSN stringByReplacingOccurrencesOfString:@"-" withString:@""];
        //NSString *beginning = [inputFullSSN substringToIndex:3];
        //NSRange midRange = NSMakeRange(4, 2);
        //NSString *middle = [inputFullSSN substringWithRange:midRange];
        //NSString *end = [inputFullSSN substringFromIndex:7];
        //inputFullSSN = [NSString stringWithFormat: @"%@%@%@", beginning, middle, end];
        
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
            [self FireRequest:self.txtEmaiAddress.text SSN:[inputFullSSN substringWithRange:midRange]];
            
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
    
    if ([elementName isEqualToString:[NSString stringWithFormat:@"%@Result", self.MethodName]])
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
