//
//  RotatePhotoViewController.m
//  Beaver
//
//  Created by xuzhaocheng on 14/11/18.
//  Copyright (c) 2014年 Zhejiang University. All rights reserved.
//

#import "RotatePhotoViewController.h"

#import "Logs.h"
#import "MaskView.h"
#import "UIImage+Rotating.h"
#import "UIImage+Scale.h"

@interface RotatePhotoViewController ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UISlider *rotateSilder;

@property (weak, nonatomic) IBOutlet MaskView *maskView;

@property (nonatomic) CGRect visiableRect;

@property (nonatomic) CGFloat imageViewScale;

@end

@implementation RotatePhotoViewController

#pragma mark - Properties
- (void)setImage:(UIImage *)image
{
    self.imageView.image = image;
}

- (UIImage *)image
{
    return self.imageView.image;
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}

- (UISlider *)rotateSilder
{
    if (!_rotateSilder) {
        _rotateSilder = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, 0, 30)];
        [_rotateSilder setThumbImage:[UIImage imageNamed:@"rotateButton"] forState:UIControlStateNormal];
        [_rotateSilder setThumbImage:[UIImage imageNamed:@"rotateButton"] forState:UIControlStateHighlighted];
        [_rotateSilder setMinimumTrackImage:[[UIImage alloc] init] forState:UIControlStateNormal];
        [_rotateSilder setMaximumTrackImage:[[UIImage alloc] init] forState:UIControlStateNormal];
        _rotateSilder.maximumValue = M_PI_4;
        _rotateSilder.minimumValue = - M_PI_4;
        _rotateSilder.value = 0;
        [_rotateSilder addTarget:self action:@selector(dragSlider:) forControlEvents:UIControlEventTouchDragInside];
        [_rotateSilder addTarget:self action:@selector(dragSlider:) forControlEvents:UIControlEventTouchDragOutside];
        [_rotateSilder addTarget:self action:@selector(beginDragging:) forControlEvents:UIControlEventTouchDown];
    }
    return _rotateSilder;
}


#pragma mark - View Controller
- (CGFloat)statusBarHeight
{
    CGSize statusBarSize = [[UIApplication sharedApplication] statusBarFrame].size;
    return MIN(statusBarSize.width, statusBarSize.height);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view insertSubview:self.imageView belowSubview:self.maskView];
    [self.view addSubview:self.rotateSilder];
}

#define EDGE_PADDING 20.f
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    CGRect bounds = self.view.bounds;
    bounds.origin.x = EDGE_PADDING;
    bounds.origin.y = [self topPadding];
    bounds.size.width -= 2 * EDGE_PADDING;
    bounds.size.height -= bounds.origin.y + [self bottomPadding];
    
    [self scaleImageViewToFitRect:bounds];
    [self updateMaskViewFrames];
    [self adjustSliderFrame];
}

- (void)adjustSliderFrame
{
    CGRect rect = self.rotateSilder.frame;
    rect.origin.x = self.imageView.frame.origin.x;
    rect.origin.y = self.imageView.frame.origin.y + self.imageView.frame.size.height - rect.size.height / 2;
    rect.size.width = self.imageView.frame.size.width;
    self.rotateSilder.frame = rect;
}

- (void)scaleImageViewToFitRect:(CGRect)rect
{
    if (self.image) {
        CGFloat xScale = rect.size.width / self.image.size.width;
        CGFloat yScale = rect.size.height / self.image.size.height;
        CGFloat minScale = MIN(xScale, yScale);
        
        CGFloat newWidth = self.image.size.width * minScale;
        CGFloat newHeight = self.image.size.height * minScale;
        CGFloat newX = rect.origin.x + (rect.size.width - newWidth) / 2;
        CGFloat newY = rect.origin.y + (rect.size.height - newHeight) / 2;
        
        self.imageView.frame = CGRectMake(newX, newY, newWidth, newHeight);
        self.imageViewScale = self.image.size.width / self.imageView.frame.size.width;
    }
}

- (void)updateMaskViewFrames
{
    self.visiableRect = [self.maskView convertRect:self.imageView.frame fromView:self.view];
    [self.maskView setVisiableAreaRect:self.visiableRect];
}

#pragma mark - Helpers
- (CGFloat)topPadding
{
    return self.navigationController.navigationBar.frame.size.height + [self statusBarHeight] + EDGE_PADDING;
}

- (CGFloat)bottomPadding
{
    return [self topPadding];
}

- (void)resetRotation
{
    self.rotateSilder.value = 0;
    [self dragSlider:nil];
    [self viewDidLayoutSubviews];
}


#pragma mark - Handle Actions

- (void)beginDragging:(UISlider *)slider
{
    self.maskView.hidden = NO;
}

- (void)dragSlider:(UISlider *)slider
{
    CGAffineTransform transform = CGAffineTransformRotate(CGAffineTransformIdentity, slider.value);
    
    // 放大倍数 = sin a / tan b + cos a
    // 由正弦定理化解而来
    // a为旋转的角度，tan b为宽/高
    CGFloat tan = self.image.size.width / self.image.size.height;
    if (tan > 1.f)  tan = 1 / tan;
    CGFloat scale = fabs(sin(self.rotateSilder.value) / tan) + fabs(cos(self.rotateSilder.value));
    
    /*
     * 使用下面这段代码效果相同
    CGRect rotatedRect = CGRectApplyAffineTransform(self.visiableRect, CGAffineTransformMakeRotation(slider.value));
    CGFloat scale = MAX(rotatedRect.size.width / self.visiableRect.size.width, rotatedRect.size.height / self.visiableRect.size.height);
    */
    
    transform = CGAffineTransformScale(transform, scale, scale);
    self.imageView.transform = transform;
}

- (IBAction)leftRotation:(id)sender
{
    self.imageView.image = [self.imageView.image leftRotation];
    [self resetRotation];
}

- (IBAction)rightRotation:(id)sender
{
    self.imageView.image = [self.imageView.image rightRotation];
    [self resetRotation];
}

- (IBAction)verticalRotation:(id)sender
{
    self.imageView.image = [self.imageView.image verticalRotation];
    [self resetRotation];
}

- (IBAction)horizontalRotation:(id)sender
{
    self.imageView.image = [self.imageView.image horizontalRotation];
    [self resetRotation];
}

- (void)applyAction:(id)sender
{
    [super applyAction:sender];

    self.image = [self.image cropInSize:self.visiableRect.size
                 afterRotatingInRadians:self.rotateSilder.value
                               preScale:self.imageViewScale];
    
    if ([self.delegate respondsToSelector:@selector(didFinishEditingPhoto:)]) {
        [self.delegate didFinishEditingPhoto:self.image];
    }
    
    [self dismissViewControllerAnimated:NO completion:NULL];
}

@end
