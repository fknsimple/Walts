//
//  phottoooViewController.m
//  Walter's Automotive
//
//  Created by ATPL on 12/4/15.
//  Copyright © 2015 Apple. All rights reserved.
//

#import "phottoooViewController.h"
#import "SettingViewController.h"
#import "photosentViewController.h"
#import "customViewController1.h"
#import "customeragrementViewController.h"
#import "PhotoSelectionViewController.h"
#import "CustomerInformationViewController.h"
#import "Plugins/SDWebImage/UIImageView+WebCache.h"
#import "Plugins/SDWebImage/UIImageView+UIActivityIndicatorForSDWebImage.h"

@interface phottoooViewController ()


@end

@implementation phottoooViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES];

    NSLog(@"%@",self.getUsername);
    NSLog(@"%@",self.emailid);

    NSString *name = [[NSUserDefaults standardUserDefaults] valueForKey:@"NAME"];
    //NSString *contact = [[NSUserDefaults standardUserDefaults] valueForKey:@"CONTACT"];
    self.companyId = [[NSUserDefaults standardUserDefaults] valueForKey:@"COMPANYID"];

    self.txtName.adjustsFontSizeToFitWidth = YES;
    self.txtName.text = name;
    //self.txtContact.text = contact;
    
    self.getProfileImage = [[NSUserDefaults standardUserDefaults] valueForKey:@"IMAGEDATA"];
    self.profileImage.image = [UIImage imageWithData:self.getProfileImage];
    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.height/2;
    self.profileImage.layer.borderColor = [UIColor colorWithRed:161.0/255.0 green:41.0/255.0 blue:50.0/255.0 alpha:1.0].CGColor;
    self.profileImage.layer.borderWidth = 2.0;
    self.profileImage.clipsToBounds = YES;

//    self.imgWalterLogo.clipsToBounds = YES;
//    self.imgWalterLogo.contentMode = UIViewContentModeScaleAspectFit;

    self.Getimagedata = [[NSUserDefaults standardUserDefaults] valueForKey:@"IMAGE"];
    self.imageview.image = [UIImage imageWithData:self.Getimagedata];

    if (![[[NSUserDefaults standardUserDefaults] valueForKey:@"COMPANYNAME"] isEqualToString:@""]) {
        lblCompanyName.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"COMPANYNAME"];
    }

    if (![[[NSUserDefaults standardUserDefaults] valueForKey:@"TELEPHONE"] isEqualToString:@""]) {
        self.txtContact.text = [[[NSUserDefaults standardUserDefaults] valueForKey:@"TELEPHONE"] uppercaseString];
    }

    self.backgroundImage.image = [UIImage imageWithData:[[NSUserDefaults standardUserDefaults] valueForKey:@"FRAMEIMAGE"]];

    //Chane Bottom view to adjust frame
    self.leadingConstraint_shadowView.constant = 50;
    self.trailingConstraint_shadowView.constant = 50;
    self.bottomConstraint_shadowView.constant = 60;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadFrameImage) name:@"ImageDownloaded" object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ImageDownloaded" object:nil];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.txtName.font = [UIFont fontWithName:@"Raleway-Bold" size:25.0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadFrameImage {
    self.backgroundImage.image = [UIImage imageWithData:[[NSUserDefaults standardUserDefaults] valueForKey:@"FRAMEIMAGE"]];
}

- (IBAction)settingbtn:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SettingViewController *dash = (SettingViewController *)[storyboard instantiateViewControllerWithIdentifier:@"Setting"];
    dash.boolIsBackArrowRequired = true;
    [self.navigationController pushViewController:dash animated:YES];


}



- (IBAction)goobackbtn:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BackFromConfirm" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)gohome:(id)sender
{
     UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
     
     PhotoSelectionViewController *dash = (PhotoSelectionViewController *)[storyboard instantiateViewControllerWithIdentifier:@"Selection"];
     
     [self.navigationController pushViewController:dash animated:YES];
}

- (IBAction)retakebtn:(id)sender
{
     NSArray *viewControllers = [[self navigationController] viewControllers];
     for( int i=0;i<[viewControllers count];i++){
         id obj=[viewControllers objectAtIndex:i];
         if([obj isKindOfClass:[PhotoSelectionViewController class]]){
             [[self navigationController] popToViewController:obj animated:YES];
             return;
         }

         if([obj isKindOfClass:[CustomerInformationViewController class]]){
             [[self navigationController] popToViewController:obj animated:YES];
             return;
         }
     }
}


@end
