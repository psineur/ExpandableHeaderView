//
//  SUPHeaderView.m
//  Expandable Header View
//
// 
// The MIT License (MIT)
// 
// Copyright (c) 2014-2016 Pablo Ezequiel Romero
// Copyright (c) 2017 Stepan Generalov
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

#import <QuartzCore/QuartzCore.h>
#import "SUPHeaderView.h"
#import <Accelerate/Accelerate.h>

@interface SUPHeaderView()
@end

@implementation SUPHeaderView
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
        CGFloat scaleFactor = (_originalHeight - 2 * newOffset.y) / _originalHeight;
        CGFloat newWidth = self.bounds.size.width * scaleFactor;
        _backgroundImageView.frame = CGRectMake(0.5f * (self.bounds.size.width - newWidth),
                                                newOffset.y,
                                                newWidth,
                                                self.bounds.size.height * scaleFactor);
    } else {
        _backgroundImageView.frame = self.bounds;
    }
    
    CGRect headerViewRect = self.frame;
    headerViewRect.origin = CGPointZero;
    headerViewRect.size.height = MAX(_originalHeight - newOffset.y, _shrinkHeight);
    headerViewRect.size.height = MIN(_originalHeight, headerViewRect.size.height);
    if (!CGRectEqualToRect(self.frame, headerViewRect)) {
        [tableView beginUpdates];
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
    
    if (newOffset.y < 0) {
        float radius = 2 - newOffset.y / 10.0;
        self.backgroundImageView.image = [self _blurImage:_originalBackgroundImage withRadius:radius iterations:1 ratio:1.0f blendColor:nil blendMode:kCGBlendModeNormal];
    } else {
        self.backgroundImageView.image = _originalBackgroundImage;
    }
}

// Objective-C version of UIImage category from DynamicBlurView (https://github.com/KyoheiG3/DynamicBlurView/)
// by Kyohei Ito - je.suis.kyohei@gmail.com
- (UIImage *)_blurImage:(UIImage *)image
             withRadius:(CGFloat)radius
             iterations:(int)iterations
                  ratio:(CGFloat)ratio
             blendColor:(UIColor * _Nullable)blendColor
              blendMode:(CGBlendMode)blendMode
{
    if (floorf(image.size.width) * floorf(image.size.height) <= 0.0 || radius <= 0) {
        return image;
    }
    
    CGImageRef imageRef = image.CGImage;
    if (!imageRef) {
        return nil;
    }
    
    uint32_t boxSize = (uint32_t)(radius * image.scale * ratio);
    if (boxSize % 2 == 0) {
        boxSize += 1;
    }

    size_t width = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    size_t rowBytes = CGImageGetBytesPerRow(imageRef);
    size_t bytes = rowBytes * height;

    void *inData = malloc(bytes);
    vImage_Buffer inBuffer = {inData, (vImagePixelCount)height, (vImagePixelCount)width, rowBytes};
    void *outData = malloc(bytes);
    vImage_Buffer outBuffer = {outData, (vImagePixelCount)height, (vImagePixelCount)width, rowBytes};

    vImage_Flags tempFlags = kvImageEdgeExtend | kvImageGetTempBufferSize;
    vImage_Error tempSize = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, nil, 0, 0, boxSize, boxSize, nil, tempFlags);
    void *tempBuffer = malloc(tempSize);

    CFDataRef copy = NULL;
    CGContextRef bitmapContext = NULL;
    CGImageRef bitmap = NULL;
    @try {
        CGDataProviderRef provider = CGImageGetDataProvider(imageRef);
        if (!provider) {
            return nil;
        }
        copy = CGDataProviderCopyData(provider);
        const UInt8 *source = CFDataGetBytePtr(copy);
        memcpy(inBuffer.data, source, bytes);
        
        vImage_Flags flags = kvImageEdgeExtend;
        for (int i = 0; i < iterations; ++i) {
            vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, tempBuffer, 0, 0, boxSize, boxSize, nil, flags);
            void *temp = inBuffer.data;
            inBuffer.data = outBuffer.data;
            outBuffer.data = temp;
        }
        CGColorSpaceRef colorSpace = CGImageGetColorSpace(imageRef);
        if (!colorSpace) {
            return nil;
        }
        CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
        bitmapContext = CGBitmapContextCreate(inBuffer.data, width, height, 8, rowBytes, colorSpace, bitmapInfo);
        if (!bitmapContext) {
            return nil;
        }
        UIColor *color = blendColor;
        if (color) {
            CGContextSetFillColorWithColor(bitmapContext, color.CGColor);
            CGContextSetBlendMode(bitmapContext, blendMode);
            CGContextFillRect(bitmapContext, CGRectMake(0, 0, width, height));
        }
        bitmap = CGBitmapContextCreateImage(bitmapContext);
        if (bitmap) {
            return [UIImage imageWithCGImage:bitmap scale:image.scale orientation:image.imageOrientation];
        }
    } @catch (NSException *exception) {} @finally {
        if (copy) {
            CFRelease(copy);
        }
        CGImageRelease(bitmap);
        CGContextRelease(bitmapContext);
        free(outBuffer.data);
        free(tempBuffer);
        free(inBuffer.data);
    }

    return nil;
}

@end
