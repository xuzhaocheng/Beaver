//
//  ImageCell.h
//  Beaver
//
//  Created by xuzhaocheng on 14-11-5.
//  Copyright (c) 2014年 Zhejiang University. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ALAsset;

@interface PhotoCell : UICollectionViewCell
- (void)configureWithAsset: (ALAsset *)asset;
@end
