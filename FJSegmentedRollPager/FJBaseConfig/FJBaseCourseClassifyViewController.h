//
//  FJBaseCourseClassifyViewController.h
//  FJCourseClassifySectionView
//
//  Created by fjf on 2017/7/20.
//  Copyright © 2017年 fjf. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FJConfigModel;

@interface FJBaseCourseClassifyViewController : UIViewController
// 默认 选中 索引(先传入:configModelArray,再设置:selectedIndex)
@property (nonatomic, assign) NSInteger selectedIndex;

// 配置 数据 模型
@property (nonatomic, strong) NSArray <FJConfigModel *>*configModelArray;
@end
