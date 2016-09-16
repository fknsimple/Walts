//
//  termconditionViewController.m
//  Walter's Automotive
//
//  Created by ATPL on 12/9/15.
//  Copyright © 2015 Apple. All rights reserved.
//

#import "termconditionViewController.h"
#import "SettingViewController.h"
#import "PhotoSelectionViewController.h"
@interface termconditionViewController ()

@end

@implementation termconditionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.isPrivacyPolicy) {
        self.lblTitle.text = @"Privacy Policy";
    }
    else {
        self.lblTitle.text = @"Terms and Conditions";
        NSMutableAttributedString *title = [[NSMutableAttributedString alloc]initWithString:@"All copyright, trademarks, design rights, patents and other intellectual property rights (registered and unregistered) in and on Walter’s Automotive Group Online Services and Walter’s Automotive Group Content belong to the Walter’s Automotive. Walter’s Automotive Group reserves all of its rights in Walter’s Automotive Group Content and Walter’s Automotive Group Online Services. Nothing in the Terms grants you a right or license to use any trade mark, design right or copyright owned or controlled by the Walter’s Automotive Group or any other third party except as expressly provided in the Terms."];
        [title addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, title.length)];
        self.txtTerm_condition.attributedText=title;

        //self.txtTerm_condition.text=@"All copyright, trademarks, design rights, patents and other intellectual property rights (registered and unregistered) in and on Walter’s Automotive Group Online Services and Walter’s Automotive Group Content belong to the Walter’s Automotive. Walter’s Automotive Group reserves all of its rights in Walter’s Automotive Group Content and Walter’s Automotive Group Online Services. Nothing in the Terms grants you a right or license to use any trade mark, design right or copyright owned or controlled by the Walter’s Automotive Group or any other third party except as expressly provided in the Terms.";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)gosetting:(id)sender
{
    [self.navigationController popViewControllerAnimated:true];
}

- (IBAction)gohome:(id)sender

{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PhotoSelectionViewController *dash = (PhotoSelectionViewController *)[storyboard instantiateViewControllerWithIdentifier:@"Selection"];
    [self.navigationController pushViewController:dash animated:YES];

} 
@end
