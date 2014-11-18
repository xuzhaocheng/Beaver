//
//  UIImage+Rotation.m
//  Beaver
//
//  Created by xuzhaocheng on 14/11/18.
//  Copyright (c) 2014年 Zhejiang University. All rights reserved.
//

#import "UIImage+Rotating.h"

@implementation UIImage (Rotating)


- (UIImage *)rotateInRadians:(CGFloat)radians
{
    const CGFloat width = CGImageGetWidth(self.CGImage);
    const CGFloat height = CGImageGetHeight(self.CGImage);
    
    CGRect rotatedRect = CGRectApplyAffineTransform(CGRectMake(0., 0., width, height), CGAffineTransformMakeRotation(radians));
    
    UIGraphicsBeginImageContext(rotatedRect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(context, rotatedRect.size.width / 2, rotatedRect.size.height / 2);
    CGContextRotateCTM(context, radians);
    CGContextTranslateCTM(context, - width / 2, - height / 2);
    
    [self drawInRect:CGRectMake(0, 0, width, height)];
    
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return resultImage;
}

- (UIImage *)flipOverHorizontalAxis:(BOOL)doHorizontalFlip verticalAxis:(BOOL)doVerticalFlip
{
    const CGFloat width = CGImageGetWidth(self.CGImage);
    const CGFloat height = CGImageGetHeight(self.CGImage);
    
    CGSize imageSize = CGSizeMake(width, height);
    UIGraphicsBeginImageContext(imageSize);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(context, doHorizontalFlip ? width : 0, doVerticalFlip ? height : 0);
    CGContextScaleCTM(context, doHorizontalFlip ? -1.0 : 1.0, doVerticalFlip ? -1.0 : 1.0);
    
    [self drawInRect:CGRectMake(0, 0, width, height)];
    
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resultImage;
}

- (UIImage *)leftRotation
{
    return [self rotateInRadians:-M_PI_2];
}

- (UIImage *)rightRotation
{
    return [self rotateInRadians:M_PI_2];
}

- (UIImage *)verticalRotation
{
    return [self flipOverHorizontalAxis:NO verticalAxis:YES];
}

- (UIImage *)horizontalRotation
{
    return [self flipOverHorizontalAxis:YES verticalAxis:NO];
}

@end
