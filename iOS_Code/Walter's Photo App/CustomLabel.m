//
//  CustomLabel.m
//  Walter's Automotive
//
//  Created by Hardik Ajmeri on 20/01/16.
//  Copyright © 2016 Apple. All rights reserved.
//

#import "CustomLabel.h"

@implementation CustomLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)layoutSubviews {
    self.font = [UIFont fontWithName:@"Raleway-Bold" size:25.0];
    [super layoutSubviews];
}
@end
