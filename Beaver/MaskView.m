//
//  MaskView.m
//  Beaver
//
//  Created by xuzhaocheng on 14/11/30.
//  Copyright (c) 2014年 Zhejiang University. All rights reserved.
//

#import "MaskView.h"

@interface MaskView ()
@property (nonatomic, strong) UIView *topLeftView;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *topRightView;
@property (nonatomic, strong) UIView *leftView;
@property (nonatomic, strong) UIView *rightView;
@property (nonatomic, strong) UIView *bottomLeftView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIView *bottomRightView;
@end

@implementation MaskView

- (UIView *)setupView
{
    UIView *aView = [[UIView alloc] init];
    aView.backgroundColor = [UIColor blackColor];
    [self addSubview:aView];
    return aView;
}

- (id)init
{
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib
{
    [self setup];
}

- (void)setup
{
    self.backgroundColor = [UIColor clearColor];
    self.alpha = .5;
    _topLeftView = [self setupView];
    _topView = [self setupView];
    _topRightView = [self setupView];
    _leftView = [self setupView];
    _rightView = [self setupView];
    _bottomLeftView = [self setupView];
    _bottomView = [self setupView];
    _bottomRightView = [self setupView];

}

- (void)setVisiableAreaRect:(CGRect)rect
{
    self.topLeftView.frame = CGRectMake(0, 0, rect.origin.x, rect.origin.y);
    self.topView.frame = CGRectMake(rect.origin.x, 0, rect.size.width, rect.origin.y);
    self.topRightView.frame = CGRectMake(rect.origin.x + rect.size.width,
                                         0,
                                         self.bounds.size.width - rect.origin.x - rect.size.width,
                                         rect.origin.y);
    
    self.leftView.frame = CGRectMake(0, rect.origin.y, rect.origin.x, rect.size.height);
    self.rightView.frame = CGRectMake(self.topRightView.frame.origin.x, rect.origin.y, self.topRightView.frame.size.width, rect.size.height);
    
    self.bottomLeftView.frame = CGRectMake(0,
                                           rect.origin.y + rect.size.height,
                                           self.leftView.frame.size.width,
                                           self.bounds.size.height - rect.origin.y - rect.size.height);
    self.bottomView.frame = CGRectMake(rect.origin.x,
                                       self.bottomLeftView.frame.origin.y,
                                       rect.size.width,
                                       self.bottomLeftView.frame.size.height);
    self.bottomRightView.frame = CGRectMake(self.rightView.frame.origin.x,
                                            self.bottomLeftView.frame.origin.y,
                                            self.rightView.frame.size.width,
                                            self.bottomLeftView.frame.size.height);

}

@end
