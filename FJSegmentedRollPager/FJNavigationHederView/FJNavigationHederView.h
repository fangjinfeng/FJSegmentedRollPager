//
//  FJNavigationHederView.h
//  FJCourseClassifySectionView
//
//  Created by fjf on 2017/7/20.
//  Copyright © 2017年 fjf. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FJNavigationSearchView;
@class FJTitleTagSectionView;

@interface FJNavigationHederView : UIView
// search view
@property (nonatomic, strong) FJNavigationSearchView *searchView;
// tag sectionView
@property (nonatomic, strong) FJTitleTagSectionView *tagSecionView;


- (void)fj_setImageViewAlpha:(CGFloat)alpha;

- (void)fj_setTranslationY:(CGFloat)translationY;

- (void)fj_moveByTranslationY:(CGFloat)translationY;
@end
