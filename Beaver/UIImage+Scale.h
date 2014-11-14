//
//  UIImage+Scale.h
//  Beaver
//
//  Created by xuzhaocheng on 14/11/14.
//  Copyright (c) 2014年 Zhejiang University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Scale)
- (UIImage *)scaleToSize:(CGSize)size;
- (UIImage *)scaleWithScale:(CGFloat)scale;
@end
