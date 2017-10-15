
//
//  FJNavigationSearchView.m
//  FJCourseClassifySectionView
//
//  Created by fjf on 2017/7/20.
//  Copyright © 2017年 fjf. All rights reserved.
//

#import "LETextField.h"
#import "FJCourseClassifyDefine.h"
#import "FJNavigationSearchView.h"


// 顶部 间距
static const CGFloat kFJNavigationTopSpacing = 20.0f;

@interface FJNavigationSearchView()

@end

@implementation FJNavigationSearchView

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
    [self addSubview:self.navigationLeftItemButton];
    [self addSubview:self.searchTextField];
}


#pragma mark --- getter method

// 左边 按键
- (UIButton *)navigationLeftItemButton {
    if (!_navigationLeftItemButton) {
        
        CGFloat buttonWidth = 48.0f;
        CGFloat buttonY = kFJNavigationTopSpacing;
        CGFloat buttonX = self.width - buttonWidth;
        CGFloat buttonHeight = self.height - buttonY;
        _navigationLeftItemButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _navigationLeftItemButton.frame = CGRectMake(buttonX, buttonY, buttonWidth, buttonHeight);
        [_navigationLeftItemButton setImage:[UIImage imageNamed:@"icon_tongyong_zhibidongxiao.png"] forState:UIControlStateNormal];
        //设置重复次数，0表示不重复
        _navigationLeftItemButton.imageView.animationDuration = 1.0f;
        _navigationLeftItemButton.imageView.animationRepeatCount = -1;
        _navigationLeftItemButton.contentEdgeInsets = UIEdgeInsetsMake(0, 6.0f, 0, 0);

    }
    return _navigationLeftItemButton;
}


// 搜索 栏
- (LETextField *)searchTextField {
    if (_searchTextField == nil) {
        
        CGFloat searchTextFieldHeight = 31.0f;
        CGFloat searchTextFieldY = kFJNavigationTopSpacing + (self.height - kFJNavigationTopSpacing) / 2 - (searchTextFieldHeight/2);
        CGFloat searchTextFieldX = 12.0f;
        
        CGFloat searchTextFieldWidth = CGRectGetMinX(self.navigationLeftItemButton.frame) - searchTextFieldX;
        _searchTextField = [[LETextField alloc] init];
        _searchTextField.delegate = self;
        _searchTextField.frame = CGRectMake(searchTextFieldX, searchTextFieldY, searchTextFieldWidth, searchTextFieldHeight);
        _searchTextField.placeholder = @"搜索课程名称";
        
        NSDictionary *attrs = @{NSFontAttributeName : _searchTextField.font};
        CGFloat searchLeftViewOffset = [_searchTextField.placeholder boundingRectWithSize:CGSizeMake(MAXFLOAT, searchTextFieldWidth) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size.width + 15;;
        
        _searchTextField.leftViewOffset = (searchTextFieldWidth/2.0) - (searchLeftViewOffset/2.0);
    }
    return _searchTextField;
}

@end
