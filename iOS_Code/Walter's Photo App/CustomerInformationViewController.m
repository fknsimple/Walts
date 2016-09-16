//
//  CustomerInformationViewController.m
//  Walter's Photo App
//
//  Created by Apple on 30/11/15.
//  Copyright © 2015 Apple. All rights reserved.
//

#import "CustomerInformationViewController.h"
#import "PhotoSelectionViewController.h"
#import "customViewController1.h"
#import "SettingViewController.h"

@interface CustomerInformationViewController () <UITextFieldDelegate, UIActionSheetDelegate>

@end

@implementation CustomerInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _submit.layer.cornerRadius = 5; // this value vary as per your desire
    _submit.clipsToBounds = YES;
    
    _cncelbtnn.layer.cornerRadius = 5; // this value vary as per your desire
    _cncelbtnn.clipsToBounds = YES;
    
    self.firstname.delegate =self;
    self.lastname.delegate =self;
    self.email.delegate=self;
    
    
    [self.navigationController setNavigationBarHidden:YES];
    
    UIColor *color = [UIColor whiteColor];
    _firstname.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Customer First Name" attributes:@{NSForegroundColorAttributeName: color}];
    
       UIColor *color1 = [UIColor whiteColor];
    _lastname.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Customer Last Name" attributes:@{NSForegroundColorAttributeName: color1}];
    
    UIColor *color2 = [UIColor whiteColor];
    _email.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Customer Email" attributes:@{NSForegroundColorAttributeName: color2}];
    
    
    [self.firstname addTarget:self action:@selector(didChangeText:) forControlEvents:UIControlEventEditingChanged];
    
    [self.lastname addTarget:self action:@selector(didChangeText1:)forControlEvents:UIControlEventEditingChanged];
    
     [self.email addTarget:self action:@selector(didChangeText2:)forControlEvents:UIControlEventEditingChanged];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)goback:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


-(BOOL)validateEmail:(NSString *)email
{
    NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    
    return [emailTest evaluateWithObject:email];
}

- (BOOL) validateSpecialCharactor: (NSString *) text {
    NSString *Regex = @"[A-Za-z0-9^]*";
    NSPredicate *TestResult = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    return [TestResult evaluateWithObject:text];
}

- (IBAction)gohome:(id)sender {
    
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    PhotoSelectionViewController *dash = (PhotoSelectionViewController *)[storyboard instantiateViewControllerWithIdentifier:@"Selection"];
    [self.navigationController popViewControllerAnimated:true];    
}

- (IBAction)cancelbtn:(id)sender

{
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    PhotoSelectionViewController *dash = (PhotoSelectionViewController *)[storyboard instantiateViewControllerWithIdentifier:@"Selection"];
    [self.navigationController popViewControllerAnimated:true];
}

- (IBAction)Settingbtn:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SettingViewController *dash = (SettingViewController *)[storyboard instantiateViewControllerWithIdentifier:@"Setting"];
    [self.navigationController pushViewController:dash animated:YES];
}

-(void)didChangeText: (UITextField *)textfield
{
    
    NSString *Regex = @"[A-Za-z0-9^]*";
    NSPredicate *TestResult = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    
    if ([textfield.text isEqualToString:@""])
    {
        
        _firstnameimg.image=[UIImage imageNamed:@"ge.png"];
    }
    else if (textfield.text.length >= 1 && [TestResult evaluateWithObject:textfield.text] != NO)
    {
        _firstnameimg.image=[UIImage imageNamed:@"prfl11.png"];
    }
    else
    {
       _firstnameimg.image=[UIImage imageNamed:@"profile-buttonm.png"];
    }
    
}
-(void)didChangeText1: (UITextField *)textfield
{
    NSString *Regex = @"[A-Za-z0-9^]*";
    NSPredicate *TestResult = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    
    if ([textfield.text isEqualToString:@""])
    {
        _lstnmeimg.image=[UIImage imageNamed:@"ge.png"];
    }
    else if (textfield.text.length >= 1 && [TestResult evaluateWithObject:textfield.text] != NO)
    {
        _lstnmeimg.image=[UIImage imageNamed:@"prfl11.png"];
    }
    else
    {
       _lstnmeimg.image=[UIImage imageNamed:@"profile-buttonm.png"];
    }
    
}

-(void)didChangeText2: (UITextField *)textfield
{
    NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    
//    if (textfield == self.email && [textfield.text isEqualToString:@""])
//    {
//        
//        _emailimg.image=[UIImage imageNamed:@"mgsds.png"];
//    }
//    else
//    {
//        _emailimg.image=[UIImage imageNamed:@"red-open-message.png"];
//    }
    

    if ([emailTest evaluateWithObject:self.email.text] == YES)
    {
        _emailimg.image=[UIImage imageNamed:@"msgbx.png"];
    }
//    else
//    {
//        _emailimg.image=[UIImage imageNamed:@"red-open-message.png"];
//    }

}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if (textField == _firstname)
    {
        UIColor *color = [UIColor whiteColor];
        _firstname.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"" attributes:@{NSForegroundColorAttributeName: color}];
    }
    else if (textField == _lastname)
    {
        UIColor *color = [UIColor whiteColor];
        _lastname.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"" attributes:@{NSForegroundColorAttributeName: color}];
    }
    else if (textField == _email)
    {
        UIColor *color = [UIColor whiteColor];
        _email.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"" attributes:@{NSForegroundColorAttributeName: color}];
    }

    
    return true;
}



-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if ([self.firstname.text isEqualToString:@""])
    {
        UIColor *color = [UIColor whiteColor];
        _firstname.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Customer First Name" attributes:@{NSForegroundColorAttributeName: color}];
    }
    else
    {
        
    }
    
    if ([self.lastname.text isEqualToString:@""])
    {
        UIColor *color1 = [UIColor whiteColor];
        _lastname.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Customer Last Name" attributes:@{NSForegroundColorAttributeName: color1}];
    }
    else
    {
        
    }
    
    if ([self.email.text isEqualToString:@""])
    {
        UIColor *color2 = [UIColor whiteColor];
        _email.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Customer Email" attributes:@{NSForegroundColorAttributeName: color2}];

    }
    else
    {
        
    }
    return YES;
}



@end
