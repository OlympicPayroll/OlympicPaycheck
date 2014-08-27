//
//  OLYYearListsViewController.h
//  EemployeePayroll
//
//  Created by Reynante Sabud on 3/25/14.
//  Copyright (c) 2014 Reynante Sabud. All rights reserved.
//
#import "OLYCoreViewController.h"
#import <UIKit/UIKit.h>
//UIViewController<UITableViewDelegate, UITableViewDataSource,UITabBarControllerDelegate, UITabBarDelegate>
//@interface OLYYearListsViewController: UIViewController<UITableViewDelegate, UITableViewDataSource,UITabBarControllerDelegate, UITabBarDelegate>
//{
//}
//<UIApplicationDelegate, UITabBarDelegate, UITabBarControllerDelegate>
@interface OLYYearListsViewController :OLYCoreViewController<UITableViewDelegate, UITableViewDataSource>
{
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *Name;
@property (weak, nonatomic) IBOutlet UILabel *Company;

@property(nonatomic, copy) NSArray *rightBarButtonItems;

//@property (assign) int HomeScreenIndex;
@property(nonatomic, strong) NSString *EmpID;
@property(nonatomic, strong) NSString *EmpName;
@property(nonatomic, strong) NSString *ClientAccountID;
@property(nonatomic, strong) NSString *CompName;
@property(nonatomic, strong) NSArray *YearList;

@end
