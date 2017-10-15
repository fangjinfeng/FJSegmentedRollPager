//
//  FJSegmentdTitleTagSectionView.h
//  FJDoubleDeckRollViewDemo
//
//  Created by fjf on 2017/6/9.
//  Copyright © 2017年 fjf. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FJSegmentdTitleTagSectionView;
// 代理
@protocol FJSegmentdTitleTagSectionViewDelegate <NSObject>
// 当前 点击 index
- (void)titleSectionView:(FJSegmentdTitleTagSectionView *)titleSectionView clickIndex:(NSInteger)index;

@end

@interface FJSegmentdTitleTagSectionView : UIView
// item size
@property (nonatomic, assign) CGSize tagItemSize;
// 指示器 高度
@property (nonatomic, assign) CGFloat indicatorHeight;
// 指示器 宽度
@property (nonatomic, assign) CGFloat indicatorWidth;
// 标题 数据 数组
@property (nonatomic, strong) NSArray *tagTitleArray;
// 选中 索引
@property (nonatomic, assign) NSUInteger selectedIndex;
// 标题 栏 高度
@property (nonatomic, assign) CGFloat tagSectionViewHeight;
// 代理
@property (nonatomic, weak)   id <FJSegmentdTitleTagSectionViewDelegate> delegate;
@end
