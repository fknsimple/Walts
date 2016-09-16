//
//  SettingViewController.h
//  Walter's Automotive
//
//  Created by ATPL on 12/8/15.
//  Copyright © 2015 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingViewController : UIViewController
- (IBAction)gohome:(id)sender;
- (IBAction)changepasswordbtn:(id)sender;

- (IBAction)circlebtn1:(id)sender;
- (IBAction)circlebtn2:(id)sender;
- (IBAction)boxbtn1:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *bixbtn2;
- (IBAction)boxbtn2:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *cirimg1;
@property (weak, nonatomic) IBOutlet UIImageView *cirimg2;
@property (weak, nonatomic) IBOutlet UIImageView *boximg1;
@property (weak, nonatomic) IBOutlet UIImageView *boximg2;

- (IBAction)logout:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *logbtn;
- (IBAction)termandcondition:(id)sender;

@property (strong, nonatomic) IBOutlet UIImageView *imgBackArrow;
@property (strong, nonatomic) IBOutlet UIButton *btnBackArrow;
@property (nonatomic, assign) BOOL boolIsBackArrowRequired;
@property (strong, nonatomic) IBOutlet UIImageView *imgHome;
@property (strong, nonatomic) IBOutlet UIButton *btnHome;
@property (strong, nonatomic) IBOutlet UILabel *lblHome;

@end
