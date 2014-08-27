//
//  OLYPhotoGrabber.h
//  EemployeePayroll
//
//  Created by Reynante Sabud on 7/1/14.
//  Copyright (c) 2014 Reynante Sabud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OLYCoreViewController.h"

@interface OLYPhotoGrabber : OLYCoreViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
 {
   // IBOutlet UIButton *button;
   // IBOutlet UIImageView *image;
    //UIImagePickerController *imgPicker;
}

@property (weak, nonatomic) IBOutlet UILabel *lblCompName;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UIImageView *EmpPhoto;
@property(nonatomic, strong) NSString *EmpID;


//- (IBAction)grabImage;
//@property (weak, nonatomic) IBOutlet UIButton *grabImage;
- (IBAction)GrabImage:(id)sender;
-(IBAction)SelectPhoto:(id)sender;


@property (nonatomic, retain) UIImagePickerController *imgPicker;
@property (nonatomic, strong) NSString *EmpName;
@property(nonatomic, strong) NSString *CompName;
@end

