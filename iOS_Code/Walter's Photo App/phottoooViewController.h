//
//  phottoooViewController.h
//  Walter's Automotive
//
//  Created by ATPL on 12/4/15.
//  Copyright © 2015 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomLabel.h"

@interface phottoooViewController : UIViewController
{
    IBOutlet UIView *wrapperImageView;
    IBOutlet UILabel *lblCompanyName;
}

@property (weak, nonatomic) IBOutlet UIImageView *img22;
- (IBAction)settingbtn:(id)sender;
- (IBAction)backkbtn:(id)sender;
- (IBAction)goobackbtn:(id)sender;
- (IBAction)gohome:(id)sender;
- (IBAction)goagrementbtn:(id)sender;
@property (strong, nonatomic) NSData *Getimagedata, *getProfileImage;

@property (weak, nonatomic) IBOutlet UIImageView *imageview;
- (IBAction)retakebtn:(id)sender;
@property (weak, nonatomic) NSString *emailid, *getUsername, *companyId;
@property (weak, nonatomic) IBOutlet UILabel *txtName;
@property (weak, nonatomic) IBOutlet UILabel *txtContact;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (strong, nonatomic) IBOutlet UIView *shadowView;
@property (strong, nonatomic) IBOutlet UIImageView *imgWalterLogo;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *trailingConstraint_shadowView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint_shadowView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *leadingConstraint_shadowView;

@end
