//
//  FJCourseClassifyDefine.h
//  FJCourseClassifySectionView
//
//  Created by fjf on 2017/7/20.
//  Copyright © 2017年 fjf. All rights reserved.
//

#ifndef FJCourseClassifyDefine_h
#define FJCourseClassifyDefine_h

#import "FJConfigModel.h"
#import "UIView+Extension.h"


// 搜索栏 高度
#define kFJNavigationSearchViewHeight 64.0f

// 分类栏 高度
#define kFJCourseClassifySectionHeight 40.0f

// 标题栏 cell  间距
#define kFJSegmentdTitleTagSectionViewCellSpacing 32.0f

// 偏移 距离 限制
#define  kFJNavigationHederViewContentOffset  40.0f

// 顶部导航栏 高度
#define kFJCourseNavigationHeaderViewHeight 104.0f

// 标题栏 水平 间距
#define kFJSegmentdTitleTagSectionViewHorizontalEdgeSpacing 12.0f




// 子tableView 偏移 通知
static NSString *const kFJCourseClassifySubScrollViewOffsetNoti = @"kFJCourseClassifySubScrollViewOffsetNoti";

// 子tableView滚动 通知
static NSString *const kFJCourseClassifySubScrollViewDidScrollNoti = @"kFJCourseClassifySubScrollViewDidScrollNoti";

// 子tableView滚动 到 顶部 通知
static NSString *const kFJCourseClassifySubScrollViewScrollToTopNoti = @"kFJCourseClassifySubScrollViewScrollToTopNoti";



// 颜色

//(这个以后去掉)
#define FJColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//使用这个配置
#define FJColorFromRGBA(rgbValue, a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]

// 分段 标题 字体 普通 颜色
#define kFJSegmentedTitleNormalColor FJColorFromRGB(0xA7A7A7)

// 分段 标题 字体 选中 颜色
#define kFJSegmentedTitleSelectedColor FJColorFromRGB(0x51D6AA)

// 分段 标题 字体 高亮 颜色
#define kFJSegmentedTitleHighlightColor FJColorFromRGB(0x51D6AA)

// 分段 标题 字体 高亮 颜色
#define kFJSegmentedIndicatorViewColor FJColorFromRGB(0x51D6AA)

// 分割线 背景 颜色
#define kFJBottomLineViewBackgroundColor FJColorFromRGB(0xEEEEF2)

// tableView 背景 颜色
#define kFJTableViewBackgroundColor FJColorFromRGB(0xF7F7FA)

// tagSectionView backgroundColor
#define kFJTagSectionViewBackgroundColor FJColorFromRGB(0xFFFFFF)

// navigationView backgroundColor
#define kFJNavigationViewBackgroundColor FJColorFromRGB(0xFFFFFF)

// controllerView backgroundColor
#define kFJControllerViewBackgroundColor FJColorFromRGB(0xF7F7FA)

/** 字体 **/

// font
#define kFJSystemFontSize(a) [UIFont systemFontOfSize:a]

// 分段 标题 字体 大小
#define kFJSegmentedTitleFontSize kFJSystemFontSize(14)

/** 高度 **/

// 分割线 默认 高度
#define kFJSegmentedBottomLineViewHeight    0.5
// 指示条 默认 高度
#define kFJSegmentedIndicatorViewHeight     2.0

// 指示条 默认 宽度
#define kFJSegmentedIndicatorViewWidth      56.0f
// 标题 默认 宽度
#define kFJSegmentedTitleViewTitleWidth     80.0f

#endif /* FJCourseClassifyDefine_h */
