//
//  OLYClientInfoViewController.h
//  EemployeePayroll
//
//  Created by Reynante Sabud on 9/5/13.
//  Copyright (c) 2013 Reynante Sabud. All rights reserved.
//
#import "OLYCoreViewController.h"

#import <UIKit/UIKit.h>


@interface OLYClientInfoViewController: OLYCoreViewController<UITableViewDelegate, UITableViewDataSource>
{
    
}





@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) NSMutableDictionary *CompanyInfo;
@property (nonatomic,strong) NSString *LatestPayrollID;
@property (weak, nonatomic) IBOutlet UILabel *Name;
@property (weak, nonatomic) IBOutlet UIImageView *imgBanner;


@property(nonatomic, strong) NSString *EmpName;

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;





@end
