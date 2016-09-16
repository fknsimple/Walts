//
//  longflastnameViewController.m
//  Walter's Photo App
//
//  Created by Apple on 01/12/15.
//  Copyright © 2015 Apple. All rights reserved.
//

#import "longflastnameViewController.h"

@interface longflastnameViewController ()

@end

@implementation longflastnameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)goback:(id)sender {
    
     [self.navigationController popViewControllerAnimated:YES];
    
}
@end
