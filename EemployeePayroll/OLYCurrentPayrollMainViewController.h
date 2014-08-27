//
//  OLYCurrentPayrollMainViewController.h
//  EemployeePayroll
//
//  Created by Reynante Sabud on 4/7/14.
//  Copyright (c) 2014 Reynante Sabud. All rights reserved.
//
#import "OLYCoreTabBarController.h"
#import <UIKit/UIKit.h>

@interface OLYCurrentPayrollMainViewController :OLYCoreTabBarController


@property (weak, nonatomic) IBOutlet UILabel *CheckVal;


@property(nonatomic, strong)  NSMutableDictionary *EmailDetails ;
@property(nonatomic, strong) NSString *NetValue;

@property (nonatomic)NSInteger RecordNumber;
@property (nonatomic, strong) NSString *PayDate;
@property (nonatomic, strong) NSString *EmpName;
@property(nonatomic, strong) NSString *CompName;

@end
