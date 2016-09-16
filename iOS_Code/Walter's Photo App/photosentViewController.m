//
//  photosentViewController.m
//  Walter's Photo App
//
//  Created by Apple on 01/12/15.
//  Copyright © 2015 Apple. All rights reserved.
//

#import "photosentViewController.h"
#import "CustomerInformationViewController.h"
#import "PhotoSelectionViewController.h"
#import "SettingViewController.h"
@interface photosentViewController ()

@end

@implementation photosentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)settingbtn:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SettingViewController *dash = (SettingViewController *)[storyboard instantiateViewControllerWithIdentifier:@"Setting"];
    [self.navigationController pushViewController:dash animated:YES];
}

- (IBAction)goback:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
    

}

- (IBAction)signoutbtn:(id)sender
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ONE"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)tabkeantherbtn:(id)sender {

    NSArray *viewControllers = [[self navigationController] viewControllers];
    for( int i=0;i<[viewControllers count];i++){
        id obj=[viewControllers objectAtIndex:i];
        if([obj isKindOfClass:[PhotoSelectionViewController class]]){
            [[self navigationController] popToViewController:obj animated:YES];
            return;
        }
    }
}

- (IBAction)gohome:(id)sender
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ONE"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PhotoSelectionViewController *dash = (PhotoSelectionViewController *)[storyboard instantiateViewControllerWithIdentifier:@"Selection"];
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
