//
//  EditPhotoViewController.m
//  Beaver
//
//  Created by xuzhaocheng on 14/11/5.
//  Copyright (c) 2014年 Zhejiang University. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>
#import <objc/runtime.h>
#import "EditPhotoViewController.h"
#import "ToolCell.h"
#import "ToolCellInfo.h"
#import "Logs.h"

#import "UIImageView+Cropping.h"


@interface EditPhotoViewController () <UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIImage *image;

@property (strong, nonatomic) UIImageView *imageViewForCropping;
@property (nonatomic) BOOL allowZooming;

@property (strong, nonatomic) NSArray *toolCellInfos;

@property (weak, nonatomic) IBOutlet UIScrollView *imageScrollView;
@property (weak, nonatomic) IBOutlet UICollectionView *toolsView;

@end


@implementation EditPhotoViewController


#pragma mark - Properties

- (void)setImage:(UIImage *)image
{
    self.imageView.image = image;
    self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    [self configureImageScrollView];
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
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imageView;
}

- (void)setPhotoAsset:(ALAsset *)photoAsset
{
    _photoAsset = photoAsset;
    // 如果使用全分辨率，裁剪的时候会非常卡。
    self.image = [UIImage imageWithCGImage:[[_photoAsset defaultRepresentation] fullScreenImage]];
}


#define EDGE_PADDING    10.f
- (UIImageView *)imageViewForCropping
{
    if (!_imageViewForCropping) {
        UIImageView *imageViewForCropping = [[UIImageView alloc] init];
        CGRect bounds = self.imageScrollView.bounds;
        
        bounds.size.width -= EDGE_PADDING * 2;
        bounds.size.height -= EDGE_PADDING * 2;
        
        CGFloat xScale = bounds.size.width / self.image.size.width;
        CGFloat yScale = bounds.size.height / self.image.size.height;
        self.view.backgroundColor = [UIColor blackColor];
        CGFloat minScale = MIN(xScale, yScale);
        
        imageViewForCropping.image = self.image;
        imageViewForCropping.frame = CGRectMake(0, 0, self.image.size.width * minScale, self.image.size.height * minScale);
        imageViewForCropping.center = CGPointMake(self.view.bounds.size.width / 2,
                                                  (self.view.bounds.size.height - self.navigationController.navigationBar.bounds.size.height) / 2);
        
        [self.view addSubview:imageViewForCropping];
        _imageViewForCropping = imageViewForCropping;
    }
    return _imageViewForCropping;
}

- (NSArray *)toolCellInfos
{
    if (!_toolCellInfos) {
        NSMutableArray *aMutableArray = [[NSMutableArray alloc] init];
        [aMutableArray addObject:[[ToolCellInfo alloc] initWithTitle:@"Cropping" icon:@""]];
        _toolCellInfos = aMutableArray;
    }
    return _toolCellInfos;
}

#pragma mark - View Controller

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.allowZooming = YES;
    [self.imageScrollView addSubview:self.imageView];
    self.toolsView.backgroundColor = [UIColor clearColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self updateScrollViewContentInsets];
    [self centeredFrame:self.imageView forScrollView:self.imageScrollView];
}


#pragma mark - Helpers

- (void)updateUI
{

}

// 设置scrollView的contentInsets
- (void)updateScrollViewContentInsets
{
    UIEdgeInsets insets = self.imageScrollView.contentInset;
    
    insets.bottom = self.toolsView.bounds.size.height;
    if (!UIEdgeInsetsEqualToEdgeInsets(insets, self.imageScrollView.contentInset)) {
        self.imageScrollView.contentInset = insets;
        CGSize contentSize = self.imageScrollView.contentSize;
        contentSize.width -= insets.left + insets.right;
        contentSize.height -= insets.top + insets.bottom;
        self.imageScrollView.contentSize = contentSize;
    }
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
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageScrollView.zoomScale = minScale;
        });
        self.imageScrollView.contentSize = self.imageScrollView.bounds.size;
    }
}

- (void)centeredFrame:(UIView *)view forScrollView:(UIScrollView *)scrollView
{
    CGRect frameToCenter = view.frame;
    CGSize boundsSize = scrollView.bounds.size;
    UIEdgeInsets contentInsets = scrollView.contentInset;
    
    boundsSize.width = boundsSize.width - contentInsets.left - contentInsets.right;
    boundsSize.height = boundsSize.height - contentInsets.top - contentInsets.bottom ;
    
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
    return self.allowZooming ? self.imageView : nil;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    [self centeredFrame:self.imageView forScrollView:scrollView];
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.toolCellInfos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ToolCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Tool Cell" forIndexPath:indexPath];
    ToolCellInfo *cellInfo = self.toolCellInfos[indexPath.row];
    [cell configureCellWithTitle:cellInfo.title image:nil];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ToolCellInfo *toolCellInfo = self.toolCellInfos[indexPath.row];
    
    NSString *selectorName = [NSString stringWithFormat:@"%@%@Action", [[toolCellInfo.title substringToIndex:1] lowercaseString], [toolCellInfo.title substringFromIndex:1]];
    
    SEL selector = NSSelectorFromString(selectorName);
    
    // http://stackoverflow.com/questions/7017281/performselector-may-cause-a-leak-because-its-selector-is-unknown
    if ([self respondsToSelector:selector]) {
        ((void (*)(id, SEL))[self methodForSelector:selector])(self, selector);
    }
}


#pragma mark -
#pragma mark - Photo Editor
#pragma mark -

#pragma mark - Cropping
- (void)croppingAction
{
    [self.imageScrollView removeFromSuperview];
    [self.imageViewForCropping beginCroppingWithCroppingRect:CGRectZero];
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
