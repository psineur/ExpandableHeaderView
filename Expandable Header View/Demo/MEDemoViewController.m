//
//  MEDemoViewController.m
//  Expandable Header View
//
//  Created by Pablo Romero on 6/12/14.
//  Copyright (c) 2014 Microeditionbiz. All rights reserved.
//

#import "MEDemoViewController.h"
#import "MEExpandableHeaderView.h"
#import <Foundation/Foundation.h>

@interface MEDemoViewController ()<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) MEExpandableHeaderView *headerView;
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
}

#pragma mark - Setup

- (void)setupHeaderView
{
    _headerView = [[MEExpandableHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 240)];
    self.headerView.backgroundImage = [UIImage imageNamed:@"beach"];
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
}

@end
