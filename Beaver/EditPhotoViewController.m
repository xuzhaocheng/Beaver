//
//  EditPhotoViewController.m
//  Beaver
//
//  Created by xuzhaocheng on 14/11/5.
//  Copyright (c) 2014年 Zhejiang University. All rights reserved.
//

#import "EditPhotoViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface EditPhotoViewController () <UIScrollViewDelegate>

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIImage *image;

@property (weak, nonatomic) IBOutlet UIScrollView *imageScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *toolsScrollView;

@end

@implementation EditPhotoViewController

#pragma mark - Properties

- (void)setImage:(UIImage *)image
{
    self.imageView.image = image;
    self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    
    [self configureImageScrollView];
    if (self.view.window) {
        [self updateUI];
    }
}

- (UIImage *)image
{
    return self.imageView.image;
}

- (void)setImageScrollView:(UIScrollView *)imageScrollView
{
    _imageScrollView = imageScrollView;
    [self configureImageScrollView];
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

- (void)setPhotoAsset:(ALAsset *)photoAsset
{
    _photoAsset = photoAsset;
    self.image = [UIImage imageWithCGImage:[[_photoAsset defaultRepresentation] fullResolutionImage]];
}

#pragma mark - View Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.imageScrollView addSubview:self.imageView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateUI];
}


#pragma mark - Helpers

- (void)updateUI
{
    [self centeredFrame:self.imageView forScrollView:self.imageScrollView];
}

- (void)configureImageScrollView
{
    if (self.imageScrollView) {
        CGRect bounds = self.imageScrollView.bounds;
        CGFloat xScale = bounds.size.width / self.image.size.width;
        CGFloat yScale = bounds.size.height / self.image.size.height;
        
        CGFloat minScale = MIN(xScale, yScale);
        CGFloat maxScale = 3;
        self.imageScrollView.minimumZoomScale = minScale;
        self.imageScrollView.maximumZoomScale = maxScale;
        self.imageScrollView.zoomScale = minScale;
        self.imageScrollView.contentSize = self.imageScrollView.bounds.size;
    }
}

- (void)centeredFrame:(UIView *)view forScrollView:(UIScrollView *)scrollView
{
    CGRect frameToCenter = view.frame;
    CGSize boundsSize = scrollView.bounds.size;
    UIEdgeInsets contentInsets = scrollView.contentInset;
    
    boundsSize.width = boundsSize.width - contentInsets.left - contentInsets.right;
    boundsSize.height = boundsSize.height - contentInsets.top - contentInsets.bottom - self.toolsScrollView.bounds.size.height;
    
    if (frameToCenter.size.width < boundsSize.width) {
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2.0;
    } else {
        frameToCenter.origin.x = 0.f;
    }
    
    if (frameToCenter.size.height < boundsSize.height) {
        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2.0;
    } else {
        frameToCenter.origin.y = 0;
    }
    
    view.frame = frameToCenter;
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    [self centeredFrame:self.imageView forScrollView:scrollView];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
