//
//  UIImage+Rotation.h
//  Beaver
//
//  Created by xuzhaocheng on 14/11/18.
//  Copyright (c) 2014年 Zhejiang University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Rotating)
- (UIImage *)leftRotation;
- (UIImage *)rightRotation;
- (UIImage *)verticalRotation;
- (UIImage *)horizontalRotation;
- (UIImage *)rotateInRadians:(CGFloat)radians;
- (UIImage *)cropInSize:(CGSize)size afterRotatingInRadians:(CGFloat)radians preScale:(CGFloat)scale;
@end
