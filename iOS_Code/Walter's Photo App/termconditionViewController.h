//
//  termconditionViewController.h
//  Walter's Automotive
//
//  Created by ATPL on 12/9/15.
//  Copyright © 2015 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface termconditionViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *lblTitle;

@property (assign, nonatomic) BOOL isPrivacyPolicy;
@property (weak, nonatomic) IBOutlet UITextView *txtTerm_condition;

- (IBAction)gosetting:(id)sender;

- (IBAction)gohome:(id)sender;



@end
