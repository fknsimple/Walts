//
//  ImageCollectionViewCell.h
//  Walter's Automotive
//
//  Created by ATPL on 12/19/15.
//  Copyright © 2015 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageColor;
@property (weak, nonatomic) IBOutlet UILabel *NameLbl;
@property (weak, nonatomic) IBOutlet UIView *viewCell;
@property (weak, nonatomic) IBOutlet UIImageView *redImage;

@end
