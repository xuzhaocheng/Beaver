//
//  RotatePhotoViewController.m
//  Beaver
//
//  Created by xuzhaocheng on 14/11/18.
//  Copyright (c) 2014年 Zhejiang University. All rights reserved.
//

#import "RotatePhotoViewController.h"

#import "UIImage+Rotating.h"

@interface RotatePhotoViewController ()
@property (nonatomic, strong) UIImageView *imageView;
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


#pragma mark - View Controller
- (float)statusBarHeight
{
    CGSize statusBarSize = [[UIApplication sharedApplication] statusBarFrame].size;
    return MIN(statusBarSize.width, statusBarSize.height);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.imageView];
}

#define EDGE_PADDING 20.f
#define BOTTOM_PADDING 50.f
- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    CGRect bounds = self.view.bounds;
    bounds.origin.x = EDGE_PADDING;
    bounds.origin.y = self.navigationController.navigationBar.frame.size.height + [self statusBarHeight] + EDGE_PADDING;
    bounds.size.width -= 2 * EDGE_PADDING;
    bounds.size.height -= bounds.origin.y + BOTTOM_PADDING;
    self.imageView.frame = bounds;
}


#pragma mark - Handle Actions

- (IBAction)leftRotation:(id)sender
{
    UIImage *rotatedImage = [self.imageView.image leftRotation];
    self.imageView.image = rotatedImage;
}

- (IBAction)rightRotation:(id)sender
{
    self.imageView.image = [self.imageView.image rightRotation];
}
- (IBAction)verticalRotation:(id)sender
{
    self.imageView.image = [self.imageView.image verticalRotation];
}

- (IBAction)horizontalRotation:(id)sender
{
    self.imageView.image = [self.imageView.image horizontalRotation];
}

- (void)applyAction:(id)sender
{
    [super applyAction:sender];
    
    if ([self.delegate respondsToSelector:@selector(didFinishEditingPhoto:)]) {
        [self.delegate didFinishEditingPhoto:self.image];
    }
    [self dismissViewControllerAnimated:NO completion:NULL];
}

@end
