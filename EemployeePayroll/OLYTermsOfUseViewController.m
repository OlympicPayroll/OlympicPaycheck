//
//  OLYTermsAndConditionsViewController.m
//  Olympic Pay
//
//  Created by Ares Vlahos on 7/7/14.
//  Copyright (c) 2014 Reynante Sabud. All rights reserved.
//

#import "OLYTermsOfUseViewController.h"

@implementation OLYTermsOfUseViewController

-(void)loadDocument:(NSString*)documentName inView:(UIWebView*)webView
{
    NSString *path = [[NSBundle mainBundle] pathForResource:documentName ofType:nil];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.title =@"Terms of Use Agreement";
    self.navigationItem.rightBarButtonItem = nil;
    
    [self loadDocument:@"TermsOfUse.rtf" inView:self.myWebView];
}

- (IBAction)btnBack:(id)sender{
    
    OLYPrivacyPolicyViewController *nextViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PrivacyPolicy"];
    [self.navigationController pushViewController:nextViewController animated:YES];
    
    
}

- (IBAction)btnDone:(id)sender{
    
    OLYLoginViewController *nextViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Login"];
    [self.navigationController pushViewController:nextViewController animated:YES];
    
    
}

@end
