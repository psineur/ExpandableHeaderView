//
//  MEExpandableHeaderView.m
//  Expandable Header View
//
//  Created by Pablo Romero on 6/12/14.
//  Copyright (c) 2014 Microeditionbiz. All rights reserved.
//

#import "MEExpandableHeaderView.h"
#import "UIImage+ImageEffects.h"
#import <QuartzCore/QuartzCore.h>

@interface MEExpandableHeaderView()<UIScrollViewDelegate>

@property(nonatomic, strong) UIImage *originalBackgroundImage;
@property(nonatomic, strong, readwrite) UIImageView *backgroundImageView;

@end

@implementation MEExpandableHeaderView

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
}

- (void)commonInit
{
    _originalHeight = self.bounds.size.height;
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
        _backgroundImageView = imageView;
    }
    
    _backgroundImageView.image = _backgroundImage;
}

#pragma mark - Public

- (void)offsetDidUpdate:(CGPoint)newOffset
{
    _offset = newOffset.y;
    [self _updateBlur:newOffset];
    if (newOffset.y <= 0)
    {
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
