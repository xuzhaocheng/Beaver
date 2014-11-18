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


#define EDGE_PADDING 10.f
- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}


#pragma mark - View Controller
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Crop Photo";
    [self.view addSubview:self.imageView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.imageView beginCroppingWithCroppingRect:CGRectZero];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    CGRect bounds = self.view.bounds;
    bounds.origin.x = EDGE_PADDING;
    bounds.origin.y += EDGE_PADDING;
    bounds.size.width -= 2 * EDGE_PADDING;
    bounds.size.height -= 2 * EDGE_PADDING;

    CGFloat xScale = bounds.size.width / self.imageView.image.size.width;
    CGFloat yScale = self.view.frame.size.height / self.imageView.image.size.height;
    CGFloat minScale = MIN(xScale, yScale);
    
    DLog(@"view frame: %@", NSStringFromCGRect(self.view.frame));
    CGRect frame = CGRectZero;
    frame.size.width = self.imageView.image.size.width * minScale;
    frame.size.height = self.imageView.image.size.height * minScale;
    frame.origin.x = (bounds.size.width - frame.size.width) / 2 + bounds.origin.x;
    frame.origin.y = (bounds.size.height - frame.size.height) / 2 + bounds.origin.y;
    
    self.imageView.frame = frame;

}

- (IBAction)tap:(id)sender
{
    [self.navigationController setNavigationBarHidden:!self.navigationController.navigationBarHidden animated:YES];
}

#pragma mark - Handle Actions
- (void)applyAction:(id)sender
{
    UIImage *image = [self.imageView cropInVisiableRect];
    if ([self.delegate respondsToSelector:@selector(didFinishEditingPhoto:)]) {
        [self.delegate didFinishEditingPhoto:image];
    }
    [self dismissViewControllerAnimated:NO completion:NULL];
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
