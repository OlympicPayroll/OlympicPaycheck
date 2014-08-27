//
//  OLYCoreTabBarController.h
//  EemployeePayroll
//
//  Created by Reynante Sabud on 5/14/14.
//  Copyright (c) 2014 Reynante Sabud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OLYCoreTabBarController : UITabBarController <UITabBarControllerDelegate, NSXMLParserDelegate>



@property(nonatomic, strong) NSString *MethodName;
@property (nonatomic) BOOL ElementFound;
@property(nonatomic, strong) NSMutableData *ResponseData;
@property(nonatomic, strong) NSMutableString *SoapResults;


@end
