//
//  OLYCoreViewController.h
//  EemployeePayroll
//
//  Created by Reynante Sabud on 7/31/13.
//  Copyright (c) 2013 Reynante Sabud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OLYCoreViewController : UIViewController< NSXMLParserDelegate>
{
    


}


//@property (nonatomic, strong)NSURL *Url;
//@property(nonatomic, weak) NSString *SoapMessage;


-(IBAction)cancelAndDismiss:(id)sender;
-(IBAction)saveAndDismiss:(id)sender;

@property(nonatomic, strong) NSString *MethodName;
@property (nonatomic) BOOL ElementFound;
@property(nonatomic, strong) NSMutableData *ResponseData;
@property(nonatomic, strong) NSMutableString *SoapResults;
@property(nonatomic, strong) NSString *TokenID;

//@property(nonatomic, strong) UIActivityIndicatorView *Spinner;

@end
