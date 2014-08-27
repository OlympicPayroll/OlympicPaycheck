//
//  OLYPayTypeViewController2.h
//  EemployeePayroll
//
//  Created by Reynante Sabud on 4/17/14.
//  Copyright (c) 2014 Reynante Sabud. All rights reserved.
//

#import "OLYCoreViewController.h"

@interface OLYPayTypeViewController2 : OLYCoreViewController

@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

@property (weak, nonatomic) UILabel *lblCompName;
@property (weak, nonatomic) UILabel *lblName;

@property (weak, nonatomic) IBOutlet UILabel *lblCheckDate;

@property (weak, nonatomic) IBOutlet UILabel *lblInformation;

@property (nonatomic, strong) NSString *HistoryID;

@property (nonatomic, strong) IBOutlet UIView *logOutView;

@property (weak, nonatomic) IBOutlet UIImageView *EmployeePhoto;
@property (weak, nonatomic) IBOutlet UIImageView *NewImg;

@property(nonatomic, strong) NSString *EmpID;
@property (nonatomic, strong) NSString *EmpName;
@property(nonatomic, strong) NSString *ClientAccountID;
@property(nonatomic, strong) NSString *CompName;
//@property(nonatomic) BOOL *IsRead;

@property (weak, nonatomic) IBOutlet UIButton *btnLatestPayroll;
@property (weak, nonatomic) IBOutlet UIButton *btnPreviousPayroll;

- (IBAction)BtnLatestPayrollClick:(id)sender;

- (IBAction)PreviousPayrollClick:(id)sender;

- (IBAction)BtnGrabPhotoClick:(id)sender;

@end
