//
//  FJDetailContentView.h
//  FJDoubleDeckRollViewDemo
//
//  Created by fjf on 2017/6/9.
//  Copyright © 2017年 fjf. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FJDetailContentView;
@class FJDetailContentBaseViewController;

@protocol FJDetailContentViewDelegate <NSObject>
// 获取 导航栏 移动 距离
- (CGFloat)navigationTransformTyWithDetailContentView:(FJDetailContentView *)detailContentView;
// 滚动 代理
- (void)detailContentView:(FJDetailContentView *)detailContentView scrollView:(UIScrollView *)scrollView;
// 滚动 和 点击 代理
- (void)detailContentView:(FJDetailContentView *)detailContentView selectedIndex:(NSInteger)selectedIndex;
// 是否 偏移 顶部 导航栏
- (void)detailContentView:(FJDetailContentView *)detailContentView isOffsetNavigationHeaderView:(BOOL)isoffSet;

@end

@interface FJDetailContentView : UIView
// 选中 索引
@property (nonatomic, assign) NSInteger selectedIndex;
// 内容 viewArray
@property (nonatomic, strong) NSArray *detailContentViewArray;

// viewController Array
@property (nonatomic, strong) NSMutableArray <FJDetailContentBaseViewController *>*viewControllerArray;
// 代理
@property (nonatomic, weak)  id <FJDetailContentViewDelegate> delegate;
@end
