//
//  MEExpandableHeaderView.m
//  Expandable Header View
//
// 
// The MIT License (MIT)
// 
// Copyright (c) 2014-2016 Pablo Ezequiel Romero
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

#import "MEExpandableHeaderView.h"
#import "UIImage+ImageEffects.h"
#import <QuartzCore/QuartzCore.h>

@interface MEExpandableHeaderView()<UIScrollViewDelegate>

@property(nonatomic, strong) UIImage *originalBackgroundImage;
@property(nonatomic, strong, readwrite) UIImageView *backgroundImageView;

@end

@implementation MEExpandableHeaderView
{
    UIImageView *_avatar;
}

#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self commonInit];
}

#pragma mark - Resize

- (void)layoutSubviews
{
    [super layoutSubviews];

    static CGFloat kTopMargin = 30.0f;
    CGFloat kAvatarSize = 128.0f;

    CGFloat bW = self.bounds.size.width;
    CGFloat bH = self.bounds.size.height;

    _avatar.frame = CGRectMake(0.5f * (bW - kAvatarSize), kTopMargin, kAvatarSize, kAvatarSize);
    _avatar.layer.cornerRadius = 0.5f * kAvatarSize;
    _avatar.layer.borderColor = UIColor.whiteColor.CGColor;
    _avatar.layer.borderWidth = 6.0f;
}

- (void)commonInit
{
    _originalHeight = self.bounds.size.height;
    
    _avatar = [[UIImageView alloc] initWithFrame:CGRectZero];
    _avatar.contentMode = UIViewContentModeScaleToFill;
    _avatar.clipsToBounds = YES;
    _avatar.image = [UIImage imageNamed:@"defaultAvatar"];
}

#pragma mark - Setup

- (void)setBackgroundImage:(UIImage*)backgroundImage
{
    _backgroundImage = backgroundImage;
    _originalBackgroundImage = backgroundImage;
    
    if (_backgroundImage && !_backgroundImageView)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self insertSubview:imageView atIndex:0];
        [imageView addSubview:_avatar];
        _backgroundImageView = imageView;
    }
    
    _backgroundImageView.image = _backgroundImage;
}

#pragma mark - Public

- (void)offsetDidUpdate:(CGPoint)newOffset
{
    _offset = newOffset.y;
    [self _updateBlur:newOffset];
    if (newOffset.y <= 0) {
        CGAffineTransform translate = CGAffineTransformMakeTranslation(0, newOffset.y);
        CGFloat scaleFactor = (_originalHeight - 2 * newOffset.y) / _originalHeight;
        CGAffineTransform translateAndZoom = CGAffineTransformScale(translate, scaleFactor, scaleFactor);
        _backgroundImageView.transform = translateAndZoom;
    }
}

- (void)_updateBlur:(CGPoint)newOffset
{
    if (newOffset.y <= 0) {
        float radius = -newOffset.y / 40.0;
        self.backgroundImageView.image = [self.originalBackgroundImage applyBlurWithRadius:radius
                                                                                 tintColor:nil
                                                                     saturationDeltaFactor:1.0
                                                                                 maskImage:nil];
    }
}

@end
