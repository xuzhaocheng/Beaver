//
//  UIImageView+Cropping.m
//  Beaver
//
//  Created by xuzhaocheng on 14/11/6.
//  Copyright (c) 2014年 Zhejiang University. All rights reserved.
//

#import <objc/runtime.h>
#import "UIImageView+Cropping.h"
#import "Logs.h"


#pragma mark -
#pragma mark - CroppingMaskVew
#pragma mark -
@interface CroppingMaskView ()

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIView *leftView;
@property (nonatomic, strong) UIView *rightView;

@property (nonatomic, strong) UIView *topLeftView;
@property (nonatomic, strong) UIView *topRightView;
@property (nonatomic, strong) UIView *bottomLeftView;
@property (nonatomic, strong) UIView *bottomRightView;

@end

@implementation CroppingMaskView

@synthesize cropRect = _cropRect;

#pragma mark - Properties

- (CGRect)cropRect
{
    if (CGRectEqualToRect(_cropRect, CGRectZero)) {
        _cropRect = self.bounds;
    }
    return _cropRect;
}

- (void)setCropRect:(CGRect)cropRect
{
    // 裁剪框不完全在frame内，就不更新裁剪框大小
    if (CGRectContainsRect(self.bounds, cropRect)) {
        _cropRect = cropRect;
        [self updateUI];
    }
}

- (UIView *)topView
{
    if (!_topView) {
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        [self addSubview:_topView];
    }
    return _topView;
}

- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        [self addSubview:_bottomView];
    }
    return _bottomView;
}

- (UIView *)leftView
{
    if (!_leftView) {
        _leftView = [[UIView alloc] init];
        _leftView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        [self addSubview:_leftView];
    }
    return _leftView;
}

- (UIView *)rightView
{
    if (!_rightView) {
        _rightView = [[UIView alloc] init];
        _rightView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        [self addSubview:_rightView];
    }
    return _rightView;
}

- (UIView *)topLeftView
{
    if (!_topLeftView) {
        _topLeftView = [[UIView alloc] init];
        _topLeftView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        [self addSubview:_topLeftView];
    }
    return _topLeftView;
}

- (UIView *)topRightView
{
    if (!_topRightView) {
        _topRightView = [[UIView alloc] init];
        _topRightView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        [self addSubview:_topRightView];
    }
    return _topRightView;
}

- (UIView *)bottomLeftView
{
    if (!_bottomLeftView) {
        _bottomLeftView = [[UIView alloc] init];
        _bottomLeftView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        [self addSubview:_bottomLeftView];
    }
    return _bottomLeftView;
}

- (UIView *)bottomRightView
{
    if (!_bottomRightView) {
        _bottomRightView = [[UIView alloc] init];
        _bottomRightView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        [self addSubview:_bottomRightView];
    }
    return _bottomRightView;
}


- (id)initWithFrame:(CGRect)frame cropRect:(CGRect)rect
{
    self = [super initWithFrame:frame];
    if (self) {
        self.cropRect = rect;
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.backgroundColor = [UIColor clearColor];
    self.opaque = NO;
    [self setViewsFrame];
}

- (void)setViewsFrame
{
    self.topLeftView.frame = CGRectMake(0, 0, self.cropRect.origin.x, self.cropRect.origin.y);
    self.topView.frame = CGRectMake(self.cropRect.origin.x, 0, self.cropRect.size.width, self.cropRect.origin.y);
    self.topRightView.frame = CGRectMake(self.cropRect.origin.x + self.cropRect.size.width,
                                         0,
                                         self.bounds.size.width - self.cropRect.origin.x - self.cropRect.size.width,
                                         self.cropRect.origin.y);
    
    self.leftView.frame = CGRectMake(0, self.cropRect.origin.y, self.cropRect.origin.x, self.cropRect.size.height);
    self.rightView.frame = CGRectMake(self.topRightView.frame.origin.x, self.cropRect.origin.y, self.topRightView.frame.size.width, self.cropRect.size.height);
    
    self.bottomLeftView.frame = CGRectMake(0,
                                           self.cropRect.origin.y + self.cropRect.size.height,
                                           self.leftView.frame.size.width,
                                           self.bounds.size.height - self.cropRect.origin.y - self.cropRect.size.height);
    self.bottomView.frame = CGRectMake(self.cropRect.origin.x,
                                       self.bottomLeftView.frame.origin.y,
                                       self.cropRect.size.width,
                                       self.bottomLeftView.frame.size.height);
    self.bottomRightView.frame = CGRectMake(self.rightView.frame.origin.x,
                                            self.bottomLeftView.frame.origin.y,
                                            self.rightView.frame.size.width,
                                            self.bottomLeftView.frame.size.height);
}

- (void)updateUI
{
    [self setViewsFrame];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    [[UIColor whiteColor] setStroke];
    UIRectFrame(self.cropRect);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    CGPoint a = CGPointMake(self.cropRect.origin.x + self.cropRect.size.width / 3, self.cropRect.origin.y);
    CGPoint b = CGPointMake(a.x, a.y + self.cropRect.size.height);
    [path moveToPoint:a];
    [path addLineToPoint:b];
    
    CGPoint c = CGPointMake(a.x + self.cropRect.size.width / 3, self.cropRect.origin.y);
    CGPoint d = CGPointMake(c.x, b.y);
    [path moveToPoint:c];
    [path addLineToPoint:d];
    
    a = CGPointMake(self.cropRect.origin.x, self.cropRect.origin.y + self.cropRect.size.height / 3);
    b = CGPointMake(a.x + self.cropRect.size.width, a.y);
    [path moveToPoint:a];
    [path addLineToPoint:b];
    
    c = CGPointMake(a.x, a.y + self.cropRect.size.height / 3);
    d = CGPointMake(b.x, c.y);
    [path moveToPoint:c];
    [path addLineToPoint:d];
    
    
    [path stroke];
}

@end





#pragma mark - 
#pragma mark - UIImageView (Cropping)
#pragma mark -

static void *const UICroppingMaskView = (void *)&UICroppingMaskView;
static MoveStyle TouchMoveStyle;
static CGPoint LastMovePoint;

@implementation UIImageView (Cropping)

@dynamic croppingMaskView, moveStyle;

- (CroppingMaskView *)croppingMaskView
{
    return objc_getAssociatedObject(self, UICroppingMaskView);
}

- (void)setCroppingMaskView:(CroppingMaskView *)croppingMaskView
{
    [self willChangeValueForKey:@"UICroppingMaskView"];
    objc_setAssociatedObject(self,
                             UICroppingMaskView,
                             croppingMaskView,
                             OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"UICroppingMaskView"];
}

- (void)beginCroppingWithCroppingRect:(CGRect)frame
{
    self.userInteractionEnabled = YES;
    TouchMoveStyle = NoneMoveStyle;
    LastMovePoint = CGPointZero;
    
    if (!self.croppingMaskView) {
        CroppingMaskView *view = [[CroppingMaskView alloc] initWithFrame:self.bounds
                                                                cropRect:CGRectMake(0, 0, self.bounds.size.width / 2, self.bounds.size.height / 2)];
        NSLog(@"%@", NSStringFromCGRect(self.bounds));
        self.croppingMaskView = view;
        [self addSubview:view];
    }
}

- (UIImage *)cropInVisiableRect
{
    return nil;
}



#pragma mark - Drag && Resize

#define EDGE_THRESHOLD    50.f
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touches began");
    [super touchesBegan:touches withEvent:event];
    
    CGPoint location = [[touches anyObject] locationInView:self.croppingMaskView];
    
    TouchMoveStyle = [self moveStyleWithLocation:location];
    
    LastMovePoint = location;
    
}

// 确认是哪种操作
- (MoveStyle)moveStyleWithLocation:(CGPoint)location
{
    CGRect cropRect = self.croppingMaskView.cropRect;
    
    CGPoint topLeftCorner = cropRect.origin;
    CGPoint topRightCorner = CGPointMake(topLeftCorner.x + cropRect.size.width, topLeftCorner.y);
    CGPoint bottomLeftCorner = CGPointMake(topLeftCorner.x, topLeftCorner.y + cropRect.size.height);
    CGPoint bottomRightCorner = CGPointMake(topRightCorner.x, bottomLeftCorner.y);
    
    if ([self distanceSquareBetweenPoint:location andPoint:topLeftCorner] <= EDGE_THRESHOLD) {
        return LeftEdgeMoveStyle | TopEdgeMoveStyle;
    } else if ([self distanceSquareBetweenPoint:location andPoint:topRightCorner] <= EDGE_THRESHOLD) {
        return TopEdgeMoveStyle | RightEdgeMoveStyle;
    } else if ([self distanceSquareBetweenPoint:location andPoint:bottomLeftCorner] <= EDGE_THRESHOLD) {
        return LeftEdgeMoveStyle | BottomEdgeMoveStyle;
    } else if ([self distanceSquareBetweenPoint:location andPoint:bottomRightCorner] <= EDGE_THRESHOLD) {
        return RightEdgeMoveStyle | BottomEdgeMoveStyle;
    } else if (location.x > cropRect.origin.x &&
               location.x < cropRect.origin.x + cropRect.size.width) {
        if (fabs(location.y - cropRect.origin.y) < EDGE_THRESHOLD) {
            return TopEdgeMoveStyle;
        }
        else if (fabs(location.y - (cropRect.origin.y + cropRect.size.height)) < EDGE_THRESHOLD) {
            return BottomEdgeMoveStyle;
        } else if (CGRectContainsPoint(cropRect, location)) {
            return CenterMoveStyle;
        }
    } else if (location.y > cropRect.origin.y &&
               location.y < cropRect.origin.y + cropRect.size.height) {
        if (fabs(location.x - cropRect.origin.x) < EDGE_THRESHOLD) {
            return LeftEdgeMoveStyle;
        } else if (fabs(location.x - (cropRect.origin.x + cropRect.size.width)) < EDGE_THRESHOLD) {
            return RightEdgeMoveStyle;
        } else if (CGRectContainsPoint(cropRect, location)) {
            return CenterMoveStyle;
        }
    }
    
    return NoneMoveStyle;
}

- (CGFloat)distanceSquareBetweenPoint:(CGPoint)pointA andPoint:(CGPoint)pointB
{
    return fabs(pointA.x - pointB.x) + fabs(pointA.y - pointB.y);
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    CGPoint location = [[touches anyObject] locationInView:self.croppingMaskView];
    
    if (TouchMoveStyle & CenterMoveStyle) {
        [self centerMoveWithLocation:location];
    } else  {
        [self edgeMoveWithLocation:location];
    }

    LastMovePoint = location;
}


// 调整裁剪框大小
#define MIN_LENGHT  30.f
- (void)edgeMoveWithLocation:(CGPoint)location
{
    CGRect cropRect = self.croppingMaskView.cropRect;
    
    CGFloat deltaX = 0.f;
    CGFloat deltaY = 0.f;
    
    // 不是上边就是下边
    if (TouchMoveStyle & TopEdgeMoveStyle) {
        deltaY = location.y - LastMovePoint.y;
        if (cropRect.size.height - deltaY > MIN_LENGHT) {
            cropRect.origin.y += deltaY;
            cropRect.size.height -= deltaY;
        }
    } else if (TouchMoveStyle & BottomEdgeMoveStyle) {
        deltaY = location.y - LastMovePoint.y;
        if (cropRect.size.height + deltaY > MIN_LENGHT )
            cropRect.size.height += deltaY;
    }
    
    // 不是左边就是右边
    if (TouchMoveStyle & LeftEdgeMoveStyle) {
        deltaX = location.x - LastMovePoint.x;
        if (cropRect.size.width - deltaX > MIN_LENGHT) {
            cropRect.origin.x += deltaX;
            cropRect.size.width -= deltaX;
        }
    } else if (TouchMoveStyle & RightEdgeMoveStyle) {
        deltaX = location.x - LastMovePoint.x;
        if (cropRect.size.width + deltaX > MIN_LENGHT)
            cropRect.size.width += deltaX;
    }
    
    if (!CGRectEqualToRect(cropRect, self.croppingMaskView.cropRect)) {
        [self.croppingMaskView setCropRect:cropRect];
    }
    
}


// 移动裁剪框
- (void)centerMoveWithLocation:(CGPoint)location
{
    CGRect cropRect = self.croppingMaskView.cropRect;
    if (!CGRectContainsPoint(self.croppingMaskView.bounds, location)) {
        if (location.x < self.croppingMaskView.bounds.origin.x) {
            cropRect.origin.x = 0;
        }
        
        if (location.x > self.croppingMaskView.bounds.origin.x + self.croppingMaskView.bounds.size.width) {
            cropRect.origin.x = self.croppingMaskView.bounds.size.width - cropRect.size.width;
        }
        
        if (location.y < self.croppingMaskView.bounds.origin.y) {
            cropRect.origin.y = 0;
        }
        
        if (location.y > self.bounds.origin.y + self.bounds.size.height) {
            cropRect.origin.y = self.croppingMaskView.bounds.size.height - cropRect.size.height;
        }
        [self.croppingMaskView setCropRect:cropRect];
        return;
    }
    
    
    CGFloat deltaX = location.x - LastMovePoint.x;
    CGFloat deltaY = location.y - LastMovePoint.y;
    
    cropRect.origin.x += deltaX;
    cropRect.origin.y += deltaY;
    [self.croppingMaskView setCropRect:cropRect];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    TouchMoveStyle = NoneMoveStyle;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    TouchMoveStyle = NoneMoveStyle;
}

@end
