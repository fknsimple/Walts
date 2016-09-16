//
//  AppDelegate.m
//  Walter's Photo App
//
//  Created by Apple on 30/11/15.
//  Copyright © 2015 Apple. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ONE"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"TELEPHONE"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"COMPANYNAME"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"FRAMEIMAGE"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Progress HUD
//Method to show the HUD Globally
-(MBProgressHUD *)showGlobalProgressHUDWithTitle:(NSString *)title
{
    [self dismissGlobalHUD];
    UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    hud.labelText = title;
    hud.dimBackground = YES;
    return hud;
}

//Method to hide the HUD Globally
-(void)dismissGlobalHUD
{
    UIWindow *window,*window2;
    window = [[[UIApplication sharedApplication] windows] lastObject];
    window2 = [[[UIApplication sharedApplication] windows] firstObject];
    [MBProgressHUD hideHUDForView:window animated:YES];
    [MBProgressHUD hideAllHUDsForView:window2 animated:YES];
}

+(AppDelegate *)sharedInstance
{
    return (AppDelegate*)[UIApplication sharedApplication].delegate;
}

- (void)makeServiceCall:(NSString *)companyID {
    NSString *string= [NSString stringWithFormat:@"http://52.90.235.126/walter/index.php/web_service/get_frame_user?userid=%@", companyID];
    NSLog(@"%@",string);
    NSString* encodedUrl = [string stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    NSURL *url = [[NSURL alloc]initWithString:encodedUrl];
    NSLog(@"%@",url);
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"content-type"];

    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {

        if (connectionError != nil)
        {
            [APPDELEGATE dismissGlobalHUD];
            UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Walter's Auto Photo App requires a working internet connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
        else
        {
            NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&connectionError];
            NSLog(@"%@",jsonArray);

            if ([[jsonArray valueForKey:@"status"] boolValue] == 1)
            {
                NSArray *userDetails = [jsonArray objectForKey:@"data"];

                NSArray *arrImageName = [userDetails valueForKey:@"image"];
                NSArray *arrImagePath = [userDetails valueForKey:@"image_path"];
                NSArray *arrCompanyName = [userDetails valueForKey:@"company_name"];
                NSArray *arrLogo = [userDetails valueForKey:@"logo"];
                NSArray *arrTelephone = [userDetails valueForKey:@"telephone"];

                NSString *strImageName, *strImagePath, *strCompanyName, *strLogo, *strTelephone;

                for (NSString *companyStr in arrCompanyName)
                {
                    strCompanyName = companyStr;
                }

                for (NSString *imagePathStr in arrImagePath)
                {
                    strImagePath = imagePathStr;
                }

                for (NSString *imageNameStr in arrImageName)
                {
                    strImageName = imageNameStr;
                }

                for (NSString *logoStr in arrLogo)
                {
                    strLogo = logoStr;
                }

                for (NSString *telephoneStr in arrTelephone)
                {
                    strTelephone = telephoneStr;
                }

                NSLog(@"%@/%@ - %@", strImagePath, strImageName, strCompanyName);
                NSURL *imgURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", strImagePath, strImageName]];

                [self downloadImageWithURL:imgURL completionBlock:^(BOOL succeeded, UIImage *image) {
                    NSData *data = UIImagePNGRepresentation(image);
                    [[NSUserDefaults standardUserDefaults] setObject:strTelephone forKey:@"TELEPHONE"];
                    [[NSUserDefaults standardUserDefaults] setObject:strTelephone forKey:@"COMPANYNAME"];
                    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"FRAMEIMAGE"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }];
            }
            else
            {
                UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"Error" message:connectionError.description delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
        }
    }];
}

- (void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               [APPDELEGATE dismissGlobalHUD];
                               if ( !error )
                               {
                                   UIImage *image = [[UIImage alloc] initWithData:data];
                                   completionBlock(YES,image);
                               } else{
                                   completionBlock(NO,nil);
                               }
                           }];
}
@end
