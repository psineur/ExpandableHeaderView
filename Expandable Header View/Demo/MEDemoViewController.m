//
//  MEDemoViewController.m
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

#import "MEDemoViewController.h"
#import "MEExpandableHeaderView.h"
#import <Foundation/Foundation.h>

@interface MEDemoViewController () <UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong) MEExpandableHeaderView *headerView;
@property(nonatomic, strong) IBOutlet UITableView *tableView;
@property(nonatomic, retain) NSArray *elementsList;
@end

@implementation MEDemoViewController
{
    UIImageView *_avatar;
    UILabel *_label;

    UIImageView *_shrinkedAvatar;
    UILabel *_shrinkedLabel;
}

#pragma mark - View controller lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"Profile";
    self.elementsList = @[@"Row 1", @"Row 2", @"Row 3", @"Row 4",
                          @"Row 5", @"Row 6", @"Row 7", @"Row 8",
                          @"Row 9", @"Row 10", @"Row 11", @"Row 12",
                          @"Row 13", @"Row 14", @"Row 15", @"Row 16",
                          @"Row 17", @"Row 18", @"Row 19", @"Row 20",
                          @"Row 21", @"Row 22", @"Row 23", @"Row 24",
                          @"Row 25", @"Row 26", @"Row 27", @"Row 28",
                          @"Row 29", @"Row 30", @"Row 31", @"Row 32",
                          @"Row 33", @"Row 34", @"Row 35", @"Row 36",
                          @"Row 37", @"Row 38", @"Row 38", @"Row 40"];

    [self setupHeaderView];
}

#pragma mark - IMPORTANT: Header View Use

static const CGFloat kShrinkSize = 30.0f;
static const CGFloat kFullSize = 180.0f;
- (void)setupHeaderView
{
    _headerView = [[MEExpandableHeaderView alloc] initWithFullsizeHeight:kFullSize shrinkedHeight:kShrinkSize];

    // Background Image is going to be Scaled & Blured
    self.headerView.backgroundImageView.image = [UIImage imageNamed:@"beach"];

    // shrinkedContentView has fixed height and becomes visible when headerView is collapsed
    [self.headerView.shrinkedContentView addSubview:({
        _shrinkedLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, kShrinkSize)];
        _shrinkedLabel.text = @"John Smith";
        _shrinkedLabel.font = [UIFont systemFontOfSize:24.0f];
        _shrinkedLabel.contentMode = UIViewContentModeCenter;
        _shrinkedLabel.shadowColor = [UIColor whiteColor];
        _shrinkedLabel.shadowOffset = CGSizeMake(2,2);
        _shrinkedLabel;
    })];
    [self.headerView.shrinkedContentView addSubview:({
        _shrinkedAvatar = [[UIImageView alloc] initWithFrame:CGRectZero];
        _shrinkedAvatar.contentMode = UIViewContentModeScaleToFill;
        _shrinkedAvatar.clipsToBounds = YES;
        _shrinkedAvatar.layer.borderColor = UIColor.whiteColor.CGColor;
        _shrinkedAvatar.layer.borderWidth = 2.0f;
        _shrinkedAvatar.image = [UIImage imageNamed:@"defaultAvatar"];
        _shrinkedAvatar;
    })];

    // fullsizeContentView has fixed height and is hidden when headerView is collapsed
    [self.headerView.fullsizeContentView addSubview:({
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, kShrinkSize)];
        _label.text = @"John Smith";
        _label.font = [UIFont systemFontOfSize:32.0f];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.shadowColor = [UIColor whiteColor];
        _label.shadowOffset = CGSizeMake(2,2);
        _label;
    })];
    [self.headerView.fullsizeContentView addSubview:({
        _avatar = [[UIImageView alloc] initWithFrame:CGRectZero];
        _avatar.contentMode = UIViewContentModeScaleToFill;
        _avatar.clipsToBounds = YES;
        _avatar.image = [UIImage imageNamed:@"defaultAvatar"];
        _avatar;
    })];

    // Use onLayout to customize layout of your subviews within header
    __weak __typeof(self) weakSelf = self;
    self.headerView.onLayout = ^(UIView *headerView, UIView *fullsizeContentView, UIView *shrinkedContentView) {
        __strong __typeof(self) strongSelf = weakSelf;
        UIImageView *avatar = strongSelf->_avatar;
        static CGFloat kTopMargin = 16.0f;
        CGFloat kAvatarSize = 128.0f;
        CGFloat bW = fullsizeContentView.bounds.size.width;
        avatar.frame = CGRectMake(0.5f * (bW - kAvatarSize), kTopMargin, kAvatarSize, kAvatarSize);
        avatar.layer.cornerRadius = 0.5f * kAvatarSize;
        avatar.layer.borderColor = UIColor.whiteColor.CGColor;
        avatar.layer.borderWidth = 6.0f;
        strongSelf->_label.frame = CGRectMake(0, CGRectGetMaxY(avatar.frame) + 4.0f, weakSelf.tableView.bounds.size.width, 32.0f);

        CGRect shrinkAvatarFrame = CGRectMake(0, 0, kShrinkSize, kShrinkSize);
        strongSelf->_shrinkedAvatar.frame = shrinkAvatarFrame;
        strongSelf->_shrinkedAvatar.layer.cornerRadius = 0.5f * kShrinkSize;
        strongSelf->_shrinkedLabel.frame = CGRectMake(CGRectGetMaxX(shrinkAvatarFrame), 0, weakSelf.tableView.bounds.size.width, kShrinkSize);
    };

    // Set frame after initializing subviews to update layout.
    _headerView.frame = CGRectMake(0, 0, self.tableView.bounds.size.width, kFullSize);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    // ATTENTION: use headerView frame height in order to enable Shrinking/Collapsing of the Header
    return self.headerView.frame.size.height;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // ATTENTION: call this method to enable stretching & collapsing of headerView
    [self.headerView tableView:self.tableView didUpdateContentOffset:scrollView.contentOffset];
}

#pragma mark - Table View Example Stuff - not Important

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath { return 44.0f; }
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView { return 1; }
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section { return _elementsList.count; }
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"defaultCell"];
    cell.textLabel.text =  _elementsList[indexPath.row];
    return cell;
}

@end
