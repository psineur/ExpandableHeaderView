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

@interface MEExpandableHeaderView()
@end

@implementation MEExpandableHeaderView
{
    UIImage *_originalBackgroundImage;
}

#pragma mark - Public

+ (Class)backgroundImageViewClass
{
    return [UIImageView class];
}

- (instancetype)initWithFullsizeHeight:(CGFloat)fullsizeHeight shrinkedHeight:(CGFloat)shrinkedHeight
{
    if (self = [super initWithFrame:CGRectZero]) {
        _originalHeight = fullsizeHeight;
        _shrinkHeight = shrinkedHeight;
        
        _backgroundImageView = [[[[self class] backgroundImageViewClass] alloc] initWithFrame:CGRectZero];
        _backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
        _backgroundImageView.clipsToBounds = YES;
        _backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self addSubview:_backgroundImageView];
        
        UIView *fullsizeSuperview = [[UIView alloc] initWithFrame:CGRectZero];
        _fullsizeContentView = [[UIView alloc] initWithFrame:CGRectZero];
        fullsizeSuperview.clipsToBounds = YES;
        [fullsizeSuperview addSubview:_fullsizeContentView];
        [self addSubview:fullsizeSuperview];

        UIView *shrinkSuperview = [[UIView alloc] initWithFrame:CGRectZero];
        _shrinkedContentView = [[UIView alloc] initWithFrame:CGRectZero];
        shrinkSuperview.clipsToBounds = YES;
        [shrinkSuperview addSubview:_shrinkedContentView];
        [self addSubview:shrinkSuperview];
    }
    
    return self;
}

- (void)resetBackgroundImage
{
    _originalBackgroundImage = nil;
}

- (void)tableView:(UITableView *)tableView didUpdateContentOffset:(CGPoint)newOffset
{
    [self _updateBackgroundImageViewBlur:newOffset];

    if (newOffset.y <= 0) {
        CGAffineTransform translate = CGAffineTransformMakeTranslation(0, newOffset.y);
        CGFloat scaleFactor = (_originalHeight - 2 * newOffset.y) / _originalHeight;
        CGAffineTransform translateAndZoom = CGAffineTransformScale(translate, scaleFactor, scaleFactor);
        _backgroundImageView.transform = translateAndZoom;
    }
    
    if (newOffset.y > 0) {
        [tableView beginUpdates];
        CGRect headerViewRect = self.frame;
        headerViewRect.origin = CGPointZero;
        headerViewRect.size.height = MAX(_originalHeight - newOffset.y, _shrinkHeight);
        self.frame = headerViewRect;
        [tableView endUpdates];
    }
}

#pragma mark - Private

- (void)layoutSubviews
{
    [super layoutSubviews];

    // Update shrinked content view
    CGFloat shrinkY = 2 * (self.frame.size.height - _shrinkHeight);
    _shrinkedContentView.superview.frame = self.bounds;
    _shrinkedContentView.frame = CGRectMake(0, shrinkY, _shrinkedContentView.superview.bounds.size.width, _shrinkHeight);

    // Update fullsize content view
    CGFloat fullY = - _originalHeight + shrinkY * _originalHeight / (2.0f * (_originalHeight - _shrinkHeight));
    _fullsizeContentView.superview.frame = self.bounds;
    _fullsizeContentView.frame = CGRectMake(0, fullY, _fullsizeContentView.superview.bounds.size.width, _originalHeight);
    
    if (self.onLayout) {
        self.onLayout(self, _fullsizeContentView, _shrinkedContentView);
    }
}

- (void)_updateBackgroundImageViewBlur:(CGPoint)newOffset
{
    if (!_backgroundImageView.image) {
        return;
    }
    
    if (!_originalBackgroundImage) {
        _originalBackgroundImage = _backgroundImageView.image;
    }
    
    if (newOffset.y <= 0) {
        float radius = -newOffset.y / 40.0;
        self.backgroundImageView.image = [_originalBackgroundImage applyBlurWithRadius:radius
                                                                             tintColor:nil
                                                                 saturationDeltaFactor:1.0
                                                                             maskImage:nil];
    }
}

@end
