//
//  OLYLoginViewController.h
//  EemployeePayroll
//
//  Created by Reynante Sabud on 7/31/13.
//  Copyright (c) 2013 Reynante Sabud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OLYCoreViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "OLYAppDelegate.h"

@interface OLYLoginViewController : OLYCoreViewController  <UITextFieldDelegate, UIAlertViewDelegate> {
    
}
@property (retain, nonatomic) IBOutlet UITextField *txtSSN;
@property (retain, nonatomic) IBOutlet UITextField *txtEmaiAddress;
@property (retain, nonatomic) IBOutlet UITextField *txtFullSSN;

@property (retain, nonatomic) IBOutlet UILabel *lblName;

@property (retain, nonatomic) IBOutlet UILabel *lblWelcome;

@property (weak, nonatomic) IBOutlet UISwitch *retainUser;


- (IBAction)BtnLoginClick:(id)sender;
- (IBAction)btnPrivacyAndTerms:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton* btnNext;
@property (strong, nonatomic) IBOutlet UIButton* btnPrevious;

@end
