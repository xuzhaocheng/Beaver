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



@property (strong, nonatomic) UIButton *selectedButton;
@property (strong, nonatomic) UIImageView *imageView;

@property (nonatomic) float brightness;
@property (nonatomic) float contrast;
@property (nonatomic) float colorTemperature;
@property (nonatomic) float saturation;

@property (nonatomic, strong) CIFilter *colorFilter;
@property (nonatomic, strong) CIFilter *colorTemperatureFilter;
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

- (void)setOriginImage:(UIImage *)originImage
{
    _originImage = originImage;
    self.image = originImage;
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
//        [_colorFilter setValue:[self scaledCIImage] forKey:kCIInputImageKey];
    }
    return _colorFilter;
}

- (CIFilter *)colorTemperatureFilter
{
    if (!_colorTemperatureFilter) {
        _colorTemperatureFilter = [CIFilter filterWithName:@"CITemperatureAndTint"];
        [_colorTemperatureFilter setValue:[CIVector vectorWithX:6500.f Y:0] forKey:@"inputTargetNeutral"];
    }
    return _colorTemperatureFilter;
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

- (void)setContrast:(float)contrast
{
    _contrast = contrast;
    [self tuneContrastWithValue:contrast];
}

- (void)setColorTemperature:(float)colorTemperature
{
    _colorTemperature = colorTemperature;
    [self tuneColorTemperatureWithValue:colorTemperature];
}

- (void)setSaturation:(float)saturation
{
    _saturation = saturation;
    [self tuneSaturationWithValue:saturation];
}


#pragma mark - View Controller
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _brightness = 0.f;
    _contrast = 1.f;
    _colorTemperature = 6500.f;
    _saturation = 1.f;
    
    
    [self.brightnessButton roundedWithCornerRadius:5.f];
    [self.colorTemperatureButton roundedWithCornerRadius:5.f];
    [self.saturationButton roundedWithCornerRadius:5.f];
    [self.contrastButton roundedWithCornerRadius:5.f];
    
    [self brightnessButtonPressed:self.brightnessButton];
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
- (void)applyAction:(id)sender
{
    [super applyAction:sender];
    
    if ([self.delegate respondsToSelector:@selector(didFinishEditingPhoto:)]) {
        CIImage *originCIImage = [CIImage imageWithCGImage:self.originImage.CGImage];
        [self.colorFilter setValue:originCIImage forKey:kCIInputImageKey];
        
        [self.colorTemperatureFilter setValue:self.colorFilter.outputImage forKey:kCIInputImageKey];
        
        CIImage *ciImg = self.colorTemperatureFilter.outputImage;
        CGImageRef imgRef = [self.context createCGImage:ciImg fromRect:[ciImg extent]];
        UIImage *newImage = [UIImage imageWithCGImage:imgRef];
        CGImageRelease(imgRef);
        
        [self.delegate didFinishEditingPhoto:newImage];
    }
    
    [self dismissViewControllerAnimated:NO completion:NULL];
}

- (IBAction)sliderValueChanged:(UISlider *)sender
{
    if (self.selectedButton == self.brightnessButton) {
        self.brightness = sender.value;
    } else if (self.selectedButton == self.contrastButton) {
        self.contrast = sender.value;
    } else if (self.selectedButton == self.saturationButton) {
        self.saturation = sender.value;
    } else if (self.selectedButton == self.colorTemperatureButton) {
        self.colorTemperature = sender.value;
    }
}

- (IBAction)brightnessButtonPressed:(id)sender
{
    self.selectedButton = sender;
    self.slider.minimumValue = -.5;
    self.slider.maximumValue = .5;
    self.slider.value = self.brightness;
    [self setInputImageForColorControlFilter];
}

- (IBAction)contrastButtonPressed:(id)sender
{
    self.selectedButton = sender;
    self.slider.minimumValue = 0.5;
    self.slider.maximumValue = 1.5;
    self.slider.value = self.contrast;
    [self setInputImageForColorControlFilter];
}

- (IBAction)colorTemperatureButtonPressed:(id)sender
{
    self.selectedButton = sender;
    self.slider.minimumValue = 0.f;
    self.slider.maximumValue = 6500.f * 2;
    self.slider.value = self.colorTemperature;
    [self setInputImageForColorTemperatureFilter];
}

- (IBAction)saturationButtonPressed:(id)sender
{
    self.selectedButton = sender;
    self.slider.minimumValue = 0;
    self.slider.maximumValue = 2;
    self.slider.value = self.saturation;
    [self setInputImageForColorControlFilter];
}


#pragma mark - Tune
- (void)tuneBrightnessWithValue:(float)value
{
    [self.colorFilter setValue:@(value) forKey:@"inputBrightness"];
    [self setImageViewWithOutputImageUsingFilter:self.colorFilter];
}

- (void)tuneContrastWithValue:(float)value
{
    [self.colorFilter setValue:@(value) forKey:@"inputContrast"];
    [self setImageViewWithOutputImageUsingFilter:self.colorFilter];
}


- (void)tuneSaturationWithValue:(float)value
{
    [self.colorFilter setValue:@(value) forKey:@"inputSaturation"];
    [self setImageViewWithOutputImageUsingFilter:self.colorFilter];
}

- (void)tuneColorTemperatureWithValue:(float)value
{
    [self.colorTemperatureFilter setValue:[CIVector vectorWithX:value Y:0] forKey:@"inputNeutral"];
    [self setImageViewWithOutputImageUsingFilter:self.colorTemperatureFilter];
}

- (void)setImageViewWithOutputImageUsingFilter:(CIFilter *)filter
{
    CIImage *outputImage = [filter outputImage];
    CGImageRef imgRef = [self.context createCGImage:outputImage fromRect:[outputImage extent]];
    self.image = [UIImage imageWithCGImage:imgRef];
    CGImageRelease(imgRef);
}

#pragma makr - Button States
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

#pragma mark - Helpers
- (void)setInputImageForColorTemperatureFilter
{
    CIFilter *filter = [CIFilter filterWithName:@"CIColorControls"];
    [filter setValue:[self scaledCIImage] forKey:kCIInputImageKey];
    [filter setValue:@(self.saturation) forKey:@"inputSaturation"];
    [filter setValue:@(self.brightness) forKey:@"inputBrightness"];
    [filter setValue:@(self.contrast) forKey:@"inputContrast"];
    
    CIImage *outputImage = [filter outputImage];
    
    [self.colorTemperatureFilter setValue:outputImage forKey:kCIInputImageKey];
}

- (void)setInputImageForColorControlFilter
{
    CIFilter *filter = [CIFilter filterWithName:@"CITemperatureAndTint"];
    [filter setValue:[self scaledCIImage] forKey:kCIInputImageKey];
    [filter setValue:[CIVector vectorWithX:self.colorTemperature Y:0] forKey:@"inputNeutral"];
    [filter setValue:[CIVector vectorWithX:6500.f Y:0] forKey:@"inputTargetNeutral"];
    
    CIImage *outputImage = [filter outputImage];
    
    [self.colorFilter setValue:outputImage forKey:kCIInputImageKey];
    
}

- (CIImage *)scaledCIImage
{
    CGRect bounds = self.scrollView.bounds;
    bounds.size.width -= self.scrollView.contentInset.left + self.scrollView.contentInset.right;
    bounds.size.height -= self.scrollView.contentInset.top + self.scrollView.contentInset.bottom;
    
    CGFloat xScale = bounds.size.width / self.originImage.size.width;
    CGFloat yScale = bounds.size.height / self.originImage.size.height;
    CGFloat minScale = MIN(xScale, yScale);
    
    CGFloat scale = self.scrollView.zoomScale * minScale;
    
    UIImage *scaledImage = [self.originImage scaleWithScale:scale];
    return [CIImage imageWithCGImage:scaledImage.CGImage];
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
