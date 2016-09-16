//
//  PhotoSelectionViewController.m
//  Walter's Photo App
//
//  Created by Apple on 30/11/15.
//  Copyright © 2015 Apple. All rights reserved.
//

#import "PhotoSelectionViewController.h"
#import "CustomerInformationViewController.h"
#import "customViewController1.h"
#import "SettingViewController.h"

@interface PhotoSelectionViewController () <UIActionSheetDelegate>

@end

@implementation PhotoSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController setNavigationBarHidden:YES];

    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"CapturedImage"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)forcustomerbtn:(id)sender
{
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"ONE"];
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"IMAGE"];
    [[NSUserDefaults standardUserDefaults]synchronize];

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CustomerInformationViewController *dash = (CustomerInformationViewController *)[storyboard instantiateViewControllerWithIdentifier:@"Info"];
    [self.navigationController pushViewController:dash animated:YES];
}

- (IBAction)goback:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)InternalBtn:(id)sender
{
    [[NSUserDefaults standardUserDefaults]setValue:@"ONE" forKey:@"ONE"];
    [[NSUserDefaults standardUserDefaults]synchronize];


    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose a photo from:"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:@"Cancel"
                                                    otherButtonTitles:@"Camera", @"Photo Library", nil];

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        // In this case the device is an iPad.
        [actionSheet showFromRect:[(UIButton *)sender frame] inView:self.view animated:YES];
    }
    else{
        // In this case the device is an iPhone/iPod Touch.
        [actionSheet showInView:self.view];
    }

}

- (IBAction)Settingbtn:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SettingViewController *dash = (SettingViewController *)[storyboard instantiateViewControllerWithIdentifier:@"Setting"];
    [self.navigationController pushViewController:dash animated:YES];
    
}


@end
