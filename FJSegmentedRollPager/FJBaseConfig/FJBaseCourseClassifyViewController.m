

//
//  FJBaseCourseClassifyViewController.m
//  FJCourseClassifySectionView
//
//  Created by fjf on 2017/7/20.
//  Copyright © 2017年 fjf. All rights reserved.
//

#import "UITabBar+Gradient.h"
#import "FJSegmentedPageDetailContentView.h"
#import "FJSegmentdTitleTagSectionView.h"
#import "FJNavigationHederView.h"
#import "FJCourseClassifyDefine.h"
#import "FJNavigationSearchView.h"
#import "UINavigationBar+Gradient.h"
#import "FJCourseClassifyDefine.h"
#import "FJBaseCourseClassifyViewController.h"


// 标签栏 高度
const CGFloat kStatusBarHeight = 49.0f;
// 导航栏 高度
const CGFloat kNavigationBarHeight = 104.0f;
// 动画   默认 时间
const CGFloat kDefaultAnimationTime = 0.3f;


@interface FJBaseCourseClassifyViewController ()<FJSegmentdTitleTagSectionViewDelegate,FJDetailContentViewDelegate> {
    CGFloat _originalOffsetY; //上一次偏移量
}

// 状态 栏 view
@property (nonatomic, strong) UIView *topStatusBarView;
// 点击 返回 到 顶部view
@property (nonatomic, strong) UIView *scrollToTopTapView;
// navigation view
@property (nonatomic, strong) FJNavigationHederView *navigationHederView;
// detail contentView
@property (nonatomic, strong) FJSegmentedPageDetailContentView *detailContentView;


@end

@implementation FJBaseCourseClassifyViewController

#pragma mark --- life circle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addNotiObserver];
    [self setupBaseCourseClassifyControls];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[self statusBar] addSubview:self.scrollToTopTapView];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.scrollToTopTapView removeFromSuperview];
}

#pragma mark --- private method
// 设置 子控件
- (void)setupBaseCourseClassifyControls {
    
    [self.view addSubview:self.navigationHederView];
    [self.view addSubview:self.detailContentView];
    [self.view bringSubviewToFront:self.navigationHederView];
    [self.view addSubview:self.topStatusBarView];
}

// 添加 监听 通知
- (void)addNotiObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollViewDidOffset:) name:kFJCourseClassifySubScrollViewDidScrollNoti object:nil];
}


// 设置 子控件 数据源
- (void)setupControlsDataArray:(NSArray *)configModelArray {
    NSMutableArray *tmpTitleArray = [NSMutableArray array];
    [_configModelArray enumerateObjectsUsingBlock:^(FJConfigModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [tmpTitleArray addObject:[obj.titleStr copy]];
    }];
    self.navigationHederView.tagSecionView.tagTitleArray = tmpTitleArray;
    self.detailContentView.detailContentViewArray = configModelArray;
}


/************************************ navigationHederView 相关 ****************************/

// 显示navigationBar 和 tabbar
- (void)showNavigationBarAndStatusBar {
    [self setNavigationBarTransformProgress:0 navigationBarStatusType:NavigationBarStatusOfTypeShow];
    [self setStatusBarTransformProgress:0 statusBarStatusType:StatusBarStatusTypeOfShow];
}

//隐藏navigationBar 和 tabbar
- (void)hideNavigationBarAndStatusBar {
    [self setNavigationBarTransformProgress:1 navigationBarStatusType:NavigationBarStatusOfTypeHidden];
    [self setStatusBarTransformProgress:1 statusBarStatusType:StatusBarStatusTypeOfHidden];
}


//恢复或隐藏navigationBar和statusBar
- (void)restoreNavigationBarAndStatusBarWithContentOffset:(CGPoint)contentOffset {
    CGFloat navigationBarCenterHeight  = kNavigationBarHeight/2.0;
    CGFloat transformTy = self.navigationHederView.transform.ty;
    if (transformTy < 0 && transformTy > -kNavigationBarHeight) {
        if (transformTy < -navigationBarCenterHeight && contentOffset.y > -navigationBarCenterHeight) {
            [UIView animateWithDuration:kDefaultAnimationTime animations:^{
                [self hideNavigationBarAndStatusBar];
            }];
            
        }else {
            [UIView animateWithDuration:kDefaultAnimationTime animations:^{
                [self showNavigationBarAndStatusBar];
            }];
        }
    }
}


// 通过偏移量移动NavigationBar和StatusBar
- (void)moveNavigationBarAndStatusBarByOffsetY:(CGFloat)offsetY {
    CGFloat transformTy = self.navigationHederView.transform.ty;
    CGFloat tabbarTransformTy = self.tabBarController.tabBar.transform.ty;
    
    // offset 向上滚动
    if (offsetY > 0) {
        if (fabs(transformTy) >= kNavigationBarHeight) {
            //当NavigationBar的transfrom.ty大于NavigationBar高度，导航栏离开可视范围，设置NavigationBar隐藏
            [self setNavigationBarTransformProgress:1 navigationBarStatusType:NavigationBarStatusOfTypeHidden];
        } else {
            //当NavigationBar的transfrom.ty小于NavigationBar高度，导航栏在可视范围内，设置NavigationBar偏移位置和背景透明度
            [self setNavigationBarTransformProgress:offsetY navigationBarStatusType:NavigationBarStatusOfTypeNormal];
        }
        
        if (fabs(tabbarTransformTy) >= kStatusBarHeight) {
            //当StatusTabBar的transfrom.ty大于StatusTabBar高度，导航栏离开可视范围，设置StatusTabBar隐藏
            [self setStatusBarTransformProgress:1 statusBarStatusType:StatusBarStatusTypeOfHidden];
        } else {
            //当当StatusTabBar的transfrom.ty小于StatusTabBar高度，导航栏在可视范围内，设置StatusTabBar偏移位置和背景透明度
            [self setStatusBarTransformProgress:offsetY statusBarStatusType:StatusBarStatusTypeOfNormal];
        }
        // offset 向下滚动
    } else if(offsetY < 0){
        if (transformTy < 0 && fabs(transformTy) <= kNavigationBarHeight) {
            //当NavigationBar的transfrom.ty小于NavigationBar高度，导航栏进入可视范围内，设置NavigationBar偏移位置和背景透明度
            [self setNavigationBarTransformProgress:offsetY navigationBarStatusType:NavigationBarStatusOfTypeNormal];
        } else {
            //当NavigationBar的transfrom.ty超过NavigationBar原来位置，设置NavigationBar显示
            [self setNavigationBarTransformProgress:0 navigationBarStatusType:NavigationBarStatusOfTypeShow];
        }
        
        if (tabbarTransformTy <= kStatusBarHeight && tabbarTransformTy > 0) {
            //当StatusTabBar的transfrom.ty小于StatusTabBar高度，导航栏进入可视范围内，设置StatusTabBar偏移位置和背景透明度
            [self setStatusBarTransformProgress:offsetY statusBarStatusType:StatusBarStatusTypeOfNormal];
        } else {
            //当StatusTabBar的transfrom.ty超过StatusTabBar原来位置，设置StatusTabBar显示
            [self setStatusBarTransformProgress:0 statusBarStatusType:StatusBarStatusTypeOfShow];
        }
    }
    
}

// 根据传入的类型和渐变程度,改变StatusBar的颜色和位置
- (void)setStatusBarTransformProgress:(CGFloat)progress statusBarStatusType:(StatusBarStatusType)statusBarStatusType{
//    CGFloat transfromTy = self.tabBarController.tabBar.transform.ty;
//    if (statusBarStatusType == StatusBarStatusTypeOfHidden) {
//        if (transfromTy != kStatusBarHeight) {
//            [self.tabBarController.tabBar fj_moveByTranslationY:kStatusBarHeight * progress];
//            [self.tabBarController.tabBar fj_setImageViewAlpha:progress];
//        }
//    }else if(statusBarStatusType == StatusBarStatusTypeOfNormal) {
//        [self.tabBarController.tabBar fj_setTranslationY:-progress];
//        CGFloat alpha = 1 - fabs(self.tabBarController.tabBar.transform.ty)/kStatusBarHeight;
//        [self.tabBarController.tabBar fj_setImageViewAlpha:alpha];
//    }else if(statusBarStatusType == StatusBarStatusTypeOfShow) {
//        if (transfromTy != 0) {
//            [self.tabBarController.tabBar fj_moveByTranslationY: -kStatusBarHeight * progress];
//            [self.tabBarController.tabBar fj_setImageViewAlpha:(1-progress)];
//        }
//    }
}

// 根据传入的类型和渐变程度,改变NavigationBar的颜色和位置
- (void)setNavigationBarTransformProgress:(CGFloat)progress navigationBarStatusType:(NavigationBarStatusType)navigationBarStatusType{
    CGFloat transfromTy = self.navigationHederView.transform.ty;
    if (navigationBarStatusType == NavigationBarStatusOfTypeHidden) {
        if(transfromTy != -kNavigationBarHeight){
            [self.navigationHederView fj_moveByTranslationY:-kNavigationBarHeight * progress];
            [self.navigationHederView fj_setImageViewAlpha:progress];
        }
    }else if(navigationBarStatusType == NavigationBarStatusOfTypeNormal) {
        [self.navigationHederView fj_setTranslationY: - progress];
        CGFloat alpha = 1 - fabs(self.navigationHederView.transform.ty)/kNavigationBarHeight;
        [self.navigationHederView fj_setImageViewAlpha:alpha];
    }else if(navigationBarStatusType == NavigationBarStatusOfTypeShow) {
        if(transfromTy != 0){
            [self.navigationHederView fj_moveByTranslationY:-kNavigationBarHeight * progress];
            [self.navigationHederView fj_setImageViewAlpha:(1-progress)];
        }
    }
}

#pragma mark --- noti method


// 偏移 通知
- (void)scrollViewDidOffset:(NSNotification *)noti {
    if ([noti.name isEqualToString:kFJCourseClassifySubScrollViewDidScrollNoti]) {
        UIScrollView *scrollView = (UIScrollView *)noti.object;
        
        [self subScrollViewDidScroll:scrollView];
    }
}

- (void)subScrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat bottomOffset = scrollView.contentSize.height - scrollView.contentOffset.y - scrollView.frame.size.height;
    if (scrollView.contentOffset.y > -kFJCourseNavigationHeaderViewHeight && bottomOffset > 0) {
        CGFloat offsetY = scrollView.contentOffset.y - _originalOffsetY;
        [self moveNavigationBarAndStatusBarByOffsetY:offsetY];
    }
    _originalOffsetY = scrollView.contentOffset.y;
}





#pragma mark --- custom delegate

/******************************* FJSegmentdTitleTagSectionViewDelegate ******************************/

- (void)titleSectionView:(FJSegmentdTitleTagSectionView *)titleSectionView clickIndex:(NSInteger)index {
     self.detailContentView.selectedIndex = index;
}


/******************************* FJDetailContentViewDelegate ******************************/
- (void)detailContentView:(FJSegmentedPageDetailContentView *)detailContentView selectedIndex:(NSInteger)selectedIndex {
    
    self.navigationHederView.tagSecionView.selectedIndex = selectedIndex;
}

// 是否 偏移 顶部 导航栏
- (void)detailContentView:(FJSegmentedPageDetailContentView *)detailContentView isOffsetNavigationHeaderView:(BOOL)isoffSet {
    [self showNavigationBarAndStatusBar];
}

// 获取 导航栏 移动 距离
- (CGFloat)navigationTransformTyWithDetailContentView:(FJSegmentedPageDetailContentView *)detailContentView {
    return self.navigationHederView.transform.ty;
}

#pragma mark --- response event 
// 滚动 到顶部
- (void)postScrollToTopViewNoti {
    NSString *tmpSelectedIndex = [NSString stringWithFormat:@"%ld", self.navigationHederView.tagSecionView.selectedIndex];
    [[NSNotificationCenter defaultCenter] postNotificationName:kFJCourseClassifySubScrollViewScrollToTopNoti object:tmpSelectedIndex];
}

#pragma mark --- setter method
// 设置 模型 值
- (void)setConfigModelArray:(NSArray<FJConfigModel *> *)configModelArray {
    _configModelArray = configModelArray;
    if (_configModelArray.count > 0) {
        self.navigationHederView.tagSecionView.hidden = NO;
        [self setupControlsDataArray:_configModelArray];
        [self setDefaultSelectedIndex];
    }
    else {
        self.navigationHederView.tagSecionView.hidden = YES;
        self.navigationHederView.height = kFJNavigationSearchViewHeight;
    }
}


// 设置 默认 选中 索引
- (void)setDefaultSelectedIndex {
    if (self.selectedIndex == 0) {
        self.selectedIndex = 0;
    }
}

// 设置 选中 索引
- (void)setSelectedIndex:(NSInteger)selectedIndex {
    _selectedIndex = selectedIndex;
    if (self.configModelArray.count) {
        self.navigationHederView.tagSecionView.selectedIndex = selectedIndex;
        self.detailContentView.selectedIndex = selectedIndex;
    }
}

#pragma mark --- getter method

// navigation view
- (FJNavigationHederView *)navigationHederView {
    if (!_navigationHederView) {
        _navigationHederView = [[FJNavigationHederView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, kFJCourseNavigationHeaderViewHeight)];
        _navigationHederView.tagSecionView.delegate = self;
    }
    return _navigationHederView;
}


// detail contentView
- (FJSegmentedPageDetailContentView *)detailContentView {
    if (!_detailContentView) {
        _detailContentView = [[FJSegmentedPageDetailContentView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navigationHederView.frame) - kFJNavigationSearchViewHeight, self.view.frame.size.width, self.view.frame.size.height)];
        _detailContentView.delegate = self;
    }
    return _detailContentView;
}

// 状态栏 view
- (UIView *)topStatusBarView {
    if (!_topStatusBarView) {
        _topStatusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 20.0f)];
        _topStatusBarView.backgroundColor = [UIColor whiteColor];
    }
    return _topStatusBarView;
}

// 点击 返回 到 顶部view
- (UIView *)scrollToTopTapView {
    if (!_scrollToTopTapView) {
        _scrollToTopTapView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 30.0f)];
        _scrollToTopTapView.userInteractionEnabled = YES;
        [_scrollToTopTapView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(postScrollToTopViewNoti)]];
        _scrollToTopTapView.backgroundColor = [UIColor clearColor];
    }
    return _scrollToTopTapView;
}
/**
 用KVC取statusBar
 
 @return statusBar
 */
- (UIView *)statusBar {
    
    return [[UIApplication sharedApplication] valueForKey:@"statusBar"];
}

#pragma mark --- dealloc method
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
