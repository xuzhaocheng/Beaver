//
//  TunePhotoViewController.m
//  Beaver
//
//  Created by xuzhaocheng on 14/11/10.
//  Copyright (c) 2014年 Zhejiang University. All rights reserved.
//

#import "TunePhotoViewController.h"
#import "UIButton+Rounded.h"
#import "UIImage+Scale.h"

#import "Logs.h"

@interface TunePhotoViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *brightnessButton;
@property (weak, nonatomic) IBOutlet UIButton *contrastButton;
@property (weak, nonatomic) IBOutlet UIButton *colorTemperatureButton;
@property (weak, nonatomic) IBOutlet UIButton *saturationButton;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (strong, nonatomic) UIButton *selectedButton;
@property (strong, nonatomic) UIImageView *imageView;

@property (nonatomic) float brightness;
@property (nonatomic) float contrast;
@property (nonatomic) float colorTemperature;
@property (nonatomic) float saturation;

@property (nonatomic, strong) CIFilter *colorFilter;
@property (nonatomic, strong) CIContext *context;

@end

@implementation TunePhotoViewController
@synthesize image = _image;

#pragma mark - Properties
- (void)setImage:(UIImage *)image
{
    _image = image;
    if (self.scrollView) {
        [self ajustImageSize];
    }
}


- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

- (void)setSelectedButton:(UIButton *)selectedButton
{
    [self resetButtonState:_selectedButton];
    _selectedButton = selectedButton;
    [self setButtonSelectedState:_selectedButton];
}

#define EDGE_PADDING 10.f
- (void)setScrollView:(UIScrollView *)scrollView
{
    _scrollView = scrollView;
    UIEdgeInsets insets = _scrollView.contentInset;
    insets.top += EDGE_PADDING;
    insets.left += EDGE_PADDING;
    insets.right += EDGE_PADDING;
    insets.bottom += EDGE_PADDING + 100.f;
    _scrollView.contentInset = insets;
}

- (CIFilter *)colorFilter
{
    if (!_colorFilter) {
        _colorFilter = [CIFilter filterWithName:@"CIColorControls"];
        CIImage *ciImg = [CIImage imageWithCGImage:[self.imageView.image CGImage]];
        [_colorFilter setValue:ciImg forKey:kCIInputImageKey];
    }
    return _colorFilter;
}

- (CIContext *)context
{
    if (!_context) {
        _context = [CIContext contextWithOptions:nil];
    }
    return _context;
}

- (void)setBrightness:(float)brightness
{
    _brightness = brightness;
    [self tuneBrightnessWithValue:brightness];
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
   
    CGSize boundsSize = self.scrollView.bounds.size;
    boundsSize.height -= self.scrollView.contentInset.top + self.scrollView.contentInset.bottom;
    boundsSize.width -= self.scrollView.contentInset.left + self.scrollView.contentInset.right;
    self.scrollView.contentSize = boundsSize;
    
    [self ajustImageSize];
    [self centerView:self.imageView inScrollView:self.scrollView];
}

- (void)ajustImageSize
{
    CGRect bounds = self.scrollView.bounds;
    bounds.size.width -= self.scrollView.contentInset.left + self.scrollView.contentInset.right;
    bounds.size.height -= self.scrollView.contentInset.top + self.scrollView.contentInset.bottom;

    CGFloat xScale = bounds.size.width / self.image.size.width;
    CGFloat yScale = bounds.size.height / self.image.size.height;
    CGFloat minScale = MIN(xScale, yScale);
    
    CGFloat scale = self.scrollView.zoomScale * minScale;
    
    UIImage *scaledImage = [self.image scaleWithScale:scale];
    CGRect imageViewFrame = self.imageView.frame;
    imageViewFrame.size = scaledImage.size;
    self.imageView.frame = imageViewFrame;
    self.imageView.image = scaledImage;
    
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
- (IBAction)sliderValueChanged:(UISlider *)sender
{
    if (self.selectedButton == self.brightnessButton) {
        [self tuneBrightnessWithValue:sender.value];
    }
}

- (IBAction)brightnessButtonPressed:(id)sender
{
    self.selectedButton = sender;
    self.slider.minimumValue = -.7;
    self.slider.maximumValue = .7;
    self.slider.value = self.brightness;
}

- (IBAction)contrastButtonPressed:(id)sender
{
    self.selectedButton = sender;
    self.slider.value = self.contrast;
}

- (IBAction)colorTemperatureButtonPressed:(id)sender
{
    self.selectedButton = sender;
    self.slider.value = self.colorTemperature;
}

- (IBAction)saturationButtonPressed:(id)sender
{
    self.selectedButton = sender;
    self.slider.value = self.saturation;
}


#pragma mark - Helpers
- (void)tuneBrightnessWithValue:(float)value
{
//    if ((int)(value * 1000) % 10 != 0) {
//        return;
//    }
    [self.colorFilter setValue:@(value) forKey:@"inputBrightness"];
    [self setImageViewWithOutputImage];
}

- (void)setImageViewWithOutputImage
{
//    dispatch_queue_t queue = dispatch_queue_create("Tune Photo Brightness", 0);
//    dispatch_async(queue, ^{
        CIImage *outputImage = [self.colorFilter outputImage];
        CGImageRef imgRef = [self.context createCGImage:outputImage fromRect:[outputImage extent]];
//        dispatch_async(dispatch_get_main_queue(), ^{
            self.image = [UIImage imageWithCGImage:imgRef];
            CGImageRelease(imgRef);
//        });
//    });
   
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
