//
//  OLYCoreViewController.m
//  EemployeePayroll
//
//  Created by Reynante Sabud on 7/31/13.
//  Copyright (c) 2013 Reynante Sabud. All rights reserved.
//
//#import "OLYAppDelegate.h"
#import "OLYCoreViewController.h"

@interface OLYCoreViewController ()
{
    //---web service access---
    //NSMutableData *responseData;
   // NSMutableString *soapResults;
    NSURLConnection *conn;
    
    //---xml parsing---
    NSXMLParser *xmlParser;
   //BOOL elementFound;

    
}

@end

@implementation OLYCoreViewController



-(void) viewDidLoad
{
    [super viewDidLoad];
    // self.view.backgroundColor = [UIColor lightGrayColor];
       //self.navigationController.toolbarHidden = YES;
     self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
 

    //UIBarButtonItem *homeButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"dollar.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(showHome)];
    
   
    UIBarButtonItem *homeButton = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStyleBordered target:self action:@selector(showHome:)];
    
    
    self.navigationItem.rightBarButtonItem = homeButton;
  
  
    
}




- (void) showHome:(UIBarButtonItem *)sender
{
    [self.navigationController popToViewController: [self.navigationController.viewControllers objectAtIndex: 1] animated: YES];
}


-(IBAction)cancelAndDismiss:(id)sender
{
    NSLog(@"Cancel");
    [self dismissViewControllerAnimated:YES completion:^{
        //view controller dismiss animation completed
    }];
}

- (IBAction)saveAndDismiss:(id)sender
{
    NSLog(@"Save");
    [self dismissViewControllerAnimated:YES completion:^{
        //view controller dismiss animation completed
    }];
}

- (IBAction)logOut:(id)sender
{
    exit(0);
    //[[UIApplication sharedApplication] terminate] ;
}


- (IBAction)HomeViewClick:(id)sender
{
    
    [self.navigationController popToViewController: [self.navigationController.viewControllers objectAtIndex: 1] animated: YES];

}



//====================================

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [self.ResponseData setLength:0];
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    [self.ResponseData appendData:data];
}



- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:@"Connection Error..."
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    
    [alert show];
    
}



- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    xmlParser = [[NSXMLParser alloc] initWithData: self.ResponseData];
    [xmlParser setDelegate:self];
    [xmlParser setShouldResolveExternalEntities:YES];
    [xmlParser parse];
}

//---when the start of an element is found---
-(void) parser:(NSXMLParser *) parser didStartElement:(NSString *) elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *) qName attributes:(NSDictionary *)attributeDict {
    
    //GetClientAccountsInfoResult
    if( [elementName isEqualToString:[NSString stringWithFormat:@"%@Result", self.MethodName]])
    {
        if (!self.SoapResults)
        {
            self.SoapResults = [[NSMutableString alloc] init];
        }
        self.ElementFound = YES;
    }
}


-(void)parser:(NSXMLParser *) parser foundCharacters:(NSString *)string
{
    if (self.ElementFound)
    {
        [self.SoapResults appendString: string];
    }
}






@end
