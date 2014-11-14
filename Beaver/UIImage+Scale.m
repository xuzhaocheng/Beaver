//
//  UIImage+Scale.m
//  Beaver
//
//  Created by xuzhaocheng on 14/11/14.
//  Copyright (c) 2014年 Zhejiang University. All rights reserved.
//

#import "UIImage+Scale.h"

@implementation UIImage (Scale)

- (UIImage *)scaleToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

- (UIImage *)scaleWithScale:(CGFloat)scale
{
    CGSize size = CGSizeMake(self.size.width * scale, self.size.height * scale);
    return [self scaleToSize:size];
}

@end
