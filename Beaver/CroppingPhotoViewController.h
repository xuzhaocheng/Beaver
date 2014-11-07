//
//  CroppingPhotoViewController.h
//  Beaver
//
//  Created by xuzhaocheng on 14/11/7.
//  Copyright (c) 2014年 Zhejiang University. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CroppingPhotoViewController;

@protocol CroppingPhotoDelegate <NSObject>
- (UIImage *)didCroppingViewInCropRect;

@end

@interface CroppingPhotoViewController : UIViewController
@property (nonatomic, strong) UIImage *image;
@end
