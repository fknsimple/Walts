//
//  ViewController.m
//  Walter's Photo App
//
//  Created by Apple on 30/11/15.
//  Copyright © 2015 Apple. All rights reserved.
//

#import "ViewController.h"
#import "PhotoSelectionViewController.h"
#import "SorryViewController.h"

@interface ViewController ()<UITextFieldDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    
    
    _signbtn.layer.cornerRadius = 5; // this value vary as per your desire
    _signbtn.clipsToBounds = YES;
  
    UIColor *color = [UIColor whiteColor];
    _usernameTxt.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email" attributes:@{NSForegroundColorAttributeName: color}];
    
     UIColor *color1 = [UIColor whiteColor];
    _passwordTxt.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: color1}];
    
    self.usernameTxt.delegate=self;
    self.passwordTxt.delegate=self;
    
    [self.usernameTxt addTarget:self action:@selector(didChangeText:) forControlEvents:UIControlEventEditingChanged];
    
    [self.passwordTxt addTarget:self action:@selector(didChangeText1:)forControlEvents:UIControlEventEditingChanged];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    self.usernameTxt.text = @"";
    self.passwordTxt.text = @"";
    
    _usernameimg.image=[UIImage imageNamed:@"asdf.png"];
    _passwordimg.image=[UIImage imageNamed:@"key-buttdsdon.png"];
    //[self.signbtn setBackgroundImage:nil forState:UIControlStateNormal];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    CGSize viewSize = self.view.frame.size;
    self.view.frame = CGRectMake(0, 0, viewSize.width, viewSize.height);
}

- (IBAction)signinbtn:(id)sender {
    [self.view endEditing:YES]; 

    if ([self.usernameTxt.text isEqualToString:@""] || [self.passwordTxt.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Please enter correct email/password" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
        alert.tag = 1;
        _usernameimg.image=[UIImage imageNamed:@"profile-buttonm.png"];
        _passwordimg.image=[UIImage imageNamed:@"key-button.png"];
    }
    else if (![self validateEmailId:self.usernameTxt.text]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"please enter valid email" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];

        [alert show];
    }
    else
    {
        [APPDELEGATE showGlobalProgressHUDWithTitle:@"Connecting..."];
        NSString *string= [NSString stringWithFormat:@"http://52.90.235.126/walter/index.php/web_service/loginbyemail?username=%@&password=%@",self.usernameTxt.text,self.passwordTxt.text];
        NSString* encodedUrl = [string stringByAddingPercentEscapesUsingEncoding:
                            NSUTF8StringEncoding];
        NSURL *url = [[NSURL alloc]initWithString:encodedUrl];
        NSLog(@"%@",url);
        NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"GET"];
        [request setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"content-type"];

        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {

            if (connectionError != nil)
            {
                [APPDELEGATE dismissGlobalHUD];
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Walter's Auto Photo App requires a working internet connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
            else
            {
                NSDictionary *jsonArray=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&connectionError];
                NSLog(@"%@",jsonArray);

                if ([[jsonArray valueForKey:@"status"] isEqualToString:@"true"])
                {
                    NSArray *userDetails = [jsonArray objectForKey:@"user_details"];

                    NSArray *UserContactNo = [userDetails valueForKey:@"contact_no"];
                    NSArray *UserEmail = [userDetails valueForKey:@"email_id"];
                    NSArray *UserName = [userDetails valueForKey:@"name"];
                    NSArray *CompanyId = [userDetails valueForKey:@"id"];
                    NSArray *image = [userDetails valueForKey:@"images"];

                    NSString *strCompanyId;
                    for  (NSString *companyStr in CompanyId)
                    {
                        strCompanyId = companyStr;
                        [[NSUserDefaults standardUserDefaults] setObject:companyStr forKey:@"COMPANYID"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }
                    for (NSString *strImage in image)
                    {
                        NSString *ImageStr = [NSString stringWithFormat:@"http://52.90.235.126/walter/admin/uploads/user_pics/%@",[strImage stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                        NSURL *url = [NSURL URLWithString:[self textToHtml:ImageStr]];
                        NSData *data = [NSData dataWithContentsOfURL:url];

                        [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"IMAGEDATA"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }
                    for (NSString *Contact in UserContactNo)
                    {

                        for (NSString *Email in UserEmail)
                        {
                            for (NSString *Name in UserName)
                            {
                                [[NSUserDefaults standardUserDefaults] setObject:Contact forKey:@"CONTACT"];
                                [[NSUserDefaults standardUserDefaults] setObject:Email forKey:@"EMAIL"];
                                [[NSUserDefaults standardUserDefaults] setObject:Name forKey:@"NAME"];
                                [[NSUserDefaults standardUserDefaults] synchronize];
                            }
                        }
                    }

                    [APPDELEGATE makeServiceCall:strCompanyId];
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    PhotoSelectionViewController *dash = (PhotoSelectionViewController *)[storyboard instantiateViewControllerWithIdentifier:@"Selection"];
                    [self.navigationController pushViewController:dash animated:YES];
                }
                else
                {
                    [APPDELEGATE dismissGlobalHUD];
//
//                    UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Please enter correct details" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//                    
//                    [alert show];
//                    alert.tag = 1;

                    UIColor *color = [UIColor whiteColor];
                    _usernameTxt.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email" attributes:@{NSForegroundColorAttributeName: color}];

                    UIColor *color1 = [UIColor whiteColor];
                    _passwordTxt.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: color1}];

                    _usernameimg.image=[UIImage imageNamed:@"profile-buttonm.png"];
                    _passwordimg.image=[UIImage imageNamed:@"key-button.png"];


                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    SorryViewController *dash = (SorryViewController *)[storyboard instantiateViewControllerWithIdentifier:@"Sorry"];
                    dash.isFromLogin = true;
                    [self.navigationController pushViewController:dash animated:YES];
                }
            }

        }];

    }
}


- (NSString*)textToHtml:(NSString*)htmlString {
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&"  withString:@"&amp;"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"<"  withString:@"&lt;"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@">"  withString:@"&gt;"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"""" withString:@"&quot;"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"'"  withString:@"&#039;"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@" " withString:@"&nbsp;"];
    return htmlString;
}

-(void)didChangeText: (UITextField *)textfield
{
    if ([textfield.text isEqualToString:@""])
    {
       
        _usernameimg.image=[UIImage imageNamed:@"asdf.png"];
    }
    else
    {
       // _usernameimg.image=[UIImage imageNamed:@"profile-buttonm.png"];
    }
    
    if (textfield.text.length >= 5)
    {
        _usernameimg.image=[UIImage imageNamed:@"man.png"];
    }
    else
    {
      //  _usernameimg.image=[UIImage imageNamed:@"profile-buttonm.png"];
    }

}




-(void)didChangeText1: (UITextField *)textfield
{
    if (textfield == self.passwordTxt && [textfield.text isEqualToString:@""])
    {
        
        _passwordimg.image=[UIImage imageNamed:@"key-buttdsdon.png"];
    }
    else
    {
      //  _passwordimg.image=[UIImage imageNamed:@"key-button.png"];
    }
    
    if (textfield.text.length >= 4)
    {
        _passwordimg.image=[UIImage imageNamed:@"lok.png"];
        //[self.signbtn setBackgroundImage:[UIImage imageNamed:@"logout.png"] forState:UIControlStateNormal];
    }
    else
    {
       // _passwordimg.image=[UIImage imageNamed:@"key-button.png"];

    }
    
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
   
    if (textField == _usernameTxt)
    {
        UIColor *color = [UIColor whiteColor];
        _usernameTxt.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"" attributes:@{NSForegroundColorAttributeName: color}];
    }
    else if (textField == _passwordTxt)
    {
        UIColor *color = [UIColor whiteColor];
        _passwordTxt.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"" attributes:@{NSForegroundColorAttributeName: color}];
    }
    
    return true;
}



-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if ([self.usernameTxt.text isEqualToString:@""])
    {
        UIColor *color = [UIColor whiteColor];
        _usernameTxt.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email" attributes:@{NSForegroundColorAttributeName: color}];
    }
    else if (![self validateEmailId:self.usernameTxt.text]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"please enter valid email" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];

        [alert show];
    }
    else
    {
        
    }
    
    if ([self.passwordTxt.text isEqualToString:@""])
    {
        UIColor *color = [UIColor whiteColor];
        _passwordTxt.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: color}];
    }
    else
    {
        
    }

    return YES;
}


- (IBAction)ForgotPasswordBtn:(id)sender
{
    if ([self.usernameTxt.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"please enter your email" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [alert show];
    }
    else if (![self validateEmailId:self.usernameTxt.text]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"please enter valid email" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];

        [alert show];
    }
    else
    {
        [APPDELEGATE showGlobalProgressHUDWithTitle:@"Connecting..."];
        NSString *string= [NSString stringWithFormat:@"http://52.90.235.126/walter/index.php/web_service/forgetpswrd?username=%@",self.usernameTxt.text];
        NSLog(@"%@",string);
        NSString* encodedUrl = [string stringByAddingPercentEscapesUsingEncoding:
                            NSUTF8StringEncoding];
        NSURL *url = [[NSURL alloc]initWithString:encodedUrl];
        NSLog(@"%@",url);
        NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"GET"];
        [request setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"content-type"];

        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {

            if (connectionError != nil)
            {
                [APPDELEGATE dismissGlobalHUD];
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Walter's Auto Photo App requires a working internet connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
            else {
                [APPDELEGATE dismissGlobalHUD];
                NSDictionary *jsonArray=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&connectionError];
                NSLog(@"%@",jsonArray);

                if ([[jsonArray valueForKey:@"status"] isEqualToString:@"true"])
                {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Success" message:@"Your password has been sent to the admin" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];

                    [alert show];
                }
                else
                {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Invalid username" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    
                    [alert show];
                    
                }
            }
        }];

    }
}

- (IBAction)helpBtn:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SorryViewController *dash = (SorryViewController *)[storyboard instantiateViewControllerWithIdentifier:@"Sorry"];
    dash.isFromLogin = false;
    [self.navigationController pushViewController:dash animated:YES];
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1)
    {
        self.usernameTxt.text = @"";
        self.passwordTxt.text = @"";
        
        _passwordimg.image=[UIImage imageNamed:@"key-buttdsdon.png"];
        _usernameimg.image=[UIImage imageNamed:@"asdf.png"];
        
        UIColor *color = [UIColor whiteColor];
        _usernameTxt.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email" attributes:@{NSForegroundColorAttributeName: color}];

        _passwordTxt.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: color}];

    }
}

#pragma mark - Validate Email
- (BOOL)validateEmailId:(NSString *)checkString
{
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

@end
