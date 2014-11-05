//
//  EditPhotoViewController.m
//  Beaver
//
//  Created by xuzhaocheng on 14/11/5.
//  Copyright (c) 2014年 Zhejiang University. All rights reserved.
//

#import "EditPhotoViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface EditPhotoViewController ()

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)updateUI
{
    
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
