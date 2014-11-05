//
//  ImageCell.m
//  Beaver
//
//  Created by xuzhaocheng on 14-11-5.
//  Copyright (c) 2014年 Zhejiang University. All rights reserved.
//

#import "PhotoCell.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface PhotoCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation PhotoCell
- (void)configureWithAsset:(ALAsset *)asset
{
    CGImageRef thumbnail = [asset thumbnail];
    UIImage *image = [UIImage imageWithCGImage:thumbnail];
    self.imageView.image = image;
}
@end
