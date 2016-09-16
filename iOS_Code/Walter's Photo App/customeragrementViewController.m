//
//  customeragrementViewController.m
//  Walter's Photo App
//
//  Created by Apple on 01/12/15.
//  Copyright © 2015 Apple. All rights reserved.
//

#import "customeragrementViewController.h"
#import "SettingViewController.h"
#import "againsignViewController.h"
#import "CustomerInformationViewController.h"
#import "PhotoSelectionViewController.h"

@interface customeragrementViewController ()

@end

@implementation customeragrementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    [self.navigationController setNavigationBarHidden:YES];

    _signbtn.layer.cornerRadius = 5; // this value vary as per your desire
    _signbtn.clipsToBounds = YES;
    _decbtn.layer.cornerRadius = 5; // this value vary as per your desire
    _decbtn.clipsToBounds = YES;
    
    _scrol.contentSize = CGSizeMake(100, 1000);

    if (self.boolIsBackArrowRequired) {
        self.btnBack.hidden = false;
        self.imgBack.hidden = false;
        
        self.lblAgreement.text = @"Back";
        self.btnHome.hidden = true;
        self.imgHome.hidden = true;
    }
    else {
        self.btnBack.hidden = true;
        self.imgBack.hidden = true;
        
        self.lblAgreement.text = @"Agreement";
        self.btnHome.hidden = false;
        self.imgHome.hidden = false;
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)goback:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    

    
}

- (IBAction)signbtn:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    againsignViewController *dash = (againsignViewController *)[storyboard instantiateViewControllerWithIdentifier:@"Again"];
    dash.boolIsBackArrowRequired = true;
    dash.resultingImage = self.resultingImage;
    dash.emailid = self.emailid;
    dash.getUsername = self.getUsername;
    dash.companyId = self.companyId;
    [self.navigationController pushViewController:dash animated:YES];

    
}

- (IBAction)declinebtn:(id)sender

{
    [self gohome:self];
    /*
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    CustomerInformationViewController *dash = (CustomerInformationViewController *)[storyboard instantiateViewControllerWithIdentifier:@"Info"];
    
    [self.navigationController pushViewController:dash animated:YES];*/
}

- (IBAction)gohome:(id)sender

{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    
    
    PhotoSelectionViewController *dash = (PhotoSelectionViewController *)[storyboard instantiateViewControllerWithIdentifier:@"Selection"];
    
    
    
    [self.navigationController pushViewController:dash animated:YES];
}

- (IBAction)settingbtn:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SettingViewController *dash = (SettingViewController *)[storyboard instantiateViewControllerWithIdentifier:@"Setting"];
    dash.boolIsBackArrowRequired = true;
    [self.navigationController pushViewController:dash animated:YES];


}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
