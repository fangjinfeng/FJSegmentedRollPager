//
//  FJNavigationSearchView.h
//  FJCourseClassifySectionView
//
//  Created by fjf on 2017/7/20.
//  Copyright © 2017年 fjf. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LETextField;
@interface FJNavigationSearchView : UIView

// 搜索栏
@property (nonatomic, strong) LETextField *searchTextField;

// 左边按键
@property (nonatomic, strong) UIButton *navigationLeftItemButton;
@end
