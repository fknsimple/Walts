//
//  ViewController.h
//  Walter's Photo App
//
//  Created by Apple on 30/11/15.
//  Copyright © 2015 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *usernameTxt;
@property (weak, nonatomic) IBOutlet UITextField *passwordTxt;

- (IBAction)signinbtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *usernameimg;
@property (weak, nonatomic) IBOutlet UIImageView *passwordimg;

@property (weak, nonatomic) IBOutlet UIButton *signbtn;
- (IBAction)ForgotPasswordBtn:(id)sender;
- (IBAction)helpBtn:(id)sender;


@end

