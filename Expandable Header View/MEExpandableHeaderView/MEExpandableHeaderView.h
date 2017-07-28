//
//  MEExpandableHeaderView.h
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

#import <UIKit/UIKit.h>

@interface MEExpandableHeaderView : UIView

@property(nonatomic, readonly, assign) CGFloat offset;
@property(nonatomic, strong) UIImage *backgroundImage;
@property(nonatomic, assign, readonly) CGFloat originalHeight;

/**
 *	@brief		This method is used to get notified when the container table view's offset was
 *				updated.
 *
 *	@details	When this method is called, it will update current zoom level and blur level
 *				of the background image. The value Y of the new offset will be user for that.
 *				The pages' content will be kept centered.
 *
 *	@param		newOffset			New offset value.
 *
 */
- (void)offsetDidUpdate:(CGPoint)newOffset;

@end
