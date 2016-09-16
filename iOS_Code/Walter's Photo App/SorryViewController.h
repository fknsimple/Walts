//
//  SorryViewController.h
//  Walter's Photo App
//
//  Created by Apple on 30/11/15.
//  Copyright © 2015 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface SorryViewController : UIViewController <MFMailComposeViewControllerDelegate>
{
    IBOutlet UILabel *lblTitleMessage;
}
@property (assign, nonatomic) BOOL isFromLogin;

- (IBAction)backBtn:(id)sender;

- (IBAction)sendMail:(id)sender;
@end
