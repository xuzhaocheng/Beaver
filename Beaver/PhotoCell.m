//
//  ImageCell.m
//  Beaver
//
//  Created by xuzhaocheng on 14-11-5.
//  Copyright (c) 2014年 Zhejiang University. All rights reserved.
//

#import "PhotoCell.h"

@interface PhotoCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation PhotoCell
- (void)configureForImage:(UIImage *)image
{
    self.imageView.image = image;
}
@end
