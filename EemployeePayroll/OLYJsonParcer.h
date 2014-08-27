//
//  OLYJsonParcer.h
//  EemployeePayroll
//
//  Created by Reynante Sabud on 9/6/13.
//  Copyright (c) 2013 Reynante Sabud. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OLYJsonParcer : NSObject

@property(nonatomic, weak) NSString *MethodName;

-(NSMutableDictionary *)GetWebReturnData  :(NSString *)soapMessage URL:(NSURL*) url;
@end
