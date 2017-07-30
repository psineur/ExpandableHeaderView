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

/**
 *
 * Usage: 
 * 
 * First create SUPHeaderView with valid sizes:
 * _headerView = [[SUPHeaderView alloc] initWithFullsizeHeight:140 shrinkedHeight:60];
 * _headerView.backgroundView.image = [UIImage imageNamed:@"someImage"];
 * 
 * To add content into fullsize mode of the headerView - use:
 *   _headerView.fullsizeContentView
 * For shrinked:
 *   _headerView.shrinkedContentView 
 *
 * You can use onLayout() block property to customize layout of your views within fullsizeContentView
 * and shrinkedContentView
 * 
 * After initializing SUPHeaderView with content and custom layout - set it's frame to trigger initial layout.
 *
 * After that all you need to do is to integrate it into your tableView, but implementing following methods:
 *
 * - (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
 * {
 *   return _headerView;
 * }
 *
 *
 * - (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
 * {
 *     return self.headerView.frame.size.height;
 * }
 * 
 * - (void)scrollViewDidScroll:(UIScrollView *)scrollView
 * {
 *     [self.headerView tableView:self.tableView didUpdateContentOffset:scrollView.contentOffset];
 * }
 */
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
