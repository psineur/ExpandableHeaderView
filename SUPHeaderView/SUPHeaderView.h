//
//  SUPHeaderView.h
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

#import <UIKit/UIKit.h>

@interface SUPHeaderView : UIView

@property(nonatomic, assign, readonly) CGFloat originalHeight;
@property(nonatomic, assign, readonly) CGFloat shrinkHeight;

@property(nonatomic, copy, readwrite) void (^onLayout)(UIView *headerView, UIView *fullsizeContent, UIView *shrinkContent);

@property(nonatomic, strong, readonly) UIImageView *backgroundImageView;
@property(nonatomic, strong, readonly) UIView *shrinkedContentView;
@property(nonatomic, strong, readonly) UIView *fullsizeContentView;

/** 
 * Provides class for backgroundImageView, default is UIImageView,
 * Override this method to return your own UIImageView subclass/compatible class (e.g. PFImageView)
 */
+ (Class)backgroundImageViewClass;
- (instancetype)initWithFullsizeHeight:(CGFloat)fullsizeHeight shrinkedHeight:(CGFloat)shrinkedHeight;

/** 
 * Call if backgroundImageView.image was changed.
 */
- (void)resetBackgroundImage;

/**
 * Forward -scrollViewDidScroll: here.
 * ATTENTION: this method changes self.frame and issue begin/end updates to tableView.
 * 
 * @param tableView used to call -beginUpdates & -endUpdates on
 */
- (void)tableView:(UITableView *)tableView didUpdateContentOffset:(CGPoint)newOffset;

@end
