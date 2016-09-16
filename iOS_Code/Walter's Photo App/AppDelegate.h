//
//  AppDelegate.h
//  Walter's Photo App
//
//  Created by Apple on 30/11/15.
//  Copyright © 2015 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

+(AppDelegate *)sharedInstance;
- (void)makeServiceCall:(NSString *)companyID;

//Method to show the HUD Globally
-(MBProgressHUD *)showGlobalProgressHUDWithTitle:(NSString *)title;

//Method to hide the HUD Globally
-(void)dismissGlobalHUD;

@end

