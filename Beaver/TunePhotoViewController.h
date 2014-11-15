//
//  TunePhotoViewController.h
//  Beaver
//
//  Created by xuzhaocheng on 14/11/10.
//  Copyright (c) 2014年 Zhejiang University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditBaseViewController.h"

#import "EditPhotoDelegate.h"

@interface TunePhotoViewController : EditBaseViewController
@property (strong, nonatomic) UIImage *originImage;
@property (weak, nonatomic) id <EditPhotoDelegate> delegate;
@end
