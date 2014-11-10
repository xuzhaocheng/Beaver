//
//  CroppingPhotoViewController.h
//  Beaver
//
//  Created by xuzhaocheng on 14/11/7.
//  Copyright (c) 2014年 Zhejiang University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditBaseViewController.h"

@class CroppingPhotoViewController;

@protocol CroppingPhotoDelegate <NSObject>
- (void)didCroppingViewInCropRect:(UIImage *)image;

@end

@interface CroppingPhotoViewController : EditBaseViewController
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, weak) id <CroppingPhotoDelegate> delegate;
@end
