//
//  EditBaseViewController.h
//  Beaver
//
//  Created by xuzhaocheng on 14/11/10.
//  Copyright (c) 2014年 Zhejiang University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditPhotoDelegate.h"

@interface EditBaseViewController : UIViewController
@property (nonatomic, strong) UIBarButtonItem *leftBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *rightBarButtonItem;

@property (nonatomic, strong) UIImage *image;

@property (weak, nonatomic) id <EditPhotoDelegate> delegate;

- (void)applyAction:(id)sender;
- (void)cancelAction:(id)sender;

@end
