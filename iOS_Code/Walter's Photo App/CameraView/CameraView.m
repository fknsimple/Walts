//
//  CameraView.m
//  Walter's Automotive
//
//  Created by Hardik Ajmeri on 09/02/16.
//  Copyright © 2016 Apple. All rights reserved.
//

#import "CameraView.h"
#import "CustomerInformationViewController.h"

@interface CameraView ()

@end

@implementation CameraView

#pragma mark - UIView Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    frameImageView.image = [UIImage imageWithData:[[NSUserDefaults standardUserDefaults] valueForKey:@"FRAMEIMAGE"]];;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = NO;
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    imagePicker.showsCameraControls = NO;

    imagePicker.view.frame = self.view.bounds;

    UIView *top = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, frameImageView.frame.origin.y)];
    top.backgroundColor = [UIColor blackColor];

    UIView *bottom = [[UIView alloc] initWithFrame:CGRectMake(0, frameImageView.frame.origin.y + frameImageView.frame.size.height, self.view.frame.size.width, 300)];
    bottom.backgroundColor = [UIColor blackColor];

    [self.view addSubview:imagePicker.view];
    [self.view addSubview:top];
    [self.view addSubview:bottom];
    [self.view bringSubviewToFront:frameImageView];
    [self.view bringSubviewToFront:controllView];

    previewView.clipsToBounds = YES;
}

#pragma mark - IBAction Methods
- (IBAction)ToggleCameraPressed:(id)sender {
    if (imagePicker.cameraDevice == UIImagePickerControllerCameraDeviceRear) {
        [UIView transitionWithView:imagePicker.view duration:1.0 options:UIViewAnimationOptionAllowAnimatedContent | UIViewAnimationOptionTransitionFlipFromLeft animations:^{
            imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        } completion:NULL];
    }
    else {
        [UIView transitionWithView:imagePicker.view duration:1.0 options:UIViewAnimationOptionAllowAnimatedContent | UIViewAnimationOptionTransitionFlipFromLeft animations:^{
            imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        } completion:NULL];
    }
}

- (IBAction)CapturePressed:(id)sender {
    [APPDELEGATE showGlobalProgressHUDWithTitle:@""];
    [imagePicker takePicture];
}

- (IBAction)CancelPressed:(id)sender {
    [imagePicker.view removeFromSuperview];
    [self dismissViewControllerAnimated:YES completion:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CameraCancelled" object:nil];
}

#pragma mark - UIImagePicker Delegate
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [imagePicker dismissViewControllerAnimated:YES completion:NULL];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *gotImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    //NSData *imageData = UIImageJPEGRepresentation(gotImage, 0.0);

    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[self imageByCroppingImage:gotImage] forKey:@"CapturedImage"];
    [userDefaults synchronize];


    [[NSNotificationCenter defaultCenter] postNotificationName:@"CapturedNotification" object:nil userInfo:info];
    [self performSelector:@selector(cancelButtonDidPush:) withObject:nil];
}

- (NSData *)imageByCroppingImage:(UIImage *)image
{
    UIImageView *addCapturedImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, previewView.frame.size.width, previewView.frame.size.height)];
    addCapturedImage.image = image;
    addCapturedImage.clipsToBounds = YES;
    addCapturedImage.contentMode = UIViewContentModeScaleAspectFill;
    [previewView addSubview:addCapturedImage];

    UIGraphicsBeginImageContextWithOptions(previewView.bounds.size, NO, 0.0);
    [previewView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *cropped = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    NSData *data = UIImagePNGRepresentation(cropped);

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];

    NSString *imagePath =[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",@"Camera"]];

    NSLog((@"pre writing to file"));
    if (![data writeToFile:imagePath atomically:NO])
    {
        NSLog(@"Failed to cache image data to disk");
    }
    else
    {
        NSLog(@"the cachedImagedPath is %@",imagePath);
    }
    [addCapturedImage removeFromSuperview];
    addCapturedImage = nil;
    return data;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if([navigationController isKindOfClass:[UIImagePickerController class]]){
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonDidPush:)];
    }
}

- (void)cancelButtonDidPush:(id)sender
{
    [APPDELEGATE dismissGlobalHUD];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Handle Memory Warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
