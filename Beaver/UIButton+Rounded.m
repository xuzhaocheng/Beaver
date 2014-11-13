//
//  UIButton+Rounded.m
//  Beaver
//
//  Created by xuzhaocheng on 14/11/13.
//  Copyright (c) 2014年 Zhejiang University. All rights reserved.
//

#import "UIButton+Rounded.h"

@implementation UIButton (Rounded)

- (void)roundedWithCornerRadius:(CGFloat)radius
{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = radius;
}

@end
