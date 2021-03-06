//
//  FJDetailContentView.m
//  FJDoubleDeckRollViewDemo
//
//  Created by fjf on 2017/6/9.
//  Copyright © 2017年 fjf. All rights reserved.
//

#import "FJConfigModel.h"
#import "FJCourseClassifyDefine.h"
#import "FJPageCollectionViewCell.h"
#import "FJSegmentedPageDetailContentView.h"
#import "FJContentPageBaseViewController.h"


@interface FJSegmentedPageDetailContentView()<UICollectionViewDataSource, UICollectionViewDelegate>
// page collection
@property (nonatomic, strong) UICollectionView *pageCollectionView;
// page flowLayout
@property (nonatomic, strong) UICollectionViewFlowLayout *pageFlowLayout;
@end

@implementation FJSegmentedPageDetailContentView


#pragma mark --- init method

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.pageCollectionView];
    }
    return self;
}

#pragma makr --- private method

- (void)generateViewControllerArrayWithViewArray:(NSArray *)viewArray {
    
    if (self.viewControllerArray.count == 0) {
        [viewArray enumerateObjectsUsingBlock:^(FJConfigModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            Class clazz = NSClassFromString(obj.viewControllerStr);
            FJContentPageBaseViewController *baseViewController = [[clazz alloc] init];
            baseViewController.currentIndex = idx;
            baseViewController.viewControllerParam = obj.viewControllerParam;
            [self.viewControllerArray addObject:baseViewController];
        }];
    }
}

#pragma mark --- system delegate

/***************************** UICollectionViewDataSource *************************/

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.detailContentViewArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    //页面
    FJPageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kFJPageCollectionViewCellId forIndexPath:indexPath];
    FJContentPageBaseViewController *baseViewController = self.viewControllerArray[indexPath.row];
    [cell configCellWithViewController:baseViewController];
    return cell;
}


/***************************** UIScrollViewDelegate *************************/



// 设置 导航栏 是否 
- (void)setIsOffsetNavigationHeaderViewDelegateWithIsOffset:(BOOL)isOffset {
    if (self.delegate && [self.delegate respondsToSelector:@selector(detailContentView:isOffsetNavigationHeaderView:)]) {
        [self.delegate detailContentView:self isOffsetNavigationHeaderView:isOffset];
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger index = (NSInteger)roundf(scrollView.contentOffset.x / self.pageCollectionView.frame.size.width);
    if (self.viewControllerArray.count > 0) {
        FJContentPageBaseViewController *baseViewController = self.viewControllerArray[index];
        
        if (baseViewController.tableView.contentOffset.y < -kFJNavigationSearchViewHeight) {
            CGFloat tranformTy = [self.delegate navigationTransformTyWithDetailContentView:self];
            if (baseViewController.tableView.contentSize.height > baseViewController.tableView.height && tranformTy < 0) {
                
                [[NSNotificationCenter defaultCenter] postNotificationName:kFJCourseClassifySubScrollViewOffsetNoti object: [NSNumber numberWithBool:YES]];
                CGPoint contentOffset = baseViewController.tableView.contentOffset;
                contentOffset.y = -kFJCourseNavigationHeaderViewHeight - tranformTy;
                baseViewController.tableView.contentOffset = contentOffset;
                [[NSNotificationCenter defaultCenter] postNotificationName:kFJCourseClassifySubScrollViewOffsetNoti object: [NSNumber numberWithBool:NO]];
            }
            else {
                [self setIsOffsetNavigationHeaderViewDelegateWithIsOffset:NO];
            }
        }
    }
    
    NSInteger currentIndex = (NSInteger)roundf(scrollView.contentOffset.x / self.pageCollectionView.frame.size.width);

    if (self.delegate && [self.delegate respondsToSelector:@selector(detailContentView:currentIndex:)]) {
        [self.delegate detailContentView:self currentIndex:currentIndex];
    }
}


/** 滚动减速完成时再更新title的位置 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

     NSInteger currentIndex = (NSInteger)roundf(scrollView.contentOffset.x / self.pageCollectionView.frame.size.width);
    if (self.delegate && [self.delegate respondsToSelector:@selector(detailContentView:currentIndex:)]) {
        [self.delegate detailContentView:self currentIndex:currentIndex];
    }
}


#pragma mark --- setter method
// 设置 选中 索引
- (void)setSelectedIndex:(NSInteger)selectedIndex {
    _selectedIndex = selectedIndex;
    if (CGSizeEqualToSize(self.pageCollectionView.contentSize, CGSizeZero)) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.pageCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:_selectedIndex inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
        });
    }
    else {
        [self.pageCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:_selectedIndex inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    }
    
}

// 内容 viewArray
- (void)setDetailContentViewArray:(NSArray *)detailContentViewArray {
    _detailContentViewArray = detailContentViewArray;
    if (_detailContentViewArray.count > 0) {
        [self generateViewControllerArrayWithViewArray:_detailContentViewArray];
        [self.pageCollectionView reloadData];
    }
}


#pragma mark --- getter method

// viewControll array
- (NSMutableArray <FJContentPageBaseViewController *>*)viewControllerArray {
    if (!_viewControllerArray) {
        _viewControllerArray = [NSMutableArray array];
    }
    return _viewControllerArray;
}

// page flowLayout
- (UICollectionViewFlowLayout *)pageFlowLayout {
    if (!_pageFlowLayout) {
        _pageFlowLayout = [[UICollectionViewFlowLayout alloc] init];
        _pageFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _pageFlowLayout.itemSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
        _pageFlowLayout.minimumLineSpacing = 0;
        _pageFlowLayout.minimumInteritemSpacing = 0;
    }
    return _pageFlowLayout;
}


// page collectionView
- (UICollectionView *)pageCollectionView {
    if (!_pageCollectionView) {
        _pageCollectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:self.pageFlowLayout];
        [_pageCollectionView registerClass:[FJPageCollectionViewCell class] forCellWithReuseIdentifier:kFJPageCollectionViewCellId];
        _pageCollectionView.showsHorizontalScrollIndicator = NO;
        _pageCollectionView.dataSource = self;
        _pageCollectionView.delegate = self;
        _pageCollectionView.bounces = NO;
        _pageCollectionView.pagingEnabled = YES;
        _pageCollectionView.backgroundColor = [UIColor clearColor];
    }
    return _pageCollectionView;
}
@end
