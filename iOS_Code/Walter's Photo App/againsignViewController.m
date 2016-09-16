//
//  againsignViewController.m
//  Walter's Photo App
//
//  Created by Apple on 01/12/15.
//  Copyright © 2015 Apple. All rights reserved.
//

#import "againsignViewController.h"
#import "SettingViewController.h"
#import "CustomerInformationViewController.h"
#import "photosentViewController.h"
#import "PhotoSelectionViewController.h"
#import "UITextField+Handwriting.h"

@interface againsignViewController () <UITextFieldDelegate>

@end

@implementation againsignViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.navigationController setNavigationBarHidden:YES];
    [self.flastnametxt setHandwritingView:[self handWirtingView]];
    [self.flastnametxt beginHandwriting];
    [self.flastnametxt setDelegate:self];
    
    _decbtn.layer.cornerRadius = 5; // this value vary as per your desire
    _decbtn.clipsToBounds = YES;
    
    _accbtn.layer.cornerRadius = 5; // this value vary as per your desire
    _accbtn.clipsToBounds = YES;
    
//    UIColor *color = [UIColor lightGrayColor];
//    _flastnametxt.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"First Name Last Name" attributes:@{NSForegroundColorAttributeName: color}];
    
    if (self.boolIsBackArrowRequired) {
        self.btnBack.hidden = false;
        self.imgBack.hidden = false;
        
        self.btnHome.hidden = true;
        self.imgHome.hidden = true;
    }
    else {
        self.btnBack.hidden = true;
        self.imgBack.hidden = true;
        
        self.btnHome.hidden = false;
        self.imgHome.hidden = false;
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)settingbtn:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SettingViewController *dash = (SettingViewController *)[storyboard instantiateViewControllerWithIdentifier:@"Setting"];
    dash.boolIsBackArrowRequired = true;
    [self.navigationController pushViewController:dash animated:YES];
}

- (IBAction)goback:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)declinebtn:(id)sender
{
    [self gohome:self];
    
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    CustomerInformationViewController *dash = (CustomerInformationViewController *)[storyboard instantiateViewControllerWithIdentifier:@"Info"];
//    [self.navigationController pushViewController:dash animated:YES];
}

- (IBAction)acceptbtnn:(id)sender {

    UIGraphicsBeginImageContextWithOptions(self.handWirtingView.bounds.size, NO, 0.0);
    [self.handWirtingView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    NSData *imageData = UIImagePNGRepresentation(resultingImage);

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];

    NSString *imagePath =[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",@"Signature"]];

    NSLog((@"pre writing to file"));
    if (![imageData writeToFile:imagePath atomically:NO])
    {
        NSLog(@"Failed to cache image data to disk");
    }
    else
    {
        NSLog(@"the signature ImagedPath is %@", imagePath);
    }

    [APPDELEGATE showGlobalProgressHUDWithTitle:@"Connecting..."];

    NSString *strUserID;
    if (![[NSUserDefaults standardUserDefaults] valueForKey:@"userid"] != 0  || ![[[NSUserDefaults standardUserDefaults] valueForKey:@"userid"] isMemberOfClass:[NSNull class]]) {
        strUserID = [[NSUserDefaults standardUserDefaults] valueForKey:@"userid"];
    }
    else {
        NSLog(@"User id is not found!");
    }

    //Change Url
    NSString  *urlStr=@"http://52.90.235.126/walter/index.php/web_service/upload_signature";

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init] ;

    [request setURL:[NSURL URLWithString:urlStr]];
    [request setHTTPMethod:@"POST"];

    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];

    NSMutableData *body = [NSMutableData data];

    //user id
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"id\"\r\n\r\n%@",strUserID] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];


    NSDate *sendimgename=[NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"ddMMyyyy:hh:mm:ss"];
    NSString *stringFromDate = [formatter stringFromDate:sendimgename];
    NSLog(@"%@",stringFromDate);

    //for image 1
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"image\"; filename=\"%@.png\"\r\n",stringFromDate]] dataUsingEncoding:NSUTF8StringEncoding]];

    [body appendData:[@"Content-Type: image/png\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:imageData]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];

    NSLog(@"Body data: %@", [[NSString alloc] initWithData:body encoding:NSASCIIStringEncoding]);

    [request setHTTPBody:body];

    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        [APPDELEGATE dismissGlobalHUD];
        if (connectionError != nil)
        {
            UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Service is not working. Please try again!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
        else
        {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&connectionError];
            NSLog(@"%@",dict);
            if  ([[dict objectForKey:@"message"]isEqualToString:@"successfull"])
            {
                [APPDELEGATE showGlobalProgressHUDWithTitle:@"Connecting..."];
                NSData* pictureData1 = UIImageJPEGRepresentation(self.resultingImage, 1);
                
                NSString  *urlStr=@"http://52.90.235.126/walter/index.php/web_service/send_email1?";
                
                NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init] ;
                
                [request setURL:[NSURL URLWithString:urlStr]];
                [request setHTTPMethod:@"POST"];
                
                NSString *boundary = @"---------------------------14737809831466499882746641449";
                NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
                [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
                
                NSMutableData *body = [NSMutableData data];
                
                //user id
                // For email
                [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"email_id\"\r\n\r\n%@",self.emailid] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                
                
                [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"username\"\r\n\r\n%@",self.getUsername] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                
                [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"id\"\r\n\r\n%@",self.companyId] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                
                
                NSDate *sendimgename=[NSDate date];
                
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"ddMMyyyy:hh:mm:ss"];
                
                NSString *stringFromDate = [formatter stringFromDate:sendimgename];
                
                
                NSLog(@"%@",stringFromDate);
                
                //for image 1
                [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[[NSString stringWithString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"image\"; filename=\"%@.jpg\"\r\n",stringFromDate ]] dataUsingEncoding:NSUTF8StringEncoding]];
                
                [body appendData:[@"Content-Type: image/jpg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[NSData dataWithData:pictureData1]];
                [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                
                NSLog(@"Body data: %@", [[NSString alloc] initWithData:body encoding:NSASCIIStringEncoding]);
                
                [request setHTTPBody:body];
                
                [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
                    [APPDELEGATE dismissGlobalHUD];
                    if (connectionError != nil)
                    {
                        UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Service is not working. Please try again!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        [alert show];
                    }
                    else
                    {
                        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&connectionError];
                        NSLog(@"%@",dict);
                        if  ([[dict objectForKey:@"message"]isEqualToString:@"successfull"])
                        {
                            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userid"];
                            [[NSUserDefaults standardUserDefaults] synchronize];
                            
                            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                            photosentViewController *dash = (photosentViewController *)[storyboard instantiateViewControllerWithIdentifier:@"Send"];
                            [self.navigationController pushViewController:dash animated:YES];
                        }
                        else {
                            NSLog(@"%@", [dict objectForKey:@"message"]);
                        }
                    }
                }];

               

            }
            else {
                NSLog(@"%@", [dict objectForKey:@"message"]);
            }
        }
    }];
}

- (IBAction)gohome:(id)sender {
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
