//
//  FJContentPageBaseViewController.m
//  FJDoubleDeckRollViewDemo
//
//  Created by fjf on 2017/6/9.
//  Copyright © 2017年 fjf. All rights reserved.
//

#import "FJCourseClassifyDefine.h"
#import "FJContentPageBaseViewController.h"


@interface FJContentPageBaseViewController ()
// 是否 停止 发送 滚动 通知
@property (nonatomic, assign) BOOL isStopPostScrollNoti;
@end

@implementation FJContentPageBaseViewController
#pragma mark --- life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addDetailContentNotiObserver];
    
    [self setupDetailContentViewControls];
}


#pragma mark --- private method
// 设置 子控件
- (void)setupDetailContentViewControls {
    // 添加 tableView
    [self.view addSubview:self.tableView];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;//UIScrollView也适用
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }

}

// 滚动 到 顶部
- (void)scrollToTopAnimated:(BOOL)animated {
    CGPoint off = self.tableView.contentOffset;
    off.y = 0 - self.tableView.contentInset.top;
    [self.tableView setContentOffset:off animated:animated];
}


// 添加 滚动 到 顶部 监听
- (void)addDetailContentNotiObserver {
    // 滚动 到 顶部
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tableViewScrollToTop:) name:kFJCourseClassifySubScrollViewScrollToTopNoti object:nil];
    // 是否 需要 发送 滚动 通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateScrollNoti:) name:kFJCourseClassifySubScrollViewOffsetNoti object:nil];

}

#pragma mark --- system delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


/************************ UIScrollViewDelegate **********************/

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    if (self.isStopPostScrollNoti == NO) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kFJCourseClassifySubScrollViewDidScrollNoti object:scrollView];
    }
}


#pragma mark --- noti method
// 滚动 到 顶部
- (void)tableViewScrollToTop:(NSNotification *)noti {
    if ([noti.name isEqualToString:kFJCourseClassifySubScrollViewScrollToTopNoti]) {
        NSString *selectedIndex = (NSString *)noti.object;
        if ([selectedIndex isKindOfClass:[NSString class]]) {
            if ([selectedIndex integerValue] == self.currentIndex) {
                [self scrollToTopAnimated:YES];
            }
        }
    }
}

// 更新 滚动 通知
- (void)updateScrollNoti:(NSNotification *)noti {
    if ([noti.name isEqualToString:kFJCourseClassifySubScrollViewOffsetNoti]) {
        self.isStopPostScrollNoti = [noti.object boolValue];
    }
}

#pragma mark --- getter method
// tableView
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -kFJNavigationHederViewContentOffset, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollsToTop = YES;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = kFJTableViewBackgroundColor;
        _tableView.contentInset = UIEdgeInsetsMake(kFJCourseNavigationHeaderViewHeight, 0, 0, 0);
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 49.0f)];
    }
    return _tableView;
}

#pragma mark --- dealloc method
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
