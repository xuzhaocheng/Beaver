//
//  CroppingPhotoViewController.m
//  Beaver
//
//  Created by xuzhaocheng on 14/11/7.
//  Copyright (c) 2014年 Zhejiang University. All rights reserved.
//

#import "CroppingPhotoViewController.h"
#import "Logs.h"

#import "UIImageView+Cropping.h"

@interface CroppingPhotoViewController ()
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation CroppingPhotoViewController

#pragma mark - Properties
- (void)setImage:(UIImage *)image
{
    self.imageView.image = image;
}

- (UIImage *)image
{
    return self.imageView.image;
}

#define PADDING 10.f
- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.imageView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.imageView beginCroppingWithCroppingRect:CGRectZero];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    CGRect bounds = self.view.bounds;
    bounds.origin.x = PADDING;
    bounds.origin.y += PADDING;
    bounds.size.width -= 2 *PADDING;
    bounds.size.height -= 2 *PADDING;
    self.imageView.frame = bounds;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
