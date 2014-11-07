//
//  UIImageView+Cropping.h
//  Beaver
//
//  Created by xuzhaocheng on 14/11/6.
//  Copyright (c) 2014年 Zhejiang University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CroppingMaskView : UIView

@property (nonatomic) CGRect cropRect;

- (id)initWithFrame:(CGRect)frame cropRect:(CGRect)rect;
@end

typedef NS_OPTIONS(NSInteger, MoveStyle) {
    NoneMoveStyle = 0,
    LeftEdgeMoveStyle = 1 << 1,
    RightEdgeMoveStyle = 1 << 2,
    TopEdgeMoveStyle = 1 << 3,
    BottomEdgeMoveStyle = 1 << 4,
    CenterMoveStyle = 1 << 5,
    CornerMoveStyle = 1 << 6
};


@interface UIImageView (Cropping)

@property (nonatomic, strong, readonly) CroppingMaskView *croppingMaskView;
@property (nonatomic, readonly, getter=isCropping) BOOL cropping;

- (void)beginCroppingWithCroppingRect:(CGRect)frame;
- (UIImage *)cropInVisiableRect;

@end


