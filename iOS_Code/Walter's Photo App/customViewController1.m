//
//  customViewController1.m
//  Walter's Photo App
//
//  Created by Apple on 01/12/15.
//  Copyright © 2015 Apple. All rights reserved.
//

#import "customViewController1.h"
#import "SettingViewController.h"
#import "phottoooViewController.h"
#import "CustomerInformationViewController.h"
#import "ViewController.h"
#import "PhotoSelectionViewController.h"
#import <CoreImage/CoreImage.h>
#import "UIImage+FiltrrCompositions.h"
#import "UIImage+Scale.h"
#import "ImageCollectionViewCell.h"
#import "CLImageEditor.h"
#import "Plugins/SDWebImage/UIImageView+WebCache.h"
#import "Plugins/SDWebImage/UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "CameraView/CameraView.h"
#import "ImageSelectionViewController.h"


@interface customViewController1 () <CLImageEditorDelegate, CLImageEditorTransitionDelegate, CLImageEditorThemeDelegate>
{
    CLImageEditor *myEditor;
}
@end

@implementation customViewController1

#pragma mark - UIView Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    isFirstTime = true;
    // Do any additional setup after loading the view.
    isFromConfirm = false;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callPicker) name:@"CapturedNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backFromCamera) name:@"CameraCancelled" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backFromConfirm) name:@"BackFromConfirm" object:nil];

    image = true;
    image1 = true;

    frameImageView.image = [UIImage imageWithData:[[NSUserDefaults standardUserDefaults] valueForKey:@"FRAMEIMAGE"]];
    frameImageView.hidden = YES;

    [self.navigationController setNavigationBarHidden:YES];
    _picker = [[UIImagePickerController alloc]init];
    _picker.delegate=self;
    //_picker.allowsEditing=YES;

    if (self.isFromCamera) {
        //For Camera
        CameraView *objCameView = [[CameraView alloc] initWithNibName:@"CameraView" bundle:nil];
        [self presentViewController:objCameView animated:YES completion:nil];
    }
    else {
        _picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

        [_picker.navigationBar setTintColor:[UIColor whiteColor]];
        [_picker.navigationBar setBarTintColor:[UIColor blackColor]];
        [_picker.navigationBar setTranslucent:NO];
        [_picker.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
        
        [self presentViewController:_picker animated:YES completion:NULL];

    }

    selectedImage = [UIImage imageNamed:@"filtrr_back.jpg"];
    thumbImage = [selectedImage scaleToSize:CGSizeMake(720, 720)];
    minithumbImage = [thumbImage scaleToSize:CGSizeMake(320, 320)];
 }


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];

    if (!isFromConfirm && !isFirstTime && !isFromSettings) {
        [self.navigationController popViewControllerAnimated:YES];
    }

    if (isFromConfirm) {
        _imageView.image = [UIImage imageWithData:[[NSUserDefaults standardUserDefaults] valueForKey:@"IMAGE"]];
        frameImageView.image = [UIImage imageWithData:[[NSUserDefaults standardUserDefaults] valueForKey:@"FRAMEIMAGE"]];
        frameImageView.hidden = NO;
        
        if (self.isFromCamera) {
            //For Camera
            [self performSelector:@selector(callPicker) withObject:nil];
        }
        else {
            myEditor = [[CLImageEditor alloc] initWithImage:_imageView.image];
            myEditor.delegate = self;
            [self presentViewController:myEditor animated:YES completion:NULL];
        }
    }
    else
    {
        if(self.isFromCamera == false)
        {
            _imageView.image = [UIImage imageWithData:[[NSUserDefaults standardUserDefaults] valueForKey:@"IMAGE"]];
        }
    }
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    isFirstTime = false;
    isFromConfirm = false;
}

- (void)backFromConfirm {
    isFromConfirm = YES;
}

- (void)callPicker {
    frameImageView.hidden = NO;

    self.capturedImage = [UIImage imageWithData:[[NSUserDefaults standardUserDefaults] valueForKey:@"CapturedImage"]];

    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"FRAMEIMAGE"] != nil) {
        if (isFromConfirm) {
            myEditor = [[CLImageEditor alloc] initWithImage:_imageView.image];
        }
        else {
            myEditor = [[CLImageEditor alloc] initWithImage:self.capturedImage];
        }
        frameImageView.image = [UIImage imageWithData:[[NSUserDefaults standardUserDefaults] valueForKey:@"FRAMEIMAGE"]];
        myEditor.delegate = self;
        [self.navigationController pushViewController:myEditor animated:YES];
    }
    else {
        NSLog(@"Failed to save image to user defaults");
    }
}

- (void)backFromCamera {
    frameImageView.hidden = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark- ImagePicker delegate
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    frameImageView.hidden = YES;
    [_picker dismissViewControllerAnimated:YES completion:NULL];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if (isFromConfirm) {
        myEditor = [[CLImageEditor alloc] initWithImage:_imageView.image];
        myEditor.delegate = self;
        [picker pushViewController:myEditor animated:YES];
    }
    else {
        frameImageView.hidden = NO;
        UIImage *gotImage = [info objectForKey:UIImagePickerControllerOriginalImage];

        UIView *viewForImage = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frameImageView.frame.size.width, frameImageView.frame.size.height)];
        viewForImage.clipsToBounds = YES;
        UIImageView *newImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, viewForImage.frame.size.width, viewForImage.frame.size.height)];
        newImage.clipsToBounds = YES;
        newImage.contentMode = UIViewContentModeScaleAspectFill;
        newImage.image = gotImage;
        [viewForImage addSubview:newImage];

        UIGraphicsBeginImageContextWithOptions(viewForImage.bounds.size, NO, 0.0);
        [viewForImage.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *cropped = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();

        NSData *imageData = UIImagePNGRepresentation(cropped);
        UIImage *img = [UIImage imageWithData:imageData];

        //myEditor = [[CLImageEditor alloc] initWithImage:img];

        [viewForImage removeFromSuperview];
        [newImage removeFromSuperview];
        newImage = nil;
        viewForImage = nil;
        
        ImageSelectionViewController *imgSelVC = [[ImageSelectionViewController alloc]init];
        [imgSelVC setSelectedImage:img];
        isFirstTime = true;
        isFromConfirm = false;
        [picker pushViewController:imgSelVC animated:YES];
        
        //myEditor.delegate = self;
        //[picker pushViewController:myEditor animated:YES];
    }
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if([navigationController isKindOfClass:[UIImagePickerController class]] && [viewController isKindOfClass:[CLImageEditor class]]){
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonDidPush:)];
    }
}

- (void)cancelButtonDidPush:(id)sender
{
    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark- CLImageEditor delegate
- (void)imageEditor:(CLImageEditor *)editor didFinishEdittingWithImage:(UIImage *)editedImage
{
    isFirstTime = true;
    _imageView.image = editedImage;
    frameImageView.hidden = NO;

    if (self.isFromCamera) {
        [editor.navigationController setNavigationBarHidden:YES];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        [editor dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)imageEditor:(CLImageEditor *)editor willDismissWithImageView:(UIImageView *)imageView canceled:(BOOL)canceled
{
    if (self.isFromCamera) {
        [editor.navigationController setNavigationBarHidden:YES];
    }
    frameImageView.hidden = NO;
}

- (void)imageEditorDidCancel:(CLImageEditor *)editor {
    frameImageView.hidden = NO;
    [editor.navigationController setNavigationBarHidden:YES];
    [editor dismissViewControllerAnimated:YES completion:nil];

//    if (isFromConfirm) {
//        [editor dismissViewControllerAnimated:YES completion:^{
//            [self.navigationController popViewControllerAnimated:YES];
//        }];
//    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - IBActions
- (IBAction)goback:(id)sender
{
     [self.navigationController setNavigationBarHidden:YES];
//     [self.navigationController popViewControllerAnimated:YES];
    if (self.isFromCamera) {
        CameraView *objCameView = [[CameraView alloc] initWithNibName:@"CameraView" bundle:nil];
        [self presentViewController:objCameView animated:YES completion:nil];
    }
    else {
        _picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [_picker.navigationBar setTintColor:[UIColor whiteColor]];
        [_picker.navigationBar setBarTintColor:[UIColor blackColor]];
        [_picker.navigationBar setTranslucent:NO];
        [_picker.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    }
    [self presentViewController:_picker animated:YES completion:NULL];
}

- (IBAction)gophotoclassbtn:(id)sender
{
    self.imagedata = UIImageJPEGRepresentation(_imageView.image, 0.6);
    [[NSUserDefaults standardUserDefaults] setObject:self.imagedata forKey:@"IMAGE"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    phottoooViewController *dash = (phottoooViewController *)[storyboard instantiateViewControllerWithIdentifier:@"Photo"];
    //dash.Getimagedata = self.imagedata;
    dash.emailid = self.getEmail;
    dash.getUsername = self.getUsrname;
    [self.navigationController pushViewController:dash animated:YES];
}

- (IBAction)gohomebtn:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PhotoSelectionViewController *dash = (PhotoSelectionViewController *)[storyboard instantiateViewControllerWithIdentifier:@"Selection"];
    [self.navigationController pushViewController:dash animated:YES];
}

- (IBAction)gobackphotobtn:(id)sender
{
    if (self.isFromCamera) {
        CameraView *objCameView = [[CameraView alloc] initWithNibName:@"CameraView" bundle:nil];
        [self presentViewController:objCameView animated:YES completion:nil];
    }
    else {
        _picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [_picker.navigationBar setTintColor:[UIColor whiteColor]];
        [_picker.navigationBar setBarTintColor:[UIColor blackColor]];
        [_picker.navigationBar setTranslucent:NO];
        [_picker.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    }
    [self presentViewController:_picker animated:YES completion:NULL];
}

- (IBAction)settingbtn:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SettingViewController *dash = (SettingViewController *)[storyboard instantiateViewControllerWithIdentifier:@"Setting"];
    dash.boolIsBackArrowRequired = true;
    isFromSettings = true;
    [self.navigationController pushViewController:dash animated:YES];
}

#pragma mark- ScrollView

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageView.superview;
}

#pragma mark - Camera IBAction Methods

#pragma mark - Handle Memory Warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
