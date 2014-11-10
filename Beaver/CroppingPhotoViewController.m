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
@property (nonatomic, strong) UIBarButtonItem *rightBarButtonItem;

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

- (UIBarButtonItem *)rightBarButtonItem
{
    if (!_rightBarButtonItem) {
        _rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Apply"
                                                               style:UIBarButtonItemStyleBordered
                                                              target:self
                                                              action:@selector(applyCropping)];
    }
    return _rightBarButtonItem;
}

#define PADDING 10.f
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
//    self.navigationItem.rightBarButtonItem = self.rightBarButtonItem;
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
    bounds.origin.x = PADDING;
    bounds.origin.y += PADDING;
    bounds.size.width -= 2 *PADDING;
    bounds.size.height -= 2 *PADDING;

    
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
- (IBAction)cancelAction
{
    [self dismissViewControllerAnimated:NO completion:NULL];
}

- (IBAction)cropping:(id)sender
{
    UIImage *image = [self.imageView cropInVisiableRect];
    if ([self.delegate respondsToSelector:@selector(didCroppingViewInCropRect:)]) {
        [self.delegate didCroppingViewInCropRect:image];
    }
    [self cancelAction];
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
