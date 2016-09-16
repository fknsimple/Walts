//
//  customViewController1.h
//  Walter's Photo App
//
//  Created by Apple on 01/12/15.
//  Copyright © 2015 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLImageEditor.h"

@interface customViewController1 : UIViewController <UIImagePickerControllerDelegate , UINavigationControllerDelegate>
{
    BOOL image;
    BOOL image1;
    NSString *filename;
    
    UIImagePickerController * imagePicker;
    UIImage *selectedImage, *thumbImage;
    UIImage *minithumbImage;

    //IBOutlet UIScrollView *_scrollView;
    IBOutlet UIImageView *_imageView;
    IBOutlet UIImageView *frameImageView;

    BOOL isFirstTime;
    BOOL isFromConfirm;
    BOOL isFromSettings;

}

@property (assign, nonatomic)   BOOL isFromCamera;
@property (strong, nonatomic)   NSData *imagedata;
@property (strong, nonatomic)   UIImage *getImage;
@property (weak, nonatomic) NSString *getEmail,*getUsrname;
@property (strong, nonatomic) UIImage *originalImage;
@property (weak, nonatomic) IBOutlet UIImageView *blankimg;

@property (strong,nonatomic)    UIImagePickerController *picker;
@property (nonatomic) UIImage *capturedImage;

- (IBAction)goback:(id)sender;
- (IBAction)gophotoclassbtn:(id)sender;
- (IBAction)gohomebtn:(id)sender;
- (IBAction)settingbtn:(id)sender;
- (IBAction)gobackphotobtn:(id)sender;

@end
