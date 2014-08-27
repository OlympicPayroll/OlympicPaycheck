//
//  OLYCurrentPayrollViewController1.h
//  EemployeePayroll
//
//  Created by Reynante Sabud on 4/1/14.
//  Copyright (c) 2014 Reynante Sabud. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "OLYCoreViewController.h"

@interface OLYCurrentPayrollViewControllerNet: OLYCoreViewController<UITableViewDelegate, UITableViewDataSource>


//@property (weak, nonatomic) IBOutlet UILabel *lblEmpName;
//@property (weak, nonatomic) IBOutlet UILabel *lblCompName;

//@property (weak, nonatomic) IBOutlet UIImageView *imgDollar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic, strong)  NSMutableDictionary *EmailDetails;
@property (weak, nonatomic) IBOutlet UILabel *lblNetValue;
@property (weak, nonatomic) IBOutlet UILabel *CheckVal;
@property (weak, nonatomic) IBOutlet UILabel *lblCheckNo;
//@property (weak, nonatomic) IBOutlet UILabel *lblYear;
//@property (weak, nonatomic) IBOutlet UILabel *lblMonth;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;

@property (nonatomic, strong) NSString *SentID;
@property (nonatomic) NSInteger RecordNumber;
@property(nonatomic, strong) NSString *NetValue;
@property (nonatomic, strong) NSString *PayDate;
@property (nonatomic, strong) NSString *EmpName;
@property (nonatomic, strong) NSString *CompName;

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;



@end
