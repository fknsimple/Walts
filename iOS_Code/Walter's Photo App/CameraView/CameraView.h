//
//  CameraView.h
//  Walter's Automotive
//
//  Created by Hardik Ajmeri on 09/02/16.
//  Copyright © 2016 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLImageEditor.h"
#import "UIImageView+WebCache.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"

@interface CameraView : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLImageEditorDelegate, CLImageEditorTransitionDelegate, CLImageEditorThemeDelegate>
{
    IBOutlet UIView *previewView;
    IBOutlet UIView *controllView;
    IBOutlet UIImageView *frameImageView;

    IBOutlet UIButton *btnToggleCamera;
    IBOutlet UIButton *btnCapture;
    IBOutlet UIButton *btnCancel;

    BOOL isToggle;
    UIImagePickerController *imagePicker;
}

- (IBAction)ToggleCameraPressed:(id)sender;
- (IBAction)CapturePressed:(id)sender;
- (IBAction)CancelPressed:(id)sender;

@end
