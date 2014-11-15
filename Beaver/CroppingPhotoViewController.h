//
//  CroppingPhotoViewController.h
//  Beaver
//
//  Created by xuzhaocheng on 14/11/7.
//  Copyright (c) 2014年 Zhejiang University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditBaseViewController.h"
#import "EditPhotoDelegate.h"


@interface CroppingPhotoViewController : EditBaseViewController
@property (nonatomic, weak) id <EditPhotoDelegate> delegate;
@end
