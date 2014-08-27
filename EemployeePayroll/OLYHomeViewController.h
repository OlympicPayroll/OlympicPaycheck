//
//  OLYHomeViewController.h
//  EemployeePayroll
//
//  Created by Reynante Sabud on 7/31/13.
//  Copyright (c) 2013 Reynante Sabud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OLYCoreViewController.h"

@interface OLYHomeViewController : OLYCoreViewController <UITableViewDelegate, UITableViewDataSource>

{
    
    
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblCompName;
//@property (weak, nonatomic) IBOutlet UIImageView *imgBanner;
@property (weak, nonatomic) IBOutlet UILabel *lblYear;


@property(nonatomic,strong) NSArray *CheckData;

@property(nonatomic, strong) NSString *PickYear;
@property(nonatomic, strong) NSString *ClientAccountID;
@property(nonatomic, strong) NSString *EmpID;
@property(nonatomic, strong) NSString *EmpName;
@property(nonatomic,strong) NSString *CompName;


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;


@end
