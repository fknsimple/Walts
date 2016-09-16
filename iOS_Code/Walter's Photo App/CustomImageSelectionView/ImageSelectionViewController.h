//
//  ImageSelectionViewController.h
//  Walter's Automotive
//
//  Created by Administrator on 4/11/16.
//  Copyright © 2016 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLImageEditor.h"

@interface ImageSelectionViewController : UIViewController<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *frameImageView;
@property (weak, nonatomic) IBOutlet UIButton *btnDone;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (strong, nonatomic) UIImage *selectedImage;
@property (weak, nonatomic) IBOutlet UILabel *lblMoveAndScale;

- (IBAction)btnCancel_Clicked:(id)sender;
- (IBAction)btnDone_Clicked:(id)sender;

@end
