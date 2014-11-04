//
//  ImageCell.m
//  Beaver
//
//  Created by xuzhaocheng on 14-11-5.
//  Copyright (c) 2014年 Zhejiang University. All rights reserved.
//

#import "ImageCell.h"

@interface ImageCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation ImageCell
- (void)configureForImage:(UIImage *)image
{
    self.imageView.image = image;
}
@end
