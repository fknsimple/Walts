//
//  CustomerInformationViewController.h
//  Walter's Photo App
//
//  Created by Apple on 30/11/15.
//  Copyright © 2015 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomerInformationViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *firstname;
- (IBAction)Settingbtn:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *lastname;
@property (weak, nonatomic) IBOutlet UITextField *email;
- (IBAction)gohome:(id)sender;

- (IBAction)cancelbtn:(id)sender;

- (IBAction)submitbtn:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *firstnameimg;
@property (weak, nonatomic) IBOutlet UIButton *submit;
@property (weak, nonatomic) IBOutlet UIButton *cncelbtnn;

@property (weak, nonatomic) IBOutlet UIImageView *lstnmeimg;
@property (weak, nonatomic) IBOutlet UIImageView *emailimg;
@property (strong, nonatomic) NSString *getEmail,*username;











@end
