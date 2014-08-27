//
//  OLYCurrentPayrollYTD.h
//  EemployeePayroll
//
//  Created by Reynante Sabud on 4/8/14.
//  Copyright (c) 2014 Reynante Sabud. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "OLYCoreViewController.h"

@interface OLYCurrentPayrollViewControllerYTD : OLYCoreViewController<UITableViewDelegate, UITableViewDataSource>




@property (weak, nonatomic) IBOutlet UILabel *lblEmpName;
@property (weak, nonatomic) IBOutlet UILabel *lblCompName;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic, strong)  NSMutableDictionary *EmailDetails ;

@property (nonatomic) NSInteger RecordNumber;

@property (nonatomic, strong) NSString *EmpName;
@property (nonatomic, strong) NSString *CompName;
@end
