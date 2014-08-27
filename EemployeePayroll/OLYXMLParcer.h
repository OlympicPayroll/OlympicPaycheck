//
//  OLYXMLParcer.h
//  EemployeePayroll
//
//  Created by Reynante Sabud on 9/11/13.
//  Copyright (c) 2013 Reynante Sabud. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OLYXMLParcer :   NSObject
{

}
@property NSString *ElementName;
@property NSString *RequestValue;

-(void)loadDataFromXML:(NSData*) data;



@end
