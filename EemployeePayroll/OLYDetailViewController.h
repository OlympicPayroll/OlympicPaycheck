//
//  OLYDetailViewController.h
//  EemployeePayroll
//
//  Created by Reynante Sabud on 7/31/13.
//  Copyright (c) 2013 Reynante Sabud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OLYCoreViewController.h"

@interface OLYDetailViewController : OLYCoreViewController<UITableViewDelegate, UITableViewDataSource>
{
    
    
}
//@property (weak, nonatomic) IBOutlet UILabel *lblEmpName;
//@property (weak, nonatomic) IBOutlet UILabel *lblCompName;
//@property (weak, nonatomic) IBOutlet UIImageView *imgDollar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

//@property (weak, nonatomic) IBOutlet UILabel *lblYear;
//@property (weak, nonatomic) IBOutlet UILabel *lblMonth;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;

@property (weak, nonatomic) IBOutlet UILabel *lblNet;
@property (weak, nonatomic) IBOutlet UILabel *lblCheckNo;
@property (weak, nonatomic) IBOutlet UILabel *lblPaytype;
@property (weak, nonatomic) IBOutlet UIImageView *imgBanner;

//@property(nonatomic,strong) NSString *EmpName;
//@property(nonatomic,strong) NSString *CompName;


@property (nonatomic, strong) NSMutableDictionary *HistoryData;
@property (nonatomic, strong) NSString *ClientAccountID;
//@property (nonatomic, strong) NSString *HistoryID;
@property (nonatomic, strong) NSString *CheckDate;
//@property (nonatomic, strong) NSString *NetPay;



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;






@end
