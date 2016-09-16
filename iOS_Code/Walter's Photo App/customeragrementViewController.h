//
//  customeragrementViewController.h
//  Walter's Photo App
//
//  Created by Apple on 01/12/15.
//  Copyright © 2015 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface customeragrementViewController : UIViewController
- (IBAction)goback:(id)sender;
- (IBAction)signbtn:(id)sender;
- (IBAction)declinebtn:(id)sender;
- (IBAction)gohome:(id)sender;
- (IBAction)settingbtn:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *decbtn;

@property (weak, nonatomic) IBOutlet UIButton *signbtn;
@property (weak, nonatomic) IBOutlet UIScrollView *scrol;

@property (nonatomic,retain) UIImage *resultingImage;
@property (retain, nonatomic) NSString *emailid, *getUsername, *companyId;

@property (strong, nonatomic) IBOutlet UIButton *btnBack;
@property (strong, nonatomic) IBOutlet UIImageView *imgBack;
@property (strong, nonatomic) IBOutlet UIButton *btnHome;
@property (nonatomic,assign) BOOL boolIsBackArrowRequired;
@property (strong, nonatomic) IBOutlet UIImageView *imgHome;
@property (strong, nonatomic) IBOutlet UILabel *lblAgreement;

@end
