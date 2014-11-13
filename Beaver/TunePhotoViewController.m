//
//  TunePhotoViewController.m
//  Beaver
//
//  Created by xuzhaocheng on 14/11/10.
//  Copyright (c) 2014年 Zhejiang University. All rights reserved.
//

#import "TunePhotoViewController.h"
#import "UIButton+Rounded.h"

#import "Logs.h"

@interface TunePhotoViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *brightnessButton;
@property (weak, nonatomic) IBOutlet UIButton *contrastButton;
@property (weak, nonatomic) IBOutlet UIButton *colorTemperatureButton;
@property (weak, nonatomic) IBOutlet UIButton *saturationButton;

@property (strong, nonatomic) UIImageView *imageView;

@property (nonatomic) float brightness;
@property (nonatomic) float contrast;
@property (nonatomic) float colorTemperature;
@property (nonatomic) float saturation;

@end

@implementation TunePhotoViewController

- (void)setImage:(UIImage *)image
{
    self.imageView.image = image;
    self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    if (self.scrollView) {
        [self setScrollViewMinAndMaxZoomScale];
    }
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

#define EDGE_PADDING 10.f
- (void)setScrollView:(UIScrollView *)scrollView
{
    _scrollView = scrollView;
    UIEdgeInsets insets = _scrollView.contentInset;
    insets.top += EDGE_PADDING;
    insets.left += EDGE_PADDING;
    insets.right += EDGE_PADDING;
    insets.bottom += EDGE_PADDING;
    _scrollView.contentInset = insets;
    _scrollView.contentSize = CGSizeMake(_scrollView.bounds.size.width - EDGE_PADDING * 2, _scrollView.bounds.size.height - 2 * EDGE_PADDING);
    if (_imageView) [self setScrollViewMinAndMaxZoomScale];
}


- (void)updateUI
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.brightnessButton roundedWithCornerRadius:5.f];
    [self.colorTemperatureButton roundedWithCornerRadius:5.f];
    [self.saturationButton roundedWithCornerRadius:5.f];
    [self.contrastButton roundedWithCornerRadius:5.f];
    
    [self.scrollView addSubview:self.imageView];
}


- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    [self centerView:self.imageView inScrollView:self.scrollView];
}

- (void)setScrollViewMinAndMaxZoomScale
{
    self.scrollView.zoomScale = 1.f;
    
    CGRect bounds = self.scrollView.bounds;
    bounds.size.width -= self.scrollView.contentInset.left + self.scrollView.contentInset.right;
    bounds.size.height -= self.scrollView.contentInset.top + self.scrollView.contentInset.bottom;
    
    CGFloat xScale = bounds.size.width / self.image.size.width;
    CGFloat yScale = bounds.size.height / self.image.size.height;
    CGFloat minScale = MIN(xScale, yScale);
    
    self.scrollView.minimumZoomScale = minScale;
    self.scrollView.maximumZoomScale = 3.f;
    self.scrollView.zoomScale = minScale;
}

- (void)centerView:(UIView *)view inScrollView:(UIScrollView *)scrollView
{
    CGRect frameToCenter = view.frame;
    CGSize boundsSize = scrollView.bounds.size;
    UIEdgeInsets contentInsets = scrollView.contentInset;
    
    boundsSize.width -= contentInsets.left + contentInsets.right;
    
    if (frameToCenter.size.width < boundsSize.width) {
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2.0;
    } else {
        frameToCenter.origin.x = 0.f;
    }
    
    if (frameToCenter.size.height < boundsSize.height) {
        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2.0 - scrollView.contentInset.top;
        if (frameToCenter.origin.y < 0) {
            frameToCenter.origin.y = 0;
        }
    } else {
        frameToCenter.origin.y = 0;
    }
    
    view.frame = frameToCenter;
    DLog(@"view frame: %@", NSStringFromCGRect(frameToCenter));
}


#pragma mark - UIScrollView delegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    [self centerView:self.imageView inScrollView:scrollView];
}

#pragma mark - Actions
- (IBAction)sliderValueChanged:(id)sender
{
    
}

- (IBAction)brightnessButtonPressed:(id)sender
{
    [self clearButtonsStates];
    [self setButtonSelectedState:sender];
}

- (IBAction)contrastButtonPressed:(id)sender
{
    [self clearButtonsStates];
    [self setButtonSelectedState:sender];
}

- (IBAction)colorTemperatureButtonPressed:(id)sender
{
    [self clearButtonsStates];
    [self setButtonSelectedState:sender];
}

- (IBAction)saturationButtonPressed:(id)sender
{
    [self clearButtonsStates];
    [self setButtonSelectedState:sender];
}

- (void)clearButtonsStates
{
    [self resetButtonState:self.brightnessButton];
    [self resetButtonState:self.contrastButton];
    [self resetButtonState:self.colorTemperatureButton];
    [self resetButtonState:self.saturationButton];
}

- (void)resetButtonState: (UIButton *)button
{
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor clearColor];
}

- (void)setButtonSelectedState: (UIButton *)button
{
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor whiteColor];
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
