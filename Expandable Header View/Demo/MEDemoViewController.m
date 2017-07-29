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
@property(nonatomic, strong) UIView *headerViewClipToBoundsSubview;
@property(nonatomic, strong) UIView *headerViewShrinkedContent;
@property(nonatomic, strong) IBOutlet UITableView *tableView;

@property(nonatomic, retain) NSArray *elementsList;

@end

@implementation MEDemoViewController

#pragma mark - View controller lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupElements];
    [self setupHeaderView];
    self.navigationItem.title = @"Profile";
}

#pragma mark - Setup

static const CGFloat kShrinkSize = 30.0f;
static const CGFloat kFullSize = 180.0f;
- (void)setupHeaderView
{
    _headerView = [[MEExpandableHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, kFullSize)];
    self.headerView.backgroundImage = [UIImage imageNamed:@"beach"];
    [self.headerView addSubview:({
        UIView *clipToBoundsSubview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, kFullSize)];
        clipToBoundsSubview.backgroundColor = UIColor.clearColor;
        self.headerViewShrinkedContent = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, kShrinkSize)];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, kShrinkSize)];
        label.text = @"PLZ Refactor ME!";
        label.font = [UIFont systemFontOfSize:24.0f];
        label.contentMode = UIViewContentModeCenter;
        [self.headerViewShrinkedContent addSubview:label];
        clipToBoundsSubview.clipsToBounds = YES;
        [clipToBoundsSubview addSubview:self.headerViewShrinkedContent];
        self.headerViewClipToBoundsSubview = clipToBoundsSubview;
    })];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.headerViewClipToBoundsSubview.frame = self.headerView.bounds;

    [self _updateShrinkViewPosition];
}

- (void)_updateShrinkViewPosition
{
    CGFloat yPosition = 2 * (self.headerView.frame.size.height - kShrinkSize);
    self.headerViewClipToBoundsSubview.frame = self.headerView.bounds;
    self.headerViewShrinkedContent.frame = CGRectMake(0, yPosition, self.headerViewShrinkedContent.superview.bounds.size.width, kShrinkSize);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return self.headerView.frame.size.height;
}

- (void)setupElements
{
    static NSUInteger const kElementsCount = 40;
    
    NSMutableArray *elementsList = [NSMutableArray arrayWithCapacity:kElementsCount];
    
    for (NSUInteger index = 1; index <= kElementsCount; index++)
    {
        [elementsList addObject:[NSString stringWithFormat:@"Row %lu", (unsigned long)index]];
    }
    
    self.elementsList = [NSArray arrayWithArray:elementsList];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.elementsList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"defaultCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    NSString *rowText = [self.elementsList objectAtIndex:indexPath.row];
    cell.textLabel.text = rowText;
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.headerView offsetDidUpdate:scrollView.contentOffset];
    if (scrollView.contentOffset.y > 0) {
        [self.tableView beginUpdates];
        CGRect headerViewRect = self.headerView.frame;
        headerViewRect.origin = CGPointZero;
        headerViewRect.size.height = MAX(self.headerView.originalHeight - scrollView.contentOffset.y, kShrinkSize);
        self.headerView.frame = headerViewRect;
        [self.tableView endUpdates];
    }
    [self _updateShrinkViewPosition];
}

@end
