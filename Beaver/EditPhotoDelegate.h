//
//  EditPhotoDelegate.h
//  Beaver
//
//  Created by xuzhaocheng on 14/11/15.
//  Copyright (c) 2014年 Zhejiang University. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol EditPhotoDelegate <NSObject>
- (void)didFinishEditingPhoto:(UIImage *)image;
@end
