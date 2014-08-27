//
//  OLYPrivacyPolicyViewController.m
//  Olympic Pay
//
//  Created by Ares Vlahos on 5/30/14.
//  Copyright (c) 2014 Reynante Sabud. All rights reserved.
//

#import "OLYPrivacyPolicyViewController.h"


@interface OLYPrivacyPolicyViewController ()

@end

@implementation OLYPrivacyPolicyViewController


-(void)loadDocument:(NSString*)documentName inView:(UIWebView*)webView {
    NSString *path = [[NSBundle mainBundle] pathForResource:documentName ofType:nil];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.title =@"Privacy Policy";
    self.navigationItem.rightBarButtonItem = nil;
    
    [self loadDocument:@"PrivacyPolicy.rtf" inView:self.myWebView];
}

- (IBAction)btnNext:(id)sender{
    
    OLYTermsOfUseViewController *nextViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TermsOfUse"];
    [self.navigationController pushViewController:nextViewController animated:YES];
    
    
}

- (IBAction)btnDone:(id)sender{
    
    OLYLoginViewController *nextViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Login"];
    [self.navigationController pushViewController:nextViewController animated:YES];
    
    
}

@end
