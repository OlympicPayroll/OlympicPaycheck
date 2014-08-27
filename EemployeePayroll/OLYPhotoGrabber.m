//
//  OLYPhotoGrabber.m
//  EemployeePayroll
//
//  Created by Reynante Sabud on 7/1/14.
//  Copyright (c) 2014 Reynante Sabud. All rights reserved.
//

#import "OLYPhotoGrabber.h"
#import "OLYSoapMessages.h"
@implementation OLYPhotoGrabber

{
  UIActivityIndicatorView *spinner;
}

- (void)viewDidLoad {
    self.imgPicker = [[UIImagePickerController alloc] init];
    self.imgPicker.allowsEditing = YES;
    self.imgPicker.delegate = self;
    self.imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.navigationController.navigationBar.hidden = NO;
    self.lblName.text = self.EmpName;
    self.lblCompName.text = self.CompName;

    
    NSURL *url = [NSURL URLWithString:
                  [NSString stringWithFormat:@"%@%@", @"https://myolympicpay.com/DownloadPhotos.ashx?EmpID=",self.EmpID]];
    

    UIImage *img = [self downloadImage:url ImageScale:2.0];
  
   
    if(img ==nil)
         img = [UIImage imageNamed:@"emptyPhoto.jpg"];
    
    self.EmpPhoto.image = img;
  
    
    
}

-(UIImage*)downloadImage:(NSURL*)imageURL ImageScale:(CGFloat) imgScale{
    
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    return [UIImage imageWithData:imageData scale:imgScale];
    
    //return image;
}



-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)img editingInfo:(NSDictionary *)editInfo
{
    
    self.EmpPhoto.image = img;
    
    
   [self EncodeToBase64String:img];
 
    //PrepareJpegImageRequest
    [self dismissModalViewControllerAnimated:YES];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
   // [self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}




- (IBAction)GrabImage:(id)sender {
    
    if(![self detectCamera])
    {
      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                           message:@"There is no Camera Installed."
                                          delegate:nil
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
        
        [alert show];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    
    
    UIImagePickerController * imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.delegate = self;
   
    [self presentViewController:imagePicker animated:YES completion:nil];
 
}




- (BOOL) detectCamera {
    BOOL cameraAvailable =  [UIImagePickerController   isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    
    return cameraAvailable ? YES : NO;
}


-(IBAction)SelectPhoto:(id)sender;
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
   [self presentViewController:imagePicker animated:YES completion:nil];
}


-(NSData *)getStringFromImage:(UIImage *)image{

		return UIImagePNGRepresentation(image);


}


-(void)EncodeToBase64String: (UIImage*) image
{
    
    OLYSoapMessages *objSoapMsg =[OLYSoapMessages new];
    
    self.MethodName = @"InsertBase64Photo";

    NSString* base64String = [UIImageJPEGRepresentation(image, 0.5) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    [objSoapMsg InsertBase64Photo:self.EmpID Base64String:base64String MethodName:self.MethodName];
    
    [self FireRequest: objSoapMsg.UrlRequest];
}



-(void)FireRequest :(NSMutableURLRequest*)urlRequest
{
    
    
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.center = CGPointMake(160, 240);
    [self.view addSubview:spinner];
    [spinner startAnimating];
    
    //Fire away.
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    
    if (theConnection)
    {
        self.ResponseData = [NSMutableData data];
        [spinner stopAnimating];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"Failed connection."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        
        [alert show];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    
}



@end
