//
//  SettingViewController.m
//  Walter's Automotive
//
//  Created by ATPL on 12/8/15.
//  Copyright © 2015 Apple. All rights reserved.
//

#import "SettingViewController.h"
#import "PhotoSelectionViewController.h"
#import "termconditionViewController.h"


@interface SettingViewController ()

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:YES];

    _logbtn.layer.cornerRadius = 10; // this value vary as per your desire
    _logbtn.clipsToBounds = YES;
    
    
    self.cirimg1.hidden=YES;
    self.boximg1.hidden=YES;
    
    if (self.boolIsBackArrowRequired) {
        self.btnBackArrow.hidden = false;
        self.imgBackArrow.hidden = false;
        
        self.lblHome.text = @"Back";
        self.btnHome.hidden = true;
        self.imgHome.hidden = true;
    }
    else {
        self.btnBackArrow.hidden = true;
        self.imgBackArrow.hidden = true;
        
        self.lblHome.text = @"Home";
        self.btnHome.hidden = false;
        self.imgHome.hidden = false;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)gohome:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PhotoSelectionViewController *dash = (PhotoSelectionViewController *)[storyboard instantiateViewControllerWithIdentifier:@"Selection"];
    [self.navigationController pushViewController:dash animated:YES];
 }

- (IBAction)goToPreviousScreen:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)circlebtn1:(id)sender
{
    self.cirimg1.hidden=NO;
    self.cirimg2.hidden=YES;

}

- (IBAction)circlebtn2:(id)sender
{
    self.cirimg1.hidden=YES;
    self.cirimg2.hidden=NO;

}

- (IBAction)boxbtn1:(id)sender
{
    self.boximg1.hidden=NO;
    self.boximg2.hidden=YES;

}
- (IBAction)boxbtn2:(id)sender
{
    self.boximg1.hidden=YES;
    self.boximg2.hidden=NO;

}
- (IBAction)logout:(id)sender
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ONE"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"TELEPHONE"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"COMPANYNAME"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"FRAMEIMAGE"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.navigationController popToRootViewControllerAnimated:YES];

}
- (IBAction)termandcondition:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    termconditionViewController *dash = (termconditionViewController *)[storyboard instantiateViewControllerWithIdentifier:@"Term"];
    dash.isPrivacyPolicy = false;
    [self.navigationController pushViewController:dash animated:YES];


}

- (IBAction)privacypolicy:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    termconditionViewController *dash = (termconditionViewController *)[storyboard instantiateViewControllerWithIdentifier:@"Term"];
    dash.isPrivacyPolicy = true;
    [self.navigationController pushViewController:dash animated:YES];

    
}
@end
