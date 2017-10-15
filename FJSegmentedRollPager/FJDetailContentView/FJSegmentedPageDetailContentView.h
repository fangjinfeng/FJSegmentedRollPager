//
//  FJDetailContentView.h
//  FJDoubleDeckRollViewDemo
//
//  Created by fjf on 2017/6/9.
//  Copyright © 2017年 fjf. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FJSegmentedPageDetailContentView;
@class FJContentPageBaseViewController;

@protocol FJDetailContentViewDelegate <NSObject>

@optional
// 获取 导航栏 移动 距离
- (CGFloat)navigationTransformTyWithDetailContentView:(FJSegmentedPageDetailContentView *)detailContentView;
// 滚动 代理
- (void)detailContentView:(FJSegmentedPageDetailContentView *)detailContentView scrollView:(UIScrollView *)scrollView;
// 滚动 和 点击 代理
- (void)detailContentView:(FJSegmentedPageDetailContentView *)detailContentView selectedIndex:(NSInteger)selectedIndex;
// 是否 偏移 顶部 导航栏
- (void)detailContentView:(FJSegmentedPageDetailContentView *)detailContentView isOffsetNavigationHeaderView:(BOOL)isoffSet;

@end

@interface FJSegmentedPageDetailContentView : UIView
// 选中 索引
@property (nonatomic, assign) NSInteger selectedIndex;
// 内容 viewArray
@property (nonatomic, strong) NSArray *detailContentViewArray;

// viewController Array
@property (nonatomic, strong) NSMutableArray <FJContentPageBaseViewController *>*viewControllerArray;
// 代理
@property (nonatomic, weak)  id <FJDetailContentViewDelegate> delegate;
@end
