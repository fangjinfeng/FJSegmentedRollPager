
//
//  FJNavigationHederView.m
//  FJCourseClassifySectionView
//
//  Created by fjf on 2017/7/20.
//  Copyright © 2017年 fjf. All rights reserved.
//

#import "FJCourseClassifyDefine.h"
#import "FJNavigationSearchView.h"
#import "FJTitleTagSectionView.h"
#import "FJNavigationHederView.h"


@implementation FJNavigationHederView

#pragma mark --- init method

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupControls];
    }
    return self;
}


#pragma mark --- private method
// 设置 子控件
- (void)setupControls {
    [self addSubview:self.searchView];
    [self addSubview:self.tagSecionView];
    self.backgroundColor = kFJNavigationViewBackgroundColor;
}


#pragma mark --- public method

- (void)fj_setImageViewAlpha:(CGFloat)alpha {
//    self.alpha = alpha;
}

- (void)fj_setTranslationY:(CGFloat)translationY {
    CGFloat transfromTy = self.transform.ty + translationY;
    if (transfromTy > 0) {
        transfromTy = 0;
    }else if(transfromTy < -(self.frame.size.height + 20)){
        transfromTy = -(self.frame.size.height + 20);
    }

    if (transfromTy > -kFJNavigationHederViewContentOffset) {
        self.transform = CGAffineTransformMakeTranslation(0, transfromTy);
    }
    else {
        self.transform = CGAffineTransformMakeTranslation(0, -kFJNavigationHederViewContentOffset);
    }

}


- (void)fj_moveByTranslationY:(CGFloat)translationY {
    
    self.transform = CGAffineTransformMakeTranslation(0, translationY);
}



#pragma mark --- getter method

// 搜索 栏
- (FJNavigationSearchView *)searchView {
    if (!_searchView) {
        _searchView = [[FJNavigationSearchView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, kFJNavigationSearchViewHeight)];
    }
    return _searchView;
}


// 分类 栏
- (FJTitleTagSectionView *)tagSecionView {
    if (!_tagSecionView) {
        _tagSecionView = [[FJTitleTagSectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.searchView.frame), self.frame.size.width, kFJCourseClassifySectionHeight)];
    }
    return _tagSecionView;
}


@end
