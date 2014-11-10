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
#import "CroppingPhotoViewController.h"
#import "Logs.h"

#import "UIImageView+Cropping.h"



@interface EditPhotoViewController () <UIScrollViewDelegate, UICollectionViewDataSource, CroppingPhotoDelegate>

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) UIBarButtonItem *rightBarButtonItem;

@property (nonatomic) BOOL allowZooming;

@property (strong, nonatomic) NSArray *toolCellInfos;

@property (strong, nonatomic) IBOutlet UIScrollView *imageScrollView;
@property (weak, nonatomic) IBOutlet UICollectionView *toolsView;

@end


@implementation EditPhotoViewController


#pragma mark - Properties

- (void)setImage:(UIImage *)image
{
    self.imageScrollView.zoomScale = 1.f;
    self.imageView.image = image;
    self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    
    if (self.imageScrollView) [self updateImageScrollView];
}

- (UIImage *)image
{
    return self.imageView.image;
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

- (UIBarButtonItem *)rightBarButtonItem
{
    if (!_rightBarButtonItem) {
        _rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"应用"
                                                               style:UIBarButtonItemStyleBordered
                                                              target:self
                                                              action:nil];
    }
    return _rightBarButtonItem;
}

- (void)setPhotoAsset:(ALAsset *)photoAsset
{
    _photoAsset = photoAsset;
    // 如果使用全分辨率，裁剪的时候会非常卡。
    self.image = [UIImage imageWithCGImage:[[_photoAsset defaultRepresentation] fullScreenImage]];
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
    self.toolsView.backgroundColor = [UIColor clearColor];
    
    [self setScrollViewContentInsets];
    [self updateImageScrollView];
    [self.imageScrollView addSubview:self.imageView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    [self centeredFrame:self.imageView forScrollView:self.imageScrollView];
}


#pragma mark - Helpers

- (void)updateUI
{

}

// 设置scrollView的contentInsets
#define EDGE_PADDING    10.f
- (void)setScrollViewContentInsets
{
    UIEdgeInsets insets = self.imageScrollView.contentInset;
    
    insets.bottom = self.toolsView.bounds.size.height + EDGE_PADDING;
    insets.top += EDGE_PADDING;
    insets.left = insets.right = EDGE_PADDING;
    
    if (!UIEdgeInsetsEqualToEdgeInsets(insets, self.imageScrollView.contentInset)) {
        self.imageScrollView.contentInset = insets;
        CGSize contentSize = self.imageScrollView.contentSize;
        contentSize.width -= insets.left + insets.right;
        contentSize.height -= insets.top + insets.bottom;
        self.imageScrollView.contentSize = contentSize;
    }
}

- (void)updateImageScrollView
{
    CGRect bounds = self.imageScrollView.bounds;
    bounds.size.width -= self.imageScrollView.contentInset.left + self.imageScrollView.contentInset.right;
    
    CGFloat xScale = bounds.size.width / self.image.size.width;
    CGFloat yScale = bounds.size.height / self.image.size.height;
    CGFloat minScale = MIN(xScale, yScale);
    CGFloat maxScale = 3;
    
    self.imageScrollView.minimumZoomScale = minScale;
    self.imageScrollView.maximumZoomScale = maxScale;

    self.imageScrollView.zoomScale = minScale;

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


#pragma mark -
#pragma mark - Photo Editor
#pragma mark -

#pragma mark - Cropping
- (void)croppingAction
{
    [self.navigationItem setRightBarButtonItem:self.rightBarButtonItem animated:YES];
}

- (void)didCroppingViewInCropRect:(UIImage *)image
{
    self.image = image;
}






#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Cropping Photo"]) {
        CroppingPhotoViewController *cpvc = (CroppingPhotoViewController *)[segue.destinationViewController topViewController];
        cpvc.image = self.image;
        cpvc.delegate = self;
    }
}


@end
