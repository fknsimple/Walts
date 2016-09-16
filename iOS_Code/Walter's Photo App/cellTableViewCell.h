//
//  cellTableViewCell.h
//  Walter's Automotive
//
//  Created by ATPL on 12/9/15.
//  Copyright © 2015 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface cellTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageview;
@property (weak, nonatomic) IBOutlet UILabel *name1;

@property (weak, nonatomic) IBOutlet UILabel *name2;

@end
