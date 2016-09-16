//
//  SorryViewController.m
//  Walter's Photo App
//
//  Created by Apple on 30/11/15.
//  Copyright © 2015 Apple. All rights reserved.
//

#import "SorryViewController.h"

@interface SorryViewController ()

@end

@implementation SorryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    if (self.isFromLogin) {
        lblTitleMessage.text = @"Sorry. Your login credentials are invalid.";
    }
    else {
        lblTitleMessage.text = @"Need help?";
    }
    
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)backBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:true];
}

- (IBAction)sendMail:(id)sender {
    if([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
        mailCont.mailComposeDelegate = self;        // Required to invoke mailComposeController when send

        [mailCont setSubject:@"Help"];
        [mailCont setToRecipients:[NSArray arrayWithObject:@"waltersphoto@waltsmb.com"]];
        [mailCont setMessageBody:@"" isHTML:NO];

//        [mailCont.navigationBar setTintColor:[UIColor whiteColor]];
//        [mailCont.navigationBar setBarTintColor:[UIColor blackColor]];
//        [mailCont.navigationBar setTranslucent:NO];
        [self.navigationController presentViewController:mailCont animated:YES completion:nil];
    }
}

#pragma mark - Message Delegate
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [controller dismissViewControllerAnimated:YES completion:nil];
}

@end
