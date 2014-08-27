//
//  OLYCheckListViewController.h
//  EemployeePayroll
//
//  Created by Reynante Sabud on 4/24/14.
//  Copyright (c) 2014 Reynante Sabud. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "OLYCoreViewController.h"

@interface OLYCheckListViewController : OLYCoreViewController<UITableViewDelegate, UITableViewDataSource>
{
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblCompName;
@property (weak, nonatomic) IBOutlet UILabel *lblMonth;
@property (weak, nonatomic) IBOutlet UILabel *lblYear;

@property(nonatomic) NSInteger RecordNumber;
@property(nonatomic, strong) NSMutableDictionary *EmailDetails ;
@property(nonatomic, strong) NSString *HistoryID;
@property(nonatomic, strong) NSString *EmpID;
@property(nonatomic, strong) NSString *EmpName;
@property(nonatomic, strong) NSString *CompName;
//@property(nonatomic, strong) NSArray *CheckList;
@property (weak, nonatomic) NSString *PayDate;

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
