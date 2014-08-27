//
//  OLYCheckListPreviousPayroll.h
//  EemployeePayroll
//
//  Created by Reynante Sabud on 5/6/14.
//  Copyright (c) 2014 Reynante Sabud. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "OLYCoreViewController.h"

@interface OLYCheckListPreviousPayroll : OLYCoreViewController<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblCompName;
@property (weak, nonatomic) IBOutlet UILabel *lblMonth;
@property (weak, nonatomic) IBOutlet UILabel *lblYear;
@property (weak, nonatomic) IBOutlet UILabel *lblHours;


@property(nonatomic, strong) NSMutableDictionary *Checklists ;
@property(nonatomic, strong) NSString *ClientAccountID;
@property(nonatomic, strong) NSString *EmpID;
@property(nonatomic, strong) NSString *EmpName;
@property(nonatomic, strong) NSString *CompName;
@property(nonatomic, strong) NSString *CheckDate;
@property(nonatomic, strong) NSString *PickYear;
@property (weak, nonatomic) NSString *CheckDateString;
//@property (nonatomic) BOOL IsCombined;


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;



@end
