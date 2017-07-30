# SUPHeaderView 

[![Version](https://img.shields.io/cocoapods/v/SUPHeaderView.svg?style=flat)](http://cocoapods.org/pods/SUPHeaderView)
[![License](https://img.shields.io/cocoapods/l/SUPHeaderView.svg?style=flat)](http://cocoapods.org/pods/SUPHeaderView)
[![Platform](https://img.shields.io/cocoapods/p/SUPHeaderView.svg?style=flat)](http://cocoapods.org/pods/SUPHeaderView)

# Demo

![ExpandableHeaderView](https://user-images.githubusercontent.com/507338/28742031-fbfedc9e-73e1-11e7-9ec1-6648cda9fb4d.gif)

## Description

MEExpandableHeaderView without pages & with alternative collapsed mode content.
Almost completely redone fork of https://github.com/microeditionbiz/ExpandableHeaderView

SUPHeaderView's goal is to provide a nice header for User Profile with Media/Content presented
in UITableView. It reproduces the behaviour that you can find in Twitter's profile section, 
when the user scrolls down that section and the header is expanded and blurred, or when user scrolls up 
and header collapses and shows minimum info with smaller UI.


## Usage

First create SUPHeaderView with valid sizes:

```
  _headerView = [[SUPHeaderView alloc] initWithFullsizeHeight:140 shrinkedHeight:60];
  _headerView.backgroundView.image = [UIImage imageNamed:@"someImage"];
```

To add content into fullsize mode of the headerView - use:
```
  _headerView.fullsizeContentView
```

For shrinked:
```
  _headerView.shrinkedContentView 
```

You can use onLayout() block property to customize layout of your views within fullsizeContentView
and shrinkedContentView.
After initializing SUPHeaderView with content and custom layout - set it's frame to trigger initial layout.
After that all you need to do is to integrate it into your tableView, but implementing following methods:

```
  - (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
  {
    return _headerView;
  }


  - (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
  {
    return self.headerView.frame.size.height;
  }

  - (void)scrollViewDidScroll:(UIScrollView *)scrollView
  {
    [self.headerView tableView:self.tableView didUpdateContentOffset:scrollView.contentOffset];
  }
```

## Requirements
UIKit, Accelerate, iOS >= 8

## Installation

SUPHeaderView is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "SUPHeaderView"
```

## License

SUPHeaderView is available under the MIT license. See the LICENSE file for more info.
